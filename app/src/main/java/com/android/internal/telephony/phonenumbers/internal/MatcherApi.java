package com.android.internal.telephony.phonenumbers.internal;

import com.android.internal.telephony.phonenumbers.Phonemetadata;

public interface MatcherApi {
    boolean matchNationalNumber(CharSequence charSequence, Phonemetadata.PhoneNumberDesc phoneNumberDesc, boolean z);
}
