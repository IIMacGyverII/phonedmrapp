package com.dmrmod.hooks;

/**
 * CTCSS and DCS Tone Converter
 * 
 * Converts between PriInterPhone database format and OpenGD77 CSV format for analog tones.
 * 
 * DATABASE FORMAT:
 * - rxType/txType: 0=None, 1=CTCSS, 2=Forward DCS, 3=Backward DCS
 * - rxSubCode/txSubCode: Index into tone array (0-based)
 * 
 * OPENGD77 CSV FORMAT:
 * - "None" for no tone
 * - "67.0" for CTCSS (frequency in Hz without suffix)
 * - "D023N" for Forward DCS (D + code + N for normal)
 * - "D023I" for Backward DCS (D + code + I for inverted)
 */
public class ToneConverter {
    
    // CTCSS tone frequencies (51 standard tones)
    // Database stores as "67.0Hz", OpenGD77 expects "67.0"
    private static final String[] CTCSS_TONES = {
        "62.5", "67.0", "69.3", "71.9", "74.4", "77.0", "79.7", "82.5", "85.4", "88.5",
        "91.5", "94.8", "97.4", "100.0", "103.5", "107.2", "110.9", "114.8", "118.8", "123.0",
        "127.3", "131.8", "136.5", "141.3", "146.2", "151.4", "156.7", "159.8", "162.2", "165.5",
        "167.9", "171.3", "173.8", "177.3", "179.9", "183.5", "186.2", "189.9", "192.8", "196.6",
        "199.5", "203.5", "206.5", "210.7", "218.1", "225.7", "229.1", "233.6", "241.8", "250.3",
        "254.1"
    };
    
    // Forward DCS codes (Normal polarity, 83 codes)
    // Database stores as "023N", OpenGD77 expects "D023N"
    private static final String[] FDCS_CODES = {
        "023N", "025N", "026N", "031N", "032N", "043N", "047N", "051N", "054N", "065N",
        "071N", "072N", "073N", "074N", "114N", "115N", "116N", "125N", "131N", "132N",
        "134N", "143N", "152N", "155N", "156N", "162N", "165N", "172N", "174N", "205N",
        "223N", "226N", "243N", "244N", "245N", "251N", "261N", "263N", "265N", "271N",
        "306N", "311N", "315N", "331N", "343N", "346N", "351N", "364N", "365N", "371N",
        "411N", "412N", "413N", "423N", "431N", "432N", "445N", "464N", "465N", "466N",
        "503N", "506N", "516N", "532N", "546N", "565N", "606N", "612N", "624N", "627N",
        "631N", "632N", "654N", "662N", "664N", "703N", "712N", "723N", "731N", "732N",
        "734N", "743N", "754N"
    };
    
    // Backward DCS codes (Inverted polarity, 83 codes)
    // Database stores as "023l" (lowercase L), OpenGD77 expects "D023I"
    private static final String[] BDCS_CODES = {
        "023I", "025I", "026I", "031I", "032I", "043I", "047I", "051I", "054I", "065I",
        "071I", "072I", "073I", "074I", "114I", "115I", "116I", "125I", "131I", "132I",
        "134I", "143I", "152I", "155I", "156I", "162I", "165I", "172I", "174I", "205I",
        "223I", "226I", "243I", "244I", "245I", "251I", "261I", "263I", "265I", "271I",
        "306I", "311I", "315I", "331I", "343I", "346I", "351I", "364I", "365I", "371I",
        "411I", "412I", "413I", "423I", "431I", "432I", "445I", "464I", "465I", "466I",
        "503I", "506I", "516I", "532I", "546I", "565I", "606I", "612I", "624I", "627I",
        "631I", "632I", "654I", "662I", "664I", "703I", "712I", "723I", "731I", "732I",
        "734I", "743I", "754I"
    };
    
