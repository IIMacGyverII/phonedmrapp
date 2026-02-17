package com.android.internal.telephony.phonenumbers.prefixmapper;

import com.android.internal.telephony.phonenumbers.PhoneNumberUtil;
import com.android.internal.telephony.phonenumbers.Phonenumber;
import java.io.Externalizable;
import java.io.IOException;
import java.io.ObjectInput;
import java.io.ObjectOutput;
import java.util.LinkedList;
import java.util.List;
import java.util.SortedMap;
import java.util.StringTokenizer;

public class PrefixTimeZonesMap implements Externalizable {
    private static final String RAW_STRING_TIMEZONES_SEPARATOR = "&";
    private final PhonePrefixMap phonePrefixMap = new PhonePrefixMap();

    public void readPrefixTimeZonesMap(SortedMap<Integer, String> sortedMap) {
        this.phonePrefixMap.readPhonePrefixMap(sortedMap);
    }

    public void writeExternal(ObjectOutput objectOutput) throws IOException {
        this.phonePrefixMap.writeExternal(objectOutput);
    }

    public void readExternal(ObjectInput objectInput) throws IOException {
        this.phonePrefixMap.readExternal(objectInput);
    }

    private List<String> lookupTimeZonesForNumber(long j) {
        String lookup = this.phonePrefixMap.lookup(j);
        if (lookup == null) {
            return new LinkedList();
        }
        return tokenizeRawOutputString(lookup);
    }

    public List<String> lookupTimeZonesForNumber(Phonenumber.PhoneNumber phoneNumber) {
        return lookupTimeZonesForNumber(Long.parseLong(phoneNumber.getCountryCode() + PhoneNumberUtil.getInstance().getNationalSignificantNumber(phoneNumber)));
    }

    public List<String> lookupCountryLevelTimeZonesForNumber(Phonenumber.PhoneNumber phoneNumber) {
        return lookupTimeZonesForNumber((long) phoneNumber.getCountryCode());
    }

    private List<String> tokenizeRawOutputString(String str) {
        StringTokenizer stringTokenizer = new StringTokenizer(str, RAW_STRING_TIMEZONES_SEPARATOR);
        LinkedList linkedList = new LinkedList();
        while (stringTokenizer.hasMoreTokens()) {
            linkedList.add(stringTokenizer.nextToken());
        }
        return linkedList;
    }

    public String toString() {
        return this.phonePrefixMap.toString();
    }
}
