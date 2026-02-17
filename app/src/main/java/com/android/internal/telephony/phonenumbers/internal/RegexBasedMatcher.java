package com.android.internal.telephony.phonenumbers.internal;

import com.android.internal.telephony.phonenumbers.Phonemetadata;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class RegexBasedMatcher implements MatcherApi {
    private final RegexCache regexCache = new RegexCache(100);

    public static MatcherApi create() {
        return new RegexBasedMatcher();
    }

    private RegexBasedMatcher() {
    }

    public boolean matchNationalNumber(CharSequence charSequence, Phonemetadata.PhoneNumberDesc phoneNumberDesc, boolean z) {
        String nationalNumberPattern = phoneNumberDesc.getNationalNumberPattern();
        if (nationalNumberPattern.length() == 0) {
            return false;
        }
        return match(charSequence, this.regexCache.getPatternForRegex(nationalNumberPattern), z);
    }

    private static boolean match(CharSequence charSequence, Pattern pattern, boolean z) {
        Matcher matcher = pattern.matcher(charSequence);
        if (!matcher.lookingAt()) {
            return false;
        }
        if (matcher.matches()) {
            return true;
        }
        return z;
    }
}