    /**
     * Convert database tone to OpenGD77 CSV format
     * 
     * @param type Tone type (0=None, 1=CTCSS, 2=FDCS, 3=BDCS)
     * @param subCode Index into tone array (0-based)
     * @return Tone string for CSV ("None", "67.0", "D023N", "D023I")
     */
    public static String toCSVFormat(int type, int subCode) {
        try {
            switch (type) {
                case 0:
                    return "None";
                case 1: // CTCSS
                    if (subCode >= 0 && subCode < CTCSS_TONES.length) {
                        return CTCSS_TONES[subCode];
                    }
                    break;
                case 2: // Forward DCS
                    if (subCode >= 0 && subCode < FDCS_CODES.length) {
                        String code = FDCS_CODES[subCode];
                        // Add "D" prefix if not present
                        return code.startsWith("D") ? code : "D" + code;
                    }
                    break;
                case 3: // Backward DCS
                    if (subCode >= 0 && subCode < BDCS_CODES.length) {
                        String code = BDCS_CODES[subCode];
                        // Add "D" prefix if not present
                        return code.startsWith("D") ? code : "D" + code;
                    }
                    break;
            }
        } catch (Exception e) {
            // Fall through to default
        }
        return "None";
    }
    
    /**
     * Parse CSV tone format and return type
     * 
     * @param csvTone Tone from CSV ("None", "67.0", "D023N", "023I", etc.)
     * @return Tone type (0=None, 1=CTCSS, 2=FDCS, 3=BDCS)
     */
    public static int parseType(String csvTone) {
        if (csvTone == null || csvTone.trim().isEmpty() || csvTone.equalsIgnoreCase("None")) {
            return 0;
        }
        
        csvTone = csvTone.trim();
        
        // Remove "D" prefix if present
        String code = csvTone.startsWith("D") || csvTone.startsWith("d") ? csvTone.substring(1) : csvTone;
        
        // Check if it ends with N or I (DCS codes)
        if (code.matches("\\d{3}[NI]")) {
            char polarity = code.charAt(3);
            if (polarity == 'N' || polarity == 'n') {
                return 2; // Forward DCS
            } else if (polarity == 'I' || polarity == 'i') {
                return 3; // Backward DCS
            }
        }
        
        // Check if it's a decimal number (CTCSS)
        try {
            Float.parseFloat(code);
            return 1; // CTCSS
        } catch (NumberFormatException e) {
            // Not a number
        }
        
        return 0; // Default to None
    }
    
    /**
     * Parse CSV tone format and return subcode index
     * 
     * @param csvTone Tone from CSV ("None", "67.0", "D023N", "023I", etc.)
     * @return Index into tone array (0 if not found or None)
     */
    public static int parseSubCode(String csvTone) {
        if (csvTone == null || csvTone.trim().isEmpty() || csvTone.equalsIgnoreCase("None")) {
            return 0;
        }
        
        csvTone = csvTone.trim();
        int type = parseType(csvTone);
        
        switch (type) {
            case 1: // CTCSS
                // Remove "Hz" suffix if present
                String freq = csvTone.replace("Hz", "").replace("hz", "").trim();
                for (int i = 0; i < CTCSS_TONES.length; i++) {
                    if (CTCSS_TONES[i].equals(freq)) {
                        return i;
                    }
                }
                break;
                
            case 2: // Forward DCS
                // Remove "D" prefix if present, keep "N" suffix
                String fdcsCode = csvTone.toUpperCase();
                fdcsCode = fdcsCode.startsWith("D") ? fdcsCode.substring(1) : fdcsCode;
                for (int i = 0; i < FDCS_CODES.length; i++) {
                    if (FDCS_CODES[i].equals(fdcsCode)) {
                        return i;
                    }
                }
                break;
                
            case 3: // Backward DCS
                // Remove "D" prefix if present, convert "I" to "I"
                String bdcsCode = csvTone.toUpperCase();
                bdcsCode = bdcsCode.startsWith("D") ? bdcsCode.substring(1) : bdcsCode;
                for (int i = 0; i < BDCS_CODES.length; i++) {
                    if (BDCS_CODES[i].equals(bdcsCode)) {
                        return i;
                    }
                }
                break;
        }
        
        return 0; // Not found, default to index 0
    }
}
