package com.android.internal.telephony.util;

import android.content.Context;
import android.icu.util.ULocale;
import android.text.TextUtils;
import com.android.internal.telephony.MccTable;
import com.android.telephony.Rlog;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;

public class LocaleUtils {
    private static final String LOG_TAG = "LocaleUtils";

    public static Locale getLocaleFromMcc(Context context, int i, String str) {
        boolean z = !TextUtils.isEmpty(str);
        if (!z) {
            str = defaultLanguageForMcc(i);
        }
        String countryCodeForMcc = MccTable.countryCodeForMcc(i);
        Rlog.d(LOG_TAG, "getLocaleFromMcc(" + str + ", " + countryCodeForMcc + ", " + i);
        Locale localeForLanguageCountry = getLocaleForLanguageCountry(context, str, countryCodeForMcc);
        if (localeForLanguageCountry != null || !z) {
            return localeForLanguageCountry;
        }
        String defaultLanguageForMcc = defaultLanguageForMcc(i);
        Rlog.d(LOG_TAG, "[retry ] getLocaleFromMcc(" + defaultLanguageForMcc + ", " + countryCodeForMcc + ", " + i);
        return getLocaleForLanguageCountry(context, defaultLanguageForMcc, countryCodeForMcc);
    }

    private static Locale getLocaleForLanguageCountry(Context context, String str, String str2) {
        if (str == null) {
            Rlog.d(LOG_TAG, "getLocaleForLanguageCountry: skipping no language");
            return null;
        }
        if (str2 == null) {
            str2 = "";
        }
        Locale locale = new Locale(str, str2);
        try {
            ArrayList<String> arrayList = new ArrayList<>(Arrays.asList(context.getAssets().getLocales()));
            arrayList.remove("ar-XB");
            arrayList.remove("en-XA");
            ArrayList arrayList2 = new ArrayList();
            for (String replace : arrayList) {
                Locale forLanguageTag = Locale.forLanguageTag(replace.replace('_', '-'));
                if (forLanguageTag != null && !"und".equals(forLanguageTag.getLanguage()) && !forLanguageTag.getLanguage().isEmpty()) {
                    if (!forLanguageTag.getCountry().isEmpty()) {
                        if (!forLanguageTag.getLanguage().equals(locale.getLanguage())) {
                            continue;
                        } else if (forLanguageTag.getCountry().equals(locale.getCountry())) {
                            Rlog.d(LOG_TAG, "getLocaleForLanguageCountry: got perfect match: " + forLanguageTag.toLanguageTag());
                            return forLanguageTag;
                        } else {
                            arrayList2.add(forLanguageTag);
                        }
                    }
                }
            }
            if (arrayList2.isEmpty()) {
                Rlog.d(LOG_TAG, "getLocaleForLanguageCountry: no locales for language " + str);
                return null;
            }
            Locale lookupFallback = lookupFallback(locale, arrayList2);
            if (lookupFallback != null) {
                Rlog.d(LOG_TAG, "getLocaleForLanguageCountry: got a fallback match: " + lookupFallback.toLanguageTag());
                return lookupFallback;
            } else if (TextUtils.isEmpty(locale.getCountry()) || !isTranslated(context, locale)) {
                Rlog.d(LOG_TAG, "getLocaleForLanguageCountry: got language-only match: " + str);
                return (Locale) arrayList2.get(0);
            } else {
                Rlog.d(LOG_TAG, "getLocaleForLanguageCountry: target locale is translated: " + locale);
                return locale;
            }
        } catch (Exception e) {
            Rlog.d(LOG_TAG, "getLocaleForLanguageCountry: exception", e);
            return null;
        }
    }

    public static String defaultLanguageForMcc(int i) {
        MccTable.MccEntry entryForMcc = MccTable.entryForMcc(i);
        if (entryForMcc == null) {
            Rlog.d(LOG_TAG, "defaultLanguageForMcc(" + i + "): no country for mcc");
            return null;
        }
        String str = entryForMcc.mIso;
        if ("in".equals(str)) {
            return "en";
        }
        String language = ULocale.addLikelySubtags(new ULocale("und", str)).getLanguage();
        Rlog.d(LOG_TAG, "defaultLanguageForMcc(" + i + "): country " + str + " uses " + language);
        return language;
    }

    private static boolean isTranslated(Context context, Locale locale) {
        ULocale addLikelySubtags = ULocale.addLikelySubtags(ULocale.forLocale(locale));
        String language = addLikelySubtags.getLanguage();
        String script = addLikelySubtags.getScript();
        for (String uLocale : context.getAssets().getLocales()) {
            ULocale addLikelySubtags2 = ULocale.addLikelySubtags(new ULocale(uLocale));
            if (language.equals(addLikelySubtags2.getLanguage()) && script.equals(addLikelySubtags2.getScript())) {
                return true;
            }
        }
        return false;
    }

    private static Locale lookupFallback(Locale locale, List<Locale> list) {
        do {
            locale = MccTable.FALLBACKS.get(locale);
            if (locale == null) {
                return null;
            }
        } while (!list.contains(locale));
        return locale;
    }
}
