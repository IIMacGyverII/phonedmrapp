package com.android.internal.telephony.phonenumbers.prefixmapper;

import com.android.internal.telephony.phonenumbers.Phonenumber;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PrefixFileReader {
    private static final Logger logger = Logger.getLogger(PrefixFileReader.class.getName());
    private Map<String, PhonePrefixMap> availablePhonePrefixMaps = new HashMap();
    private MappingFileProvider mappingFileProvider = new MappingFileProvider();
    private final String phonePrefixDataDirectory;

    public PrefixFileReader(String str) {
        this.phonePrefixDataDirectory = str;
        loadMappingFileProvider();
    }

    private void loadMappingFileProvider() {
        InputStream resourceAsStream = PrefixFileReader.class.getResourceAsStream(this.phonePrefixDataDirectory + "config");
        ObjectInputStream objectInputStream = null;
        try {
            ObjectInputStream objectInputStream2 = new ObjectInputStream(resourceAsStream);
            try {
                this.mappingFileProvider.readExternal(objectInputStream2);
                close(objectInputStream2);
            } catch (IOException e) {
                e = e;
                objectInputStream = objectInputStream2;
                try {
                    logger.log(Level.WARNING, e.toString());
                    close(objectInputStream);
                } catch (Throwable th) {
                    th = th;
                    close(objectInputStream);
                    throw th;
                }
            } catch (Throwable th2) {
                th = th2;
                objectInputStream = objectInputStream2;
                close(objectInputStream);
                throw th;
            }
        } catch (IOException e2) {
            e = e2;
            logger.log(Level.WARNING, e.toString());
            close(objectInputStream);
        }
    }

    private PhonePrefixMap getPhonePrefixDescriptions(int i, String str, String str2, String str3) {
        String fileName = this.mappingFileProvider.getFileName(i, str, str2, str3);
        if (fileName.length() == 0) {
            return null;
        }
        if (!this.availablePhonePrefixMaps.containsKey(fileName)) {
            loadPhonePrefixMapFromFile(fileName);
        }
        return this.availablePhonePrefixMaps.get(fileName);
    }

    private void loadPhonePrefixMapFromFile(String str) {
        InputStream resourceAsStream = PrefixFileReader.class.getResourceAsStream(this.phonePrefixDataDirectory + str);
        ObjectInputStream objectInputStream = null;
        try {
            ObjectInputStream objectInputStream2 = new ObjectInputStream(resourceAsStream);
            try {
                PhonePrefixMap phonePrefixMap = new PhonePrefixMap();
                phonePrefixMap.readExternal(objectInputStream2);
                this.availablePhonePrefixMaps.put(str, phonePrefixMap);
                close(objectInputStream2);
            } catch (IOException e) {
                e = e;
                objectInputStream = objectInputStream2;
                try {
                    logger.log(Level.WARNING, e.toString());
                    close(objectInputStream);
                } catch (Throwable th) {
                    th = th;
                    close(objectInputStream);
                    throw th;
                }
            } catch (Throwable th2) {
                th = th2;
                objectInputStream = objectInputStream2;
                close(objectInputStream);
                throw th;
            }
        } catch (IOException e2) {
            e = e2;
            logger.log(Level.WARNING, e.toString());
            close(objectInputStream);
        }
    }

    private static void close(InputStream inputStream) {
        if (inputStream != null) {
            try {
                inputStream.close();
            } catch (IOException e) {
                logger.log(Level.WARNING, e.toString());
            }
        }
    }

    public String getDescriptionForNumber(Phonenumber.PhoneNumber phoneNumber, String str, String str2, String str3) {
        int countryCode = phoneNumber.getCountryCode();
        if (countryCode == 1) {
            countryCode = ((int) (phoneNumber.getNationalNumber() / 10000000)) + 1000;
        }
        PhonePrefixMap phonePrefixDescriptions = getPhonePrefixDescriptions(countryCode, str, str2, str3);
        String lookup = phonePrefixDescriptions != null ? phonePrefixDescriptions.lookup(phoneNumber) : null;
        if ((lookup == null || lookup.length() == 0) && mayFallBackToEnglish(str)) {
            PhonePrefixMap phonePrefixDescriptions2 = getPhonePrefixDescriptions(countryCode, "en", "", "");
            if (phonePrefixDescriptions2 == null) {
                return "";
            }
            lookup = phonePrefixDescriptions2.lookup(phoneNumber);
        }
        if (lookup != null) {
            return lookup;
        }
        return "";
    }

    private boolean mayFallBackToEnglish(String str) {
        return !str.equals("zh") && !str.equals("ja") && !str.equals("ko");
    }
}
