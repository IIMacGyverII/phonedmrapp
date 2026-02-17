package com.android.internal.telephony.cat;

/* compiled from: CommandParams */
class LanguageParams extends CommandParams {
    String mLanguage;

    LanguageParams(CommandDetails commandDetails, String str) {
        super(commandDetails);
        this.mLanguage = str;
    }
}
