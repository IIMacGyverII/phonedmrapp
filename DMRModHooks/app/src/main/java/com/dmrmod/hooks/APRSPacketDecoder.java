package com.dmrmod.hooks;

import de.robv.android.xposed.XposedBridge;

/**
 * APRS Packet Decoder - Parse AX.25 frames and extract APRS data
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
        public int altitude;
        public String comment;
        public char symbolTable;
        public char symbolCode;
        public boolean isValid;
        public String rawInfo;
        
        @Override
        public String toString() {
            if (!isValid) {
                return "Invalid APRS packet";
            }
            return sourceCallsign + "-" + sourceSSID + ": " + 
                   String.format("%.6f, %.6f", latitude, longitude) + 
                   (altitude > 0 ? " @ " + altitude + "m" : "") +
                   (comment != null && !comment.isEmpty() ? " - " + comment : "");
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
            offset += 7;
            
            // Parse source address (7 bytes)
            result.sourceCallsign = extractCallsign(packet, offset);
            result.sourceSSID = (packet[offset + 6] >> 1) & 0x0F;
            boolean lastAddress = ((packet[offset + 6] & 0x01) != 0);
            offset += 7;
            
            // Parse digipeater addresses (if any)
            java.util.ArrayList<String> digiList = new java.util.ArrayList<>();
            while (!lastAddress && offset + 7 <= packet.length) {
                String digi = extractCallsign(packet, offset);
                int digiSSID = (packet[offset + 6] >> 1) & 0x0F;
                digiList.add(digi + "-" + digiSSID);
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
            
            // Parse information field (APRS data)
            if (offset >= packet.length) {
                XposedBridge.log(TAG + ": No information field");
                return result;
            }
            
            String info = new String(packet, offset, packet.length - offset);
            result.rawInfo = info;
            
            // Parse APRS data based on data type identifier
            if (info.length() < 1) {
                return result;
            }
            
            char dataTypeId = info.charAt(0);
            result.dataType = String.valueOf(dataTypeId);
            
            // Position without timestamp: ! or =
            // Position with timestamp: / or @
            if (dataTypeId == '!' || dataTypeId == '=' || dataTypeId == '/' || dataTypeId == '@') {
                parsePositionReport(info, result);
            } else {
                XposedBridge.log(TAG + ": Unsupported data type: " + dataTypeId);
                return result;
            }
            
            result.isValid = true;
            XposedBridge.log(TAG + ": Decoded: " + result.toString());
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error decoding packet: " + e.getMessage());
            e.printStackTrace();
        }
        
        return result;
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
            
            // Position format: DDMM.HHN/DDDMM.HHE[
            // Need at least 19 characters (lat + / + lon + symbol)
            if (info.length() < offset + 19) {
                XposedBridge.log(TAG + ": Position string too short");
                return;
            }
            
            // Parse latitude (DDMM.HHN)
            String latStr = info.substring(offset, offset + 8);
            result.latitude = parseLatitude(latStr);
            offset += 8;
            
            // Symbol table character
            result.symbolTable = info.charAt(offset);
            offset++;
            
            // Parse longitude (DDDMM.HHE)
            String lonStr = info.substring(offset, offset + 9);
            result.longitude = parseLongitude(lonStr);
            offset += 9;
            
            // Symbol code character
            result.symbolCode = info.charAt(offset);
            offset++;
            
            // Rest is comment (may include altitude)
            if (offset < info.length()) {
                String remainder = info.substring(offset);
                
                // Look for altitude in format /A=XXXXXX
                int altIndex = remainder.indexOf("/A=");
                if (altIndex >= 0 && altIndex + 9 <= remainder.length()) {
                    try {
                        String altStr = remainder.substring(altIndex + 3, altIndex + 9);
                        result.altitude = (int) (Integer.parseInt(altStr) * 0.3048); // feet to meters
                    } catch (NumberFormatException e) {
                        // Altitude parsing failed, ignore
                    }
                    
                    // Comment is everything before altitude
                    result.comment = remainder.substring(0, altIndex).trim();
                } else {
                    result.comment = remainder.trim();
                }
            }
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error parsing position: " + e.getMessage());
        }
    }
    
    /**
     * Parse latitude from APRS format (DDMM.HHN) to decimal degrees
     */
    private static double parseLatitude(String latStr) {
        // Format: DDMM.HHN (degrees, minutes, hundredths, hemisphere)
        int degrees = Integer.parseInt(latStr.substring(0, 2));
        double minutes = Double.parseDouble(latStr.substring(2, 7));
        char hemisphere = latStr.charAt(7);
        
        double latitude = degrees + (minutes / 60.0);
        
        if (hemisphere == 'S') {
            latitude = -latitude;
        }
        
        return latitude;
    }
    
    /**
     * Parse longitude from APRS format (DDDMM.HHE) to decimal degrees
     */
    private static double parseLongitude(String lonStr) {
        // Format: DDDMM.HHE (degrees, minutes, hundredths, hemisphere)
        int degrees = Integer.parseInt(lonStr.substring(0, 3));
        double minutes = Double.parseDouble(lonStr.substring(3, 8));
        char hemisphere = lonStr.charAt(8);
        
        double longitude = degrees + (minutes / 60.0);
        
        if (hemisphere == 'W') {
            longitude = -longitude;
        }
        
        return longitude;
    }
}
