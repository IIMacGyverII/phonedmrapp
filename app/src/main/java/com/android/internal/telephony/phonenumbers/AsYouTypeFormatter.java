package com.android.internal.telephony.phonenumbers;

import com.android.internal.telephony.phonenumbers.Phonemetadata;
import com.android.internal.telephony.phonenumbers.internal.RegexCache;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class AsYouTypeFormatter {
    private static final Pattern DIGIT_PATTERN = Pattern.compile(DIGIT_PLACEHOLDER);
    private static final String DIGIT_PLACEHOLDER = " ";
    private static final Pattern ELIGIBLE_FORMAT_PATTERN = Pattern.compile("[-x‐-―−ー－-／  ­​⁠　()（）［］.\\[\\]/~⁓∼～]*\\$1[-x‐-―−ー－-／  ­​⁠　()（）［］.\\[\\]/~⁓∼～]*(\\$\\d[-x‐-―−ー－-／  ­​⁠　()（）［］.\\[\\]/~⁓∼～]*)*");
    private static final Phonemetadata.PhoneMetadata EMPTY_METADATA = Phonemetadata.PhoneMetadata.newBuilder().setId("<ignored>").setInternationalPrefix("NA").build();
    private static final int MIN_LEADING_DIGITS_LENGTH = 3;
    private static final Pattern NATIONAL_PREFIX_SEPARATORS_PATTERN = Pattern.compile("[- ]");
    private static final char SEPARATOR_BEFORE_NATIONAL_NUMBER = ' ';
    private boolean ableToFormat = true;
    private StringBuilder accruedInput = new StringBuilder();
    private StringBuilder accruedInputWithoutFormatting = new StringBuilder();
    private String currentFormattingPattern = "";
    private Phonemetadata.PhoneMetadata currentMetadata;
    private String currentOutput = "";
    private String defaultCountry;
    private Phonemetadata.PhoneMetadata defaultMetadata;
    private String extractedNationalPrefix = "";
    private StringBuilder formattingTemplate = new StringBuilder();
    private boolean inputHasFormatting = false;
    private boolean isCompleteNumber = false;
    private boolean isExpectingCountryCallingCode = false;
    private int lastMatchPosition = 0;
    private StringBuilder nationalNumber = new StringBuilder();
    private int originalPosition = 0;
    private final PhoneNumberUtil phoneUtil = PhoneNumberUtil.getInstance();
    private int positionToRemember = 0;
    private List<Phonemetadata.NumberFormat> possibleFormats = new ArrayList();
    private StringBuilder prefixBeforeNationalNumber = new StringBuilder();
    private RegexCache regexCache = new RegexCache(64);
    private boolean shouldAddSpaceAfterNationalPrefix = false;

    AsYouTypeFormatter(String str) {
        this.defaultCountry = str;
        Phonemetadata.PhoneMetadata metadataForRegion = getMetadataForRegion(str);
        this.currentMetadata = metadataForRegion;
        this.defaultMetadata = metadataForRegion;
    }

    private Phonemetadata.PhoneMetadata getMetadataForRegion(String str) {
        Phonemetadata.PhoneMetadata metadataForRegion = this.phoneUtil.getMetadataForRegion(this.phoneUtil.getRegionCodeForCountryCode(this.phoneUtil.getCountryCodeForRegion(str)));
        if (metadataForRegion != null) {
            return metadataForRegion;
        }
        return EMPTY_METADATA;
    }

    private boolean maybeCreateNewTemplate() {
        Iterator<Phonemetadata.NumberFormat> it = this.possibleFormats.iterator();
        while (it.hasNext()) {
            Phonemetadata.NumberFormat next = it.next();
            String pattern = next.getPattern();
            if (this.currentFormattingPattern.equals(pattern)) {
                return false;
            }
            if (createFormattingTemplate(next)) {
                this.currentFormattingPattern = pattern;
                this.shouldAddSpaceAfterNationalPrefix = NATIONAL_PREFIX_SEPARATORS_PATTERN.matcher(next.getNationalPrefixFormattingRule()).find();
                this.lastMatchPosition = 0;
                return true;
            }
            it.remove();
        }
        this.ableToFormat = false;
        return false;
    }

    private void getAvailableFormats(String str) {
        List<Phonemetadata.NumberFormat> list;
        if (!(this.isCompleteNumber && this.extractedNationalPrefix.length() == 0) || this.currentMetadata.getIntlNumberFormatCount() <= 0) {
            list = this.currentMetadata.getNumberFormatList();
        } else {
            list = this.currentMetadata.getIntlNumberFormatList();
        }
        for (Phonemetadata.NumberFormat next : list) {
            if ((this.extractedNationalPrefix.length() <= 0 || !PhoneNumberUtil.formattingRuleHasFirstGroupOnly(next.getNationalPrefixFormattingRule()) || next.getNationalPrefixOptionalWhenFormatting() || next.hasDomesticCarrierCodeFormattingRule()) && ((this.extractedNationalPrefix.length() != 0 || this.isCompleteNumber || PhoneNumberUtil.formattingRuleHasFirstGroupOnly(next.getNationalPrefixFormattingRule()) || next.getNationalPrefixOptionalWhenFormatting()) && ELIGIBLE_FORMAT_PATTERN.matcher(next.getFormat()).matches())) {
                this.possibleFormats.add(next);
            }
        }
        narrowDownPossibleFormats(str);
    }

    private void narrowDownPossibleFormats(String str) {
        int length = str.length() - 3;
        Iterator<Phonemetadata.NumberFormat> it = this.possibleFormats.iterator();
        while (it.hasNext()) {
            Phonemetadata.NumberFormat next = it.next();
            if (next.getLeadingDigitsPatternCount() != 0) {
                if (!this.regexCache.getPatternForRegex(next.getLeadingDigitsPattern(Math.min(length, next.getLeadingDigitsPatternCount() - 1))).matcher(str).lookingAt()) {
                    it.remove();
                }
            }
        }
    }

    private boolean createFormattingTemplate(Phonemetadata.NumberFormat numberFormat) {
        String pattern = numberFormat.getPattern();
        this.formattingTemplate.setLength(0);
        String formattingTemplate2 = getFormattingTemplate(pattern, numberFormat.getFormat());
        if (formattingTemplate2.length() <= 0) {
            return false;
        }
        this.formattingTemplate.append(formattingTemplate2);
        return true;
    }

    private String getFormattingTemplate(String str, String str2) {
        Matcher matcher = this.regexCache.getPatternForRegex(str).matcher("999999999999999");
        matcher.find();
        String group = matcher.group();
        if (group.length() < this.nationalNumber.length()) {
            return "";
        }
        return group.replaceAll(str, str2).replaceAll("9", DIGIT_PLACEHOLDER);
    }

    public void clear() {
        this.currentOutput = "";
        this.accruedInput.setLength(0);
        this.accruedInputWithoutFormatting.setLength(0);
        this.formattingTemplate.setLength(0);
        this.lastMatchPosition = 0;
        this.currentFormattingPattern = "";
        this.prefixBeforeNationalNumber.setLength(0);
        this.extractedNationalPrefix = "";
        this.nationalNumber.setLength(0);
        this.ableToFormat = true;
        this.inputHasFormatting = false;
        this.positionToRemember = 0;
        this.originalPosition = 0;
        this.isCompleteNumber = false;
        this.isExpectingCountryCallingCode = false;
        this.possibleFormats.clear();
        this.shouldAddSpaceAfterNationalPrefix = false;
        if (!this.currentMetadata.equals(this.defaultMetadata)) {
            this.currentMetadata = getMetadataForRegion(this.defaultCountry);
        }
    }

    public String inputDigit(char c) {
        String inputDigitWithOptionToRememberPosition = inputDigitWithOptionToRememberPosition(c, false);
        this.currentOutput = inputDigitWithOptionToRememberPosition;
        return inputDigitWithOptionToRememberPosition;
    }

    public String inputDigitAndRememberPosition(char c) {
        String inputDigitWithOptionToRememberPosition = inputDigitWithOptionToRememberPosition(c, true);
        this.currentOutput = inputDigitWithOptionToRememberPosition;
        return inputDigitWithOptionToRememberPosition;
    }

    private String inputDigitWithOptionToRememberPosition(char c, boolean z) {
        this.accruedInput.append(c);
        if (z) {
            this.originalPosition = this.accruedInput.length();
        }
        if (!isDigitOrLeadingPlusSign(c)) {
            this.ableToFormat = false;
            this.inputHasFormatting = true;
        } else {
            c = normalizeAndAccrueDigitsAndPlusSign(c, z);
        }
        if (this.ableToFormat) {
            int length = this.accruedInputWithoutFormatting.length();
            if (length == 0 || length == 1 || length == 2) {
                return this.accruedInput.toString();
            }
            if (length == 3) {
                if (attemptToExtractIdd()) {
                    this.isExpectingCountryCallingCode = true;
                } else {
                    this.extractedNationalPrefix = removeNationalPrefixFromNationalNumber();
                    return attemptToChooseFormattingPattern();
                }
            }
            if (this.isExpectingCountryCallingCode) {
                if (attemptToExtractCountryCallingCode()) {
                    this.isExpectingCountryCallingCode = false;
                }
                return this.prefixBeforeNationalNumber + this.nationalNumber.toString();
            } else if (this.possibleFormats.size() <= 0) {
                return attemptToChooseFormattingPattern();
            } else {
                String inputDigitHelper = inputDigitHelper(c);
                String attemptToFormatAccruedDigits = attemptToFormatAccruedDigits();
                if (attemptToFormatAccruedDigits.length() > 0) {
                    return attemptToFormatAccruedDigits;
                }
                narrowDownPossibleFormats(this.nationalNumber.toString());
                if (maybeCreateNewTemplate()) {
                    return inputAccruedNationalNumber();
                }
                if (this.ableToFormat) {
                    return appendNationalNumber(inputDigitHelper);
                }
                return this.accruedInput.toString();
            }
        } else if (this.inputHasFormatting) {
            return this.accruedInput.toString();
        } else {
            if (attemptToExtractIdd()) {
                if (attemptToExtractCountryCallingCode()) {
                    return attemptToChoosePatternWithPrefixExtracted();
                }
            } else if (ableToExtractLongerNdd()) {
                this.prefixBeforeNationalNumber.append(SEPARATOR_BEFORE_NATIONAL_NUMBER);
                return attemptToChoosePatternWithPrefixExtracted();
            }
            return this.accruedInput.toString();
        }
    }

    private String attemptToChoosePatternWithPrefixExtracted() {
        this.ableToFormat = true;
        this.isExpectingCountryCallingCode = false;
        this.possibleFormats.clear();
        this.lastMatchPosition = 0;
        this.formattingTemplate.setLength(0);
        this.currentFormattingPattern = "";
        return attemptToChooseFormattingPattern();
    }

    /* access modifiers changed from: package-private */
    public String getExtractedNationalPrefix() {
        return this.extractedNationalPrefix;
    }

    private boolean ableToExtractLongerNdd() {
        if (this.extractedNationalPrefix.length() > 0) {
            this.nationalNumber.insert(0, this.extractedNationalPrefix);
            this.prefixBeforeNationalNumber.setLength(this.prefixBeforeNationalNumber.lastIndexOf(this.extractedNationalPrefix));
        }
        return !this.extractedNationalPrefix.equals(removeNationalPrefixFromNationalNumber());
    }

    private boolean isDigitOrLeadingPlusSign(char c) {
        if (Character.isDigit(c)) {
            return true;
        }
        if (this.accruedInput.length() != 1 || !PhoneNumberUtil.PLUS_CHARS_PATTERN.matcher(Character.toString(c)).matches()) {
            return false;
        }
        return true;
    }

    /* access modifiers changed from: package-private */
    public String attemptToFormatAccruedDigits() {
        for (Phonemetadata.NumberFormat next : this.possibleFormats) {
            Matcher matcher = this.regexCache.getPatternForRegex(next.getPattern()).matcher(this.nationalNumber);
            if (matcher.matches()) {
                this.shouldAddSpaceAfterNationalPrefix = NATIONAL_PREFIX_SEPARATORS_PATTERN.matcher(next.getNationalPrefixFormattingRule()).find();
                String appendNationalNumber = appendNationalNumber(matcher.replaceAll(next.getFormat()));
                if (PhoneNumberUtil.normalizeDiallableCharsOnly(appendNationalNumber).contentEquals(this.accruedInputWithoutFormatting)) {
                    return appendNationalNumber;
                }
            }
        }
        return "";
    }

    public int getRememberedPosition() {
        if (!this.ableToFormat) {
            return this.originalPosition;
        }
        int i = 0;
        int i2 = 0;
        while (i < this.positionToRemember && i2 < this.currentOutput.length()) {
            if (this.accruedInputWithoutFormatting.charAt(i) == this.currentOutput.charAt(i2)) {
                i++;
            }
            i2++;
        }
        return i2;
    }

    private String appendNationalNumber(String str) {
        int length = this.prefixBeforeNationalNumber.length();
        if (!this.shouldAddSpaceAfterNationalPrefix || length <= 0 || this.prefixBeforeNationalNumber.charAt(length - 1) == ' ') {
            return this.prefixBeforeNationalNumber + str;
        }
        return new String(this.prefixBeforeNationalNumber) + SEPARATOR_BEFORE_NATIONAL_NUMBER + str;
    }

    private String attemptToChooseFormattingPattern() {
        if (this.nationalNumber.length() < 3) {
            return appendNationalNumber(this.nationalNumber.toString());
        }
        getAvailableFormats(this.nationalNumber.toString());
        String attemptToFormatAccruedDigits = attemptToFormatAccruedDigits();
        if (attemptToFormatAccruedDigits.length() > 0) {
            return attemptToFormatAccruedDigits;
        }
        return maybeCreateNewTemplate() ? inputAccruedNationalNumber() : this.accruedInput.toString();
    }

    private String inputAccruedNationalNumber() {
        int length = this.nationalNumber.length();
        if (length <= 0) {
            return this.prefixBeforeNationalNumber.toString();
        }
        String str = "";
        for (int i = 0; i < length; i++) {
            str = inputDigitHelper(this.nationalNumber.charAt(i));
        }
        return this.ableToFormat ? appendNationalNumber(str) : this.accruedInput.toString();
    }

    private boolean isNanpaNumberWithNationalPrefix() {
        if (this.currentMetadata.getCountryCode() != 1 || this.nationalNumber.charAt(0) != '1' || this.nationalNumber.charAt(1) == '0' || this.nationalNumber.charAt(1) == '1') {
            return false;
        }
        return true;
    }

    private String removeNationalPrefixFromNationalNumber() {
        int i = 1;
        if (isNanpaNumberWithNationalPrefix()) {
            StringBuilder sb = this.prefixBeforeNationalNumber;
            sb.append('1');
            sb.append(SEPARATOR_BEFORE_NATIONAL_NUMBER);
            this.isCompleteNumber = true;
        } else {
            if (this.currentMetadata.hasNationalPrefixForParsing()) {
                Matcher matcher = this.regexCache.getPatternForRegex(this.currentMetadata.getNationalPrefixForParsing()).matcher(this.nationalNumber);
                if (matcher.lookingAt() && matcher.end() > 0) {
                    this.isCompleteNumber = true;
                    i = matcher.end();
                    this.prefixBeforeNationalNumber.append(this.nationalNumber.substring(0, i));
                }
            }
            i = 0;
        }
        String substring = this.nationalNumber.substring(0, i);
        this.nationalNumber.delete(0, i);
        return substring;
    }

    private boolean attemptToExtractIdd() {
        RegexCache regexCache2 = this.regexCache;
        Matcher matcher = regexCache2.getPatternForRegex("\\+|" + this.currentMetadata.getInternationalPrefix()).matcher(this.accruedInputWithoutFormatting);
        if (!matcher.lookingAt()) {
            return false;
        }
        this.isCompleteNumber = true;
        int end = matcher.end();
        this.nationalNumber.setLength(0);
        this.nationalNumber.append(this.accruedInputWithoutFormatting.substring(end));
        this.prefixBeforeNationalNumber.setLength(0);
        this.prefixBeforeNationalNumber.append(this.accruedInputWithoutFormatting.substring(0, end));
        if (this.accruedInputWithoutFormatting.charAt(0) != '+') {
            this.prefixBeforeNationalNumber.append(SEPARATOR_BEFORE_NATIONAL_NUMBER);
        }
        return true;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:3:0x000a, code lost:
        r0 = new java.lang.StringBuilder();
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private boolean attemptToExtractCountryCallingCode() {
        /*
            r4 = this;
            java.lang.StringBuilder r0 = r4.nationalNumber
            int r0 = r0.length()
            r1 = 0
            if (r0 != 0) goto L_0x000a
            return r1
        L_0x000a:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            com.android.internal.telephony.phonenumbers.PhoneNumberUtil r2 = r4.phoneUtil
            java.lang.StringBuilder r3 = r4.nationalNumber
            int r2 = r2.extractCountryCode(r3, r0)
            if (r2 != 0) goto L_0x001a
            return r1
        L_0x001a:
            java.lang.StringBuilder r3 = r4.nationalNumber
            r3.setLength(r1)
            java.lang.StringBuilder r1 = r4.nationalNumber
            r1.append(r0)
            com.android.internal.telephony.phonenumbers.PhoneNumberUtil r0 = r4.phoneUtil
            java.lang.String r0 = r0.getRegionCodeForCountryCode(r2)
            java.lang.String r1 = "001"
            boolean r1 = r1.equals(r0)
            if (r1 == 0) goto L_0x003b
            com.android.internal.telephony.phonenumbers.PhoneNumberUtil r0 = r4.phoneUtil
            com.android.internal.telephony.phonenumbers.Phonemetadata$PhoneMetadata r0 = r0.getMetadataForNonGeographicalRegion(r2)
            r4.currentMetadata = r0
            goto L_0x0049
        L_0x003b:
            java.lang.String r1 = r4.defaultCountry
            boolean r1 = r0.equals(r1)
            if (r1 != 0) goto L_0x0049
            com.android.internal.telephony.phonenumbers.Phonemetadata$PhoneMetadata r0 = r4.getMetadataForRegion(r0)
            r4.currentMetadata = r0
        L_0x0049:
            java.lang.String r0 = java.lang.Integer.toString(r2)
            java.lang.StringBuilder r1 = r4.prefixBeforeNationalNumber
            r1.append(r0)
            r0 = 32
            r1.append(r0)
            java.lang.String r0 = ""
            r4.extractedNationalPrefix = r0
            r4 = 1
            return r4
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.phonenumbers.AsYouTypeFormatter.attemptToExtractCountryCallingCode():boolean");
    }

    private char normalizeAndAccrueDigitsAndPlusSign(char c, boolean z) {
        if (c == '+') {
            this.accruedInputWithoutFormatting.append(c);
        } else {
            c = Character.forDigit(Character.digit(c, 10), 10);
            this.accruedInputWithoutFormatting.append(c);
            this.nationalNumber.append(c);
        }
        if (z) {
            this.positionToRemember = this.accruedInputWithoutFormatting.length();
        }
        return c;
    }

    private String inputDigitHelper(char c) {
        Matcher matcher = DIGIT_PATTERN.matcher(this.formattingTemplate);
        if (matcher.find(this.lastMatchPosition)) {
            String replaceFirst = matcher.replaceFirst(Character.toString(c));
            this.formattingTemplate.replace(0, replaceFirst.length(), replaceFirst);
            int start = matcher.start();
            this.lastMatchPosition = start;
            return this.formattingTemplate.substring(0, start + 1);
        }
        if (this.possibleFormats.size() == 1) {
            this.ableToFormat = false;
        }
        this.currentFormattingPattern = "";
        return this.accruedInput.toString();
    }
}
