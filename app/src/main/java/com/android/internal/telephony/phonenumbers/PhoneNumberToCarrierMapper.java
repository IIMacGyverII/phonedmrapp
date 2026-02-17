package com.android.internal.telephony.phonenumbers;

import com.android.internal.telephony.phonenumbers.PhoneNumberUtil;
import com.android.internal.telephony.phonenumbers.Phonenumber;
import com.android.internal.telephony.phonenumbers.prefixmapper.PrefixFileReader;
import java.util.Locale;

public class PhoneNumberToCarrierMapper {
    private static final String MAPPING_DATA_DIRECTORY = "/com/android/internal/telephony/phonenumbers/carrier/data/";
    private static PhoneNumberToCarrierMapper instance;
    private final PhoneNumberUtil phoneUtil = PhoneNumberUtil.getInstance();
    private PrefixFileReader prefixFileReader = null;

    PhoneNumberToCarrierMapper(String str) {
        this.prefixFileReader = new PrefixFileReader(str);
    }

    public static synchronized PhoneNumberToCarrierMapper getInstance() {
        PhoneNumberToCarrierMapper phoneNumberToCarrierMapper;
        synchronized (PhoneNumberToCarrierMapper.class) {
            if (instance == null) {
                instance = new PhoneNumberToCarrierMapper(MAPPING_DATA_DIRECTORY);
            }
            phoneNumberToCarrierMapper = instance;
        }
        return phoneNumberToCarrierMapper;
    }

    public String getNameForValidNumber(Phonenumber.PhoneNumber phoneNumber, Locale locale) {
        return this.prefixFileReader.getDescriptionForNumber(phoneNumber, locale.getLanguage(), "", locale.getCountry());
    }

    public String getNameForNumber(Phonenumber.PhoneNumber phoneNumber, Locale locale) {
        return isMobile(this.phoneUtil.getNumberType(phoneNumber)) ? getNameForValidNumber(phoneNumber, locale) : "";
    }

    public String getSafeDisplayName(Phonenumber.PhoneNumber phoneNumber, Locale locale) {
        PhoneNumberUtil phoneNumberUtil = this.phoneUtil;
        if (phoneNumberUtil.isMobileNumberPortableRegion(phoneNumberUtil.getRegionCodeForNumber(phoneNumber))) {
            return "";
        }
        return getNameForNumber(phoneNumber, locale);
    }

    private boolean isMobile(PhoneNumberUtil.PhoneNumberType phoneNumberType) {
        return phoneNumberType == PhoneNumberUtil.PhoneNumberType.MOBILE || phoneNumberType == PhoneNumberUtil.PhoneNumberType.FIXED_LINE_OR_MOBILE || phoneNumberType == PhoneNumberUtil.PhoneNumberType.PAGER;
    }
}
