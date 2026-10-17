package com.dmrmod.hooks;

import de.robv.android.xposed.XposedBridge;

/**
 * APRS Packet Decoder - Parse AX.25 UI frames and extract APRS data.
 *
 * Handles (backlog F2, 2026-10-17):
 *  - uncompressed positions  ! = / @   (with the weather-report comment formatted when the symbol is '_')
 *  - compressed positions    (base-91 lat/lon inside ! = / @, with course/speed or altitude)
 *  - Mic-E                   ' `  (and the legacy 0x1C/0x1D type codes): latitude + message bits from the
 *                            destination address, longitude/speed/course from the info bytes, altitude "xxx}"
 *  - objects ;  and items )  (stored under the object name; the sender is kept in the comment)
 *  - messages :              (addressee, text, {id, ack/rej)
 *  - status >                (text only)
 *  - raw NMEA $GPRMC/$GPGGA
 *  - third-party }           (unwrapped once and decoded as the inner packet)
 *  - digipeater path with the H bit ("WIDE1-1*" = already used)
 *
 * Pure Java (no Android classes) so it can run under host JUnit (APRSPacketDecoderTest).
 */
public class APRSPacketDecoder {
    private static final String TAG = "DMRModHooks-APRS-Decoder";

    private static final byte CONTROL_UI = 0x03;
    private static final byte PID_NO_L3 = (byte) 0xF0;

    public static class APRSPacket {
        public String sourceCallsign;
        public int sourceSSID;
        public String destCallsign;
        public int destSSID;
        public String[] digipeaters;
        public String dataType;
        public double latitude;
        public double longitude;
        public int altitude;            // metres, 0 = none (negative Mic-E/compressed altitudes are kept)
        public String comment;
        public char symbolTable;
        public char symbolCode;
        /** True when the frame decoded to something the receiver should act on (position, message or status). */
        public boolean isValid;
        /** True when latitude/longitude were parsed (every stored station needs this). */
        public boolean hasPosition;
        public String rawInfo;

        // --- added 2026-10-17 ---
        public double speedKmh = -1;    // -1 = unknown
        public int courseDeg = -1;      // -1 = unknown
        public String miceStatus;       // "En Route", "Emergency", ... (Mic-E message bits)
        public String objectName;       // for ; and ) — sourceCallsign is then the object name (sanitised)
        public String objectFrom;       // the station that sent the object/item ("CALL-SSID")
        public boolean objectKilled;    // object/item marked deleted ('_')
        public String messageTo;        // ':' addressee (trimmed)
        public String messageText;      // ':' text without the {id
        public String messageId;        // the id after '{', or null
        public boolean isAck;           // message text was "ackNN"
        public boolean isRej;           // message text was "rejNN"
        public String status;           // '>' status text
        public String thirdPartyVia;    // the station that relayed a '}' packet, or null

        public boolean isMessage() { return messageTo != null; }

        @Override
        public String toString() {
            if (!isValid) {
                return "Invalid APRS packet";
            }
            StringBuilder sb = new StringBuilder();
            sb.append(sourceCallsign).append('-').append(sourceSSID).append(": ");
            if (isMessage()) {
                sb.append("msg to ").append(messageTo).append(" \"").append(messageText).append('"');
                if (messageId != null) sb.append(" {").append(messageId);
                return sb.toString();
            }
            if (hasPosition) {
                sb.append(String.format(java.util.Locale.US, "%.6f, %.6f", latitude, longitude));
                if (altitude != 0) sb.append(" @ ").append(altitude).append('m');
                if (speedKmh >= 0) sb.append(String.format(java.util.Locale.US, " %.0f km/h", speedKmh));
                if (courseDeg >= 0) sb.append(' ').append(courseDeg).append("°");
            } else if (status != null) {
                sb.append("status \"").append(status).append('"');
            }
            if (comment != null && !comment.isEmpty()) sb.append(" - ").append(comment);
            return sb.toString();
        }
    }

    /**
     * Decode AX.25 packet into APRS data
     */
    public static APRSPacket decode(byte[] packet) {
        APRSPacket result = new APRSPacket();
        result.isValid = false;

        try {
            if (packet == null || packet.length < 16) {
                XposedBridge.log(TAG + ": Packet too short");
                return result;
            }

            int offset = 0;

            // Parse destination address (7 bytes)
            result.destCallsign = extractCallsign(packet, offset);
            result.destSSID = (packet[offset + 6] >> 1) & 0x0F;
            String destRaw = extractRawAddress(packet, offset);   // Mic-E needs the 6 chars verbatim
            offset += 7;

            // Parse source address (7 bytes)
            result.sourceCallsign = extractCallsign(packet, offset);
            result.sourceSSID = (packet[offset + 6] >> 1) & 0x0F;
            boolean lastAddress = ((packet[offset + 6] & 0x01) != 0);
            offset += 7;

            // Parse digipeater addresses (if any). The H bit (0x80 of the SSID byte) marks a
            // digipeater that has already repeated the frame — shown as a trailing '*' like TNC2.
            java.util.ArrayList<String> digiList = new java.util.ArrayList<>();
            while (!lastAddress && offset + 7 <= packet.length) {
                String digi = extractCallsign(packet, offset);
                int digiSSID = (packet[offset + 6] >> 1) & 0x0F;
                boolean used = (packet[offset + 6] & 0x80) != 0;
                digiList.add(digi + (digiSSID != 0 ? "-" + digiSSID : "") + (used ? "*" : ""));
                lastAddress = ((packet[offset + 6] & 0x01) != 0);
                offset += 7;
            }
            result.digipeaters = digiList.toArray(new String[0]);

            // Check control and PID
            if (offset + 2 > packet.length) {
                XposedBridge.log(TAG + ": Packet truncated before control/PID");
                return result;
            }

            byte control = packet[offset++];
            byte pid = packet[offset++];

            if (control != CONTROL_UI || pid != PID_NO_L3) {
                XposedBridge.log(TAG + ": Not a UI frame or wrong PID");
                return result;
            }

            // Parse information field (APRS data) — ISO-8859-1 keeps every byte as one char
            if (offset >= packet.length) {
                XposedBridge.log(TAG + ": No information field");
                return result;
            }

            String info = new String(packet, offset, packet.length - offset, java.nio.charset.StandardCharsets.ISO_8859_1);
            result.rawInfo = info;

            decodeInfo(info, destRaw, result);

            if (result.isValid) {
                XposedBridge.log(TAG + ": Decoded: " + result.toString());
            }

        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error decoding packet: " + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }

    /**
     * Decode a TNC2-style text packet ("SRC>DST,PATH:info"). Used for third-party frames and tests.
     */
    public static APRSPacket decodeTnc2(String tnc2) {
        APRSPacket result = new APRSPacket();
        try {
            int gt = tnc2.indexOf('>');
            int colon = tnc2.indexOf(':', gt);
            if (gt <= 0 || colon < 0) return result;
            String src = tnc2.substring(0, gt).trim();
            String hdr = tnc2.substring(gt + 1, colon);
            String[] parts = hdr.split(",");
            String dst = parts[0].trim();
            int dash = src.indexOf('-');
            result.sourceCallsign = dash > 0 ? src.substring(0, dash) : src;
            result.sourceSSID = dash > 0 ? parseIntSafe(src.substring(dash + 1), 0) : 0;
            dash = dst.indexOf('-');
            result.destCallsign = dash > 0 ? dst.substring(0, dash) : dst;
            result.destSSID = dash > 0 ? parseIntSafe(dst.substring(dash + 1), 0) : 0;
            result.digipeaters = new String[Math.max(0, parts.length - 1)];
            for (int i = 1; i < parts.length; i++) result.digipeaters[i - 1] = parts[i].trim();
            String info = tnc2.substring(colon + 1);
            result.rawInfo = info;
            String destRaw = (result.destCallsign + "      ").substring(0, 6);
            decodeInfo(info, destRaw, result);
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error decoding TNC2 text: " + e.getMessage());
        }
        return result;
    }

    // ------------------------------------------------------------------------------------------
    // Information field
    // ------------------------------------------------------------------------------------------

    private static void decodeInfo(String info, String destRaw, APRSPacket result) {
        if (info == null) return;
        // Some TNCs/trackers terminate the info field with CR and/or LF — never part of the data
        int end = info.length();
        while (end > 0 && (info.charAt(end - 1) == '\r' || info.charAt(end - 1) == '\n')) end--;
        info = info.substring(0, end);
        if (info.isEmpty()) return;

        char dataTypeId = info.charAt(0);
        result.dataType = String.valueOf(dataTypeId);

        switch (dataTypeId) {
            case '!': case '=': case '/': case '@':
                parsePositionReport(info, result);
                break;
            case '\'': case '`': case 0x1C: case 0x1D:
                parseMicE(info, destRaw, result);
                break;
            case ';':
                parseObject(info, result);
                break;
            case ')':
                parseItem(info, result);
                break;
            case ':':
                parseMessage(info, result);
                break;
            case '>':
                parseStatus(info, result);
                break;
            case '$':
                parseNmea(info, result);
                break;
            case '}':
                parseThirdParty(info, result);
                return;     // the inner decode already set validity
            case '_':
                // Positionless weather report: nothing to plot, keep the raw text as a comment
                result.comment = formatWeather(info.substring(1));
                XposedBridge.log(TAG + ": Positionless weather from " + result.sourceCallsign + " (not stored)");
                return;
            default:
                XposedBridge.log(TAG + ": Unsupported data type: " + dataTypeId);
                return;
        }

        // A position report whose coordinates failed to parse used to be stored at 0,0 and plotted
        // in the Gulf of Guinea (backlog S9): only a parsed position counts as one.
        if (result.hasPosition && result.latitude == 0.0 && result.longitude == 0.0) {
            result.hasPosition = false;
        }
        if (result.hasPosition && (Math.abs(result.latitude) > 90.0 || Math.abs(result.longitude) > 180.0)) {
            XposedBridge.log(TAG + ": Position out of range from " + result.sourceCallsign + " - ignored");
            result.hasPosition = false;
        }
        result.isValid = result.hasPosition || result.isMessage() || result.status != null;
        if (!result.isValid && !result.isMessage()) {
            XposedBridge.log(TAG + ": " + dataTypeId + " packet from " + result.sourceCallsign + " without usable content");
        }
    }

    /**
     * Extract callsign from address field (6 bytes + SSID byte)
     */
    private static String extractCallsign(byte[] packet, int offset) {
        StringBuilder callsign = new StringBuilder();

        for (int i = 0; i < 6; i++) {
            char c = (char) ((packet[offset + i] & 0xFF) >> 1);
            if (c != ' ') {
                callsign.append(c);
            }
        }

        return callsign.toString().trim();
    }

    /** The 6 address characters verbatim (spaces kept) — Mic-E encodes the latitude in them. */
    private static String extractRawAddress(byte[] packet, int offset) {
        StringBuilder sb = new StringBuilder(6);
        for (int i = 0; i < 6; i++) sb.append((char) ((packet[offset + i] & 0xFF) >> 1));
        return sb.toString();
    }

    // ------------------------------------------------------------------------------------------
    // Uncompressed / compressed positions
    // ------------------------------------------------------------------------------------------

    /**
     * Parse position report (!, =, /, @)
     */
    private static void parsePositionReport(String info, APRSPacket result) {
        try {
            int offset = 1;  // Skip data type identifier

            // Check for timestamp (/ or @)
            if (info.charAt(0) == '/' || info.charAt(0) == '@') {
                // Skip 7-character timestamp (DHM or HMS format)
                if (info.length() < 8) return;
                offset += 7;
            }

            offset = parsePositionBody(info, offset, result);
            if (offset < 0) return;

            // Rest is comment (may include altitude, course/speed, weather)
            if (offset < info.length()) {
                parseComment(info.substring(offset), result);
            }

        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error parsing position: " + e.getMessage());
        }
    }

    /**
     * Parses an uncompressed (DDMM.HHN/DDDMM.HHE$) or compressed (/YYYYXXXX$csT) position body at
     * {@code offset}. Sets latitude/longitude/symbol/hasPosition. Returns the offset of the first
     * comment character, or -1 when nothing parsable was found.
     */
    private static int parsePositionBody(String info, int offset, APRSPacket result) {
        if (offset >= info.length()) return -1;
        char first = info.charAt(offset);
        boolean compressed = !(Character.isDigit(first) || first == ' ');
        if (compressed) {
            // Compressed: table(1) lat(4) lon(4) code(1) cs(2) T(1) = 13 chars
            if (info.length() < offset + 13) {
                XposedBridge.log(TAG + ": Compressed position string too short");
                return -1;
            }
            result.symbolTable = first;
            int latN = base91(info, offset + 1, 4);
            int lonN = base91(info, offset + 5, 4);
            if (latN < 0 || lonN < 0) {
                XposedBridge.log(TAG + ": Compressed position has bad base-91 digits");
                return -1;
            }
            result.latitude = 90.0 - latN / 380926.0;
            result.longitude = -180.0 + lonN / 190463.0;
            result.symbolCode = info.charAt(offset + 9);
            char c = info.charAt(offset + 10), s = info.charAt(offset + 11), t = info.charAt(offset + 12);
            if (c != ' ') {
                int cv = c - 33, sv = s - 33;
                int nmeaSrc = ((t - 33) >> 3) & 0x03;      // 2 = GGA → altitude
                if (c == '{') {
                    // pre-calculated radio range: 2 * 1.08^s miles — ignore
                } else if (nmeaSrc == 2) {
                    double altFt = Math.pow(1.002, cv * 91 + sv);
                    result.altitude = (int) Math.round(altFt * 0.3048);
                } else if (cv >= 0 && cv < 90) {
                    result.courseDeg = cv * 4;
                    result.speedKmh = (Math.pow(1.08, sv) - 1.0) * 1.852;
                }
            }
            result.hasPosition = true;
            return offset + 13;
        }

        // Uncompressed: need at least 19 characters (lat + table + lon + symbol)
        if (info.length() < offset + 19) {
            XposedBridge.log(TAG + ": Position string too short");
            return -1;
        }
        String latStr = info.substring(offset, offset + 8);
        result.latitude = parseLatitude(latStr);
        offset += 8;
        result.symbolTable = info.charAt(offset);
        offset++;
        String lonStr = info.substring(offset, offset + 9);
        result.longitude = parseLongitude(lonStr);
        offset += 9;
        result.symbolCode = info.charAt(offset);
        offset++;
        result.hasPosition = !Double.isNaN(result.latitude) && !Double.isNaN(result.longitude);
        if (!result.hasPosition) { result.latitude = 0; result.longitude = 0; }
        return offset;
    }

    /**
     * Comment after a position: "CSE/SPD" course/speed, "/A=nnnnnn" altitude (feet), weather data
     * when the symbol is '_'. What is left becomes {@code comment}.
     */
    private static void parseComment(String remainder, APRSPacket result) {
        String rest = remainder;
        if (result.symbolCode == '_' && rest.length() >= 7 && isWeatherStart(rest)) {
            result.comment = formatWeather(rest);
            return;
        }
        // Course/speed "ddd/sss" at the very start of the comment (also PHG etc. are left as text)
        if (rest.length() >= 7 && rest.charAt(3) == '/' && isDigits(rest, 0, 3) && isDigits(rest, 4, 7)) {
            int cse = Integer.parseInt(rest.substring(0, 3));
            int spd = Integer.parseInt(rest.substring(4, 7));
            if (cse >= 0 && cse <= 360) { result.courseDeg = cse % 360; result.speedKmh = spd * 1.852; }
            rest = rest.substring(7);
        }
        // Altitude /A=nnnnnn (feet, may be negative)
        int altIndex = rest.indexOf("/A=");
        if (altIndex >= 0 && altIndex + 9 <= rest.length()) {
            try {
                String altStr = rest.substring(altIndex + 3, altIndex + 9);
                result.altitude = (int) Math.round(Integer.parseInt(altStr.trim()) * 0.3048);
                rest = rest.substring(0, altIndex) + rest.substring(altIndex + 9);
            } catch (NumberFormatException e) {
                // Altitude parsing failed, ignore
            }
        }
        // DAO extension "!W..!" / "!w..!" — extra precision we don't use; drop it from the text
        int dao = rest.indexOf("!W");
        if (dao < 0) dao = rest.indexOf("!w");
        if (dao >= 0 && dao + 5 <= rest.length() && rest.charAt(dao + 4) == '!') {
            rest = rest.substring(0, dao) + rest.substring(dao + 5);
        }
        result.comment = rest.trim();
    }

    private static boolean isWeatherStart(String s) {
        // "ddd/dddg" (wind dir/speed, gust) or "c..." (DIR/SPD alternative with 'c' prefix)
        return (s.length() >= 8 && s.charAt(3) == '/' && isDigits(s, 0, 3) && isDigits(s, 4, 7) && s.charAt(7) == 'g')
                || s.charAt(0) == 'c';
    }

    /**
     * Turns raw APRS weather fields (cDDDsSSSgGGGtTTTrRRRpPPPPPPPhHHbBBBBB, or DDD/SSSg...) into
     * readable text. Fields with "..." (no data) are skipped.
     */
    static String formatWeather(String w) {
        StringBuilder sb = new StringBuilder();
        String s = w;
        // Optional leading timestamp (MDHM) in positionless reports
        if (s.length() >= 8 && isDigits(s, 0, 8)) s = s.substring(8);
        Integer dir = null, spd = null;
        if (s.length() >= 7 && s.charAt(3) == '/' && isDigits(s, 0, 3) && isDigits(s, 4, 7)) {
            dir = Integer.parseInt(s.substring(0, 3)); spd = Integer.parseInt(s.substring(4, 7));
            s = s.substring(7);
        }
        java.util.LinkedHashMap<Character, String> f = new java.util.LinkedHashMap<>();
        int i = 0;
        while (i < s.length()) {
            char k = s.charAt(i);
            int len;
            switch (k) {
                case 'c': case 's': case 'g': case 't': case 'r': case 'p': case 'P': case 'L': case 'l': len = 3; break;
                case 'h': len = 2; break;
                case 'b': len = 5; break;
                case 'S': len = 3; break;
                default: len = -1;
            }
            if (len < 0 || i + 1 + len > s.length()) break;
            f.put(k, s.substring(i + 1, i + 1 + len));
            i += 1 + len;
        }
        if (f.containsKey('c')) dir = numOrNull(f.get('c'));
        if (f.containsKey('s')) spd = numOrNull(f.get('s'));
        Integer t = numOrNull(f.get('t')), g = numOrNull(f.get('g')), h = numOrNull(f.get('h'));
        Integer r = numOrNull(f.get('r')), p = numOrNull(f.get('p')), b = numOrNull(f.get('b'));
        if (t != null) sb.append(t).append("°F ");
        if (dir != null || spd != null) {
            sb.append("wind ");
            if (dir != null) sb.append(dir).append("° ");
            if (spd != null) sb.append(spd).append(" mph ");
            if (g != null) sb.append("gust ").append(g).append(" ");
        }
        if (h != null) sb.append("hum ").append(h == 0 ? 100 : h).append("% ");
        if (b != null) sb.append(String.format(java.util.Locale.US, "%.1f mb ", b / 10.0));
        if (r != null && r > 0) sb.append(String.format(java.util.Locale.US, "rain 1h %.2f\" ", r / 100.0));
        if (p != null && p > 0) sb.append(String.format(java.util.Locale.US, "rain 24h %.2f\" ", p / 100.0));
        String rest = s.substring(Math.min(i, s.length())).trim();
        String out = sb.toString().trim();
        if (out.isEmpty()) return w.trim();
        return rest.isEmpty() ? "WX: " + out : "WX: " + out + " (" + rest + ")";
    }

    private static Integer numOrNull(String v) {
        if (v == null) return null;
        try { return Integer.parseInt(v.trim()); } catch (NumberFormatException e) { return null; }
    }

    // ------------------------------------------------------------------------------------------
    // Mic-E
    // ------------------------------------------------------------------------------------------

    private static final String[] MICE_STD = {
        "Emergency", "Priority", "Special", "Committed", "Returning", "In Service", "En Route", "Off Duty" };
    private static final String[] MICE_CUSTOM = {
        "Emergency", "Custom-6", "Custom-5", "Custom-4", "Custom-3", "Custom-2", "Custom-1", "Custom-0" };

    /**
     * Mic-E: the destination address carries the latitude (6 digits), the three message bits, N/S,
     * the +100 longitude offset and W/E; the info field carries longitude (3 bytes), speed/course
     * (3 bytes), symbol code and table, then an optional altitude "xxx}" and comment.
     */
    private static void parseMicE(String info, String dest, APRSPacket result) {
        try {
            if (dest == null || dest.length() < 6 || info.length() < 9) {
                XposedBridge.log(TAG + ": Mic-E packet too short");
                return;
            }
            int[] digit = new int[6];
            int msgBits = 0;        // A B C from dest[0..2]
            boolean custom = false, std = false;
            boolean north = false, west = false;
            int lonOffset = 0;
            for (int i = 0; i < 6; i++) {
                char c = dest.charAt(i);
                int d; boolean bit; boolean isStd = false, isCustom = false;
                if (c >= '0' && c <= '9') { d = c - '0'; bit = false; }
                else if (c >= 'A' && c <= 'J') { d = c - 'A'; bit = true; isCustom = true; }
                else if (c == 'K') { d = 0; bit = true; isCustom = true; }
                else if (c == 'L') { d = 0; bit = false; }
                else if (c >= 'P' && c <= 'Y') { d = c - 'P'; bit = true; isStd = true; }
                else if (c == 'Z') { d = 0; bit = true; isStd = true; }
                else {
                    XposedBridge.log(TAG + ": Mic-E destination has an invalid character: " + dest);
                    return;
                }
                digit[i] = d;
                if (i < 3) {
                    if (bit) msgBits |= (4 >> i);
                    custom |= isCustom; std |= isStd;
                } else if (i == 3) {
                    north = (c >= 'P');            // P-Z = North
                } else if (i == 4) {
                    lonOffset = (c >= 'P') ? 100 : 0;
                } else {
                    west = (c >= 'P');             // P-Z = West
                }
            }
            double lat = digit[0] * 10 + digit[1] + (digit[2] * 10 + digit[3] + (digit[4] * 10 + digit[5]) / 100.0) / 60.0;
            if (!north) lat = -lat;
            result.miceStatus = custom && !std ? MICE_CUSTOM[msgBits] : MICE_STD[msgBits];

            int d = (info.charAt(1) & 0xFF) - 28 + lonOffset;
            if (d >= 180 && d <= 189) d -= 80;
            else if (d >= 190 && d <= 199) d -= 190;
            int m = (info.charAt(2) & 0xFF) - 28;
            if (m >= 60) m -= 60;
            int h = (info.charAt(3) & 0xFF) - 28;
            if (d < 0 || d > 180 || m < 0 || m > 59 || h < 0 || h > 99) {
                XposedBridge.log(TAG + ": Mic-E longitude out of range (" + d + " " + m + "." + h + ")");
                return;
            }
            double lon = d + (m + h / 100.0) / 60.0;
            if (west) lon = -lon;

            int sp = (info.charAt(4) & 0xFF) - 28;
            int dc = (info.charAt(5) & 0xFF) - 28;
            int se = (info.charAt(6) & 0xFF) - 28;
            int speedKt = sp * 10 + dc / 10;
            int course = (dc % 10) * 100 + se;
            if (speedKt >= 800) speedKt -= 800;
            if (course >= 400) course -= 400;
            if (speedKt >= 0 && speedKt < 800) result.speedKmh = speedKt * 1.852;
            if (course >= 0 && course <= 360) result.courseDeg = course % 360;

            result.symbolCode = info.charAt(7);
            result.symbolTable = info.charAt(8);
            result.latitude = lat;
            result.longitude = lon;
            result.hasPosition = true;

            // Optional: device-type prefix, altitude "xxx}", comment, device-type suffix
            String rest = info.length() > 9 ? info.substring(9) : "";
            if (!rest.isEmpty()) {
                char c0 = rest.charAt(0);
                if (c0 == '>' || c0 == ']' || c0 == '`' || c0 == '\'') rest = rest.substring(1);   // Kenwood/Yaesu type code
                int brace = rest.indexOf('}');
                if (brace >= 3) {
                    int a = base91(rest, brace - 3, 3);
                    if (a >= 0) {
                        result.altitude = a - 10000;
                        rest = rest.substring(0, brace - 3) + rest.substring(brace + 1);
                        // some radios put the type code after the altitude
                        if (!rest.isEmpty()) {
                            c0 = rest.charAt(0);
                            if (c0 == '>' || c0 == ']' || c0 == '`' || c0 == '\'') rest = rest.substring(1);
                        }
                    }
                }
                // Trailing device-type suffix (e.g. "=" TH-D72, "^" TH-D74, "_%" Yaesu) — one or two chars
                if (rest.length() >= 2 && rest.charAt(rest.length() - 2) == '_') rest = rest.substring(0, rest.length() - 2);
                else if (rest.length() >= 1) {
                    char last = rest.charAt(rest.length() - 1);
                    if (last == '=' || last == '^' || last == 'v' || last == '_') rest = rest.substring(0, rest.length() - 1);
                }
                // Legacy telemetry channels (0x1C/0x1D type codes) carry binary — drop anything non-printable
                StringBuilder clean = new StringBuilder();
                for (int i = 0; i < rest.length(); i++) {
                    char c = rest.charAt(i);
                    if (c >= 0x20 && c < 0x7F) clean.append(c);
                }
                result.comment = clean.toString().trim();
            }
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error parsing Mic-E: " + e.getMessage());
        }
    }

    // ------------------------------------------------------------------------------------------
    // Objects, items, messages, status, NMEA, third-party
    // ------------------------------------------------------------------------------------------

    /** ;NAME(9)*|_ TIMESTAMP(7) position [comment] */
    private static void parseObject(String info, APRSPacket result) {
        if (info.length() < 1 + 9 + 1 + 7 + 19 - 6) {   // allow compressed (13) bodies
            XposedBridge.log(TAG + ": Object too short");
            return;
        }
        String name = info.substring(1, 10).trim();
        char live = info.charAt(10);
        result.objectKilled = (live == '_');
        int offset = 11 + 7;    // timestamp
        int end = parsePositionBody(info, offset, result);
        if (end < 0) return;
        adoptObject(name, result);
        if (end < info.length()) parseComment(info.substring(end), result);
        result.comment = objectPrefix(result) + (result.comment == null ? "" : result.comment);
    }

    /** )NAME(3-9)!|_ position [comment] */
    private static void parseItem(String info, APRSPacket result) {
        int i = 1;
        while (i < info.length() && info.charAt(i) != '!' && info.charAt(i) != '_' && i <= 10) i++;
        if (i >= info.length() || i < 4 || (info.charAt(i) != '!' && info.charAt(i) != '_')) {
            XposedBridge.log(TAG + ": Item without a valid name");
            return;
        }
        String name = info.substring(1, i).trim();
        result.objectKilled = (info.charAt(i) == '_');
        int end = parsePositionBody(info, i + 1, result);
        if (end < 0) return;
        adoptObject(name, result);
        if (end < info.length()) parseComment(info.substring(end), result);
        result.comment = objectPrefix(result) + (result.comment == null ? "" : result.comment);
    }

    /** The object becomes the "station": its name is the callsign (sanitised for file names), SSID 0. */
    private static void adoptObject(String name, APRSPacket result) {
        result.objectName = name;
        result.objectFrom = result.sourceCallsign + "-" + result.sourceSSID;
        result.sourceCallsign = name.replaceAll("[^A-Za-z0-9_.-]", "_");
        result.sourceSSID = 0;
    }

    private static String objectPrefix(APRSPacket r) {
        return "[" + (r.objectKilled ? "deleted object" : "object") + " from " + r.objectFrom + "] ";
    }

    /** :ADDRESSEE(9):text[{id]  — also "ackNN" / "rejNN" */
    private static void parseMessage(String info, APRSPacket result) {
        if (info.length() < 11 || info.charAt(10) != ':') {
            XposedBridge.log(TAG + ": Malformed message (no addressee)");
            return;
        }
        result.messageTo = info.substring(1, 10).trim();
        String text = info.substring(11);
        int brace = text.lastIndexOf('{');
        if (brace >= 0 && brace >= text.length() - 6) {
            result.messageId = text.substring(brace + 1).trim();
            text = text.substring(0, brace);
        }
        if (text.startsWith("ack") && text.length() <= 8 && text.length() > 3) {
            result.isAck = true; result.messageId = text.substring(3).trim();
        } else if (text.startsWith("rej") && text.length() <= 8 && text.length() > 3) {
            result.isRej = true; result.messageId = text.substring(3).trim();
        }
        result.messageText = text;
    }

    /** >[timestamp]status text */
    private static void parseStatus(String info, APRSPacket result) {
        String s = info.substring(1);
        if (s.length() >= 7 && s.charAt(6) == 'z' && isDigits(s, 0, 6)) s = s.substring(7);
        result.status = s.trim();
    }

    /** $GPRMC / $GPGGA raw NMEA */
    private static void parseNmea(String info, APRSPacket result) {
        try {
            String[] f = info.split(",");
            if (f.length < 7) return;
            String latS, latH, lonS, lonH;
            if (f[0].endsWith("RMC")) {
                if (f.length < 9 || !"A".equals(f[2])) return;    // void fix
                latS = f[3]; latH = f[4]; lonS = f[5]; lonH = f[6];
                if (!f[7].isEmpty()) result.speedKmh = Double.parseDouble(f[7]) * 1.852;
                if (!f[8].isEmpty()) result.courseDeg = (int) Math.round(Double.parseDouble(f[8])) % 360;
            } else if (f[0].endsWith("GGA")) {
                if (f.length < 10 || "0".equals(f[6])) return;
                latS = f[2]; latH = f[3]; lonS = f[4]; lonH = f[5];
                if (!f[9].isEmpty()) result.altitude = (int) Math.round(Double.parseDouble(f[9]));
            } else {
                XposedBridge.log(TAG + ": NMEA sentence not handled: " + f[0]);
                return;
            }
            if (latS.length() < 4 || lonS.length() < 5) return;
            double lat = Integer.parseInt(latS.substring(0, 2)) + Double.parseDouble(latS.substring(2)) / 60.0;
            double lon = Integer.parseInt(lonS.substring(0, 3)) + Double.parseDouble(lonS.substring(3)) / 60.0;
            if ("S".equals(latH)) lat = -lat;
            if ("W".equals(lonH)) lon = -lon;
            result.latitude = lat; result.longitude = lon; result.hasPosition = true;
            result.symbolTable = '/'; result.symbolCode = '>';   // car — the usual NMEA tracker
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error parsing NMEA: " + e.getMessage());
        }
    }

    /** }SRC>DST,PATH:info — one level of unwrapping (the relaying station is kept in thirdPartyVia). */
    private static void parseThirdParty(String info, APRSPacket result) {
        String via = result.sourceCallsign + "-" + result.sourceSSID;
        APRSPacket inner = decodeTnc2(info.substring(1));
        if (inner.dataType != null && inner.dataType.equals("}")) inner.isValid = false;   // no nesting
        // copy the inner packet into result
        result.sourceCallsign = inner.sourceCallsign; result.sourceSSID = inner.sourceSSID;
        result.destCallsign = inner.destCallsign; result.destSSID = inner.destSSID;
        result.digipeaters = inner.digipeaters; result.dataType = inner.dataType;
        result.latitude = inner.latitude; result.longitude = inner.longitude; result.altitude = inner.altitude;
        result.comment = inner.comment; result.symbolTable = inner.symbolTable; result.symbolCode = inner.symbolCode;
        result.isValid = inner.isValid; result.hasPosition = inner.hasPosition;
        result.speedKmh = inner.speedKmh; result.courseDeg = inner.courseDeg; result.miceStatus = inner.miceStatus;
        result.objectName = inner.objectName; result.objectFrom = inner.objectFrom; result.objectKilled = inner.objectKilled;
        result.messageTo = inner.messageTo; result.messageText = inner.messageText; result.messageId = inner.messageId;
        result.isAck = inner.isAck; result.isRej = inner.isRej; result.status = inner.status;
        result.thirdPartyVia = via;
    }

    /**
     * One-line description of the non-position extras for the stored comment / station list:
     * Mic-E status, speed/course, relay, then the comment itself.
     */
    public static String describe(APRSPacket p) {
        StringBuilder sb = new StringBuilder();
        if (p.miceStatus != null && !"Off Duty".equals(p.miceStatus)) sb.append('[').append(p.miceStatus).append("] ");
        if (p.speedKmh >= 0 || p.courseDeg >= 0) {
            if (p.speedKmh >= 0) sb.append(String.format(java.util.Locale.US, "%.0f km/h", p.speedKmh));
            if (p.courseDeg >= 0) sb.append(p.speedKmh >= 0 ? " " : "").append(p.courseDeg).append("°");
            sb.append(" · ");
        }
        if (p.thirdPartyVia != null) sb.append("[via ").append(p.thirdPartyVia).append("] ");
        if (p.comment != null) sb.append(p.comment);
        String s = sb.toString().trim();
        if (s.endsWith("·")) s = s.substring(0, s.length() - 1).trim();
        return s;
    }

    // ------------------------------------------------------------------------------------------
    // Helpers
    // ------------------------------------------------------------------------------------------

    /** Base-91 value of {@code n} chars at {@code off}; -1 if any char is outside '!'..'{'. */
    private static int base91(String s, int off, int n) {
        int v = 0;
        for (int i = 0; i < n; i++) {
            int c = s.charAt(off + i) - 33;
            if (c < 0 || c > 90) return -1;
            v = v * 91 + c;
        }
        return v;
    }

    private static boolean isDigits(String s, int from, int to) {
        if (to > s.length()) return false;
        for (int i = from; i < to; i++) if (!Character.isDigit(s.charAt(i))) return false;
        return true;
    }

    private static int parseIntSafe(String s, int dflt) {
        try { return Integer.parseInt(s.trim()); } catch (NumberFormatException e) { return dflt; }
    }

    /**
     * Parse latitude from APRS format (DDMM.HHN) to decimal degrees. Ambiguity spaces read as 0.
     * Returns NaN when the field is not a latitude.
     */
    private static double parseLatitude(String latStr) {
        try {
            String s = latStr.replace(' ', '0');
            int degrees = Integer.parseInt(s.substring(0, 2));
            double minutes = Double.parseDouble(s.substring(2, 7));
            char hemisphere = s.charAt(7);
            if (degrees > 90 || minutes >= 60 || (hemisphere != 'N' && hemisphere != 'S')) return Double.NaN;
            double latitude = degrees + (minutes / 60.0);
            return hemisphere == 'S' ? -latitude : latitude;
        } catch (Exception e) {
            return Double.NaN;
        }
    }

    /**
     * Parse longitude from APRS format (DDDMM.HHE) to decimal degrees. Returns NaN when invalid.
     */
    private static double parseLongitude(String lonStr) {
        try {
            String s = lonStr.replace(' ', '0');
            int degrees = Integer.parseInt(s.substring(0, 3));
            double minutes = Double.parseDouble(s.substring(3, 8));
            char hemisphere = s.charAt(8);
            if (degrees > 180 || minutes >= 60 || (hemisphere != 'E' && hemisphere != 'W')) return Double.NaN;
            double longitude = degrees + (minutes / 60.0);
            return hemisphere == 'W' ? -longitude : longitude;
        } catch (Exception e) {
            return Double.NaN;
        }
    }
}
