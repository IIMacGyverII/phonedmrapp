package com.android.internal.telephony.phonenumbers;

import com.android.internal.telephony.d2d.DtmfTransport;
import com.android.internal.telephony.phonenumbers.NumberParseException;
import com.android.internal.telephony.phonenumbers.PhoneNumberMatcher;
import com.android.internal.telephony.phonenumbers.Phonemetadata;
import com.android.internal.telephony.phonenumbers.Phonenumber;
import com.android.internal.telephony.phonenumbers.internal.MatcherApi;
import com.android.internal.telephony.phonenumbers.internal.RegexBasedMatcher;
import com.android.internal.telephony.phonenumbers.internal.RegexCache;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import kotlin.text.Typography;

public class PhoneNumberUtil {
    private static final Map<Character, Character> ALL_PLUS_NUMBER_GROUPING_SYMBOLS;
    private static final Map<Character, Character> ALPHA_MAPPINGS;
    private static final Map<Character, Character> ALPHA_PHONE_MAPPINGS;
    private static final Pattern CAPTURING_DIGIT_PATTERN = Pattern.compile("(\\p{Nd})");
    private static final String CC_STRING = "$CC";
    private static final String COLOMBIA_MOBILE_TO_FIXED_LINE_PREFIX = "3";
    private static final String DEFAULT_EXTN_PREFIX = " ext. ";
    private static final Map<Character, Character> DIALLABLE_CHAR_MAPPINGS;
    private static final String DIGITS = "\\p{Nd}";
    private static final Pattern EXTN_PATTERN;
    static final String EXTN_PATTERNS_FOR_MATCHING = createExtnPattern(false);
    private static final String EXTN_PATTERNS_FOR_PARSING;
    private static final String FG_STRING = "$FG";
    private static final Pattern FIRST_GROUP_ONLY_PREFIX_PATTERN = Pattern.compile("\\(?\\$1\\)?");
    private static final Pattern FIRST_GROUP_PATTERN = Pattern.compile("(\\$\\d)");
    private static final Set<Integer> GEO_MOBILE_COUNTRIES;
    private static final Set<Integer> GEO_MOBILE_COUNTRIES_WITHOUT_MOBILE_AREA_CODES;
    private static final int MAX_INPUT_STRING_LENGTH = 250;
    static final int MAX_LENGTH_COUNTRY_CODE = 3;
    static final int MAX_LENGTH_FOR_NSN = 17;
    private static final int MIN_LENGTH_FOR_NSN = 2;
    private static final Map<Integer, String> MOBILE_TOKEN_MAPPINGS;
    private static final int NANPA_COUNTRY_CODE = 1;
    static final Pattern NON_DIGITS_PATTERN = Pattern.compile("(\\D+)");
    private static final String NP_STRING = "$NP";
    static final String PLUS_CHARS = "+＋";
    static final Pattern PLUS_CHARS_PATTERN = Pattern.compile("[+＋]+");
    static final char PLUS_SIGN = '+';
    static final int REGEX_FLAGS = 66;
    public static final String REGION_CODE_FOR_NON_GEO_ENTITY = "001";
    private static final String RFC3966_EXTN_PREFIX = ";ext=";
    private static final String RFC3966_ISDN_SUBADDRESS = ";isub=";
    private static final String RFC3966_PHONE_CONTEXT = ";phone-context=";
    private static final String RFC3966_PREFIX = "tel:";
    private static final String SECOND_NUMBER_START = "[\\\\/] *x";
    static final Pattern SECOND_NUMBER_START_PATTERN = Pattern.compile(SECOND_NUMBER_START);
    private static final Pattern SEPARATOR_PATTERN = Pattern.compile("[-x‐-―−ー－-／  ­​⁠　()（）［］.\\[\\]/~⁓∼～]+");
    private static final Pattern SINGLE_INTERNATIONAL_PREFIX = Pattern.compile("[\\d]+(?:[~⁓∼～][\\d]+)?");
    private static final char STAR_SIGN = '*';
    private static final String UNKNOWN_REGION = "ZZ";
    private static final String UNWANTED_END_CHARS = "[[\\P{N}&&\\P{L}]&&[^#]]+$";
    static final Pattern UNWANTED_END_CHAR_PATTERN = Pattern.compile(UNWANTED_END_CHARS);
    private static final String VALID_ALPHA;
    private static final Pattern VALID_ALPHA_PHONE_PATTERN = Pattern.compile("(?:.*?[A-Za-z]){3}.*");
    private static final String VALID_PHONE_NUMBER;
    private static final Pattern VALID_PHONE_NUMBER_PATTERN;
    static final String VALID_PUNCTUATION = "-x‐-―−ー－-／  ­​⁠　()（）［］.\\[\\]/~⁓∼～";
    private static final String VALID_START_CHAR = "[+＋\\p{Nd}]";
    private static final Pattern VALID_START_CHAR_PATTERN = Pattern.compile(VALID_START_CHAR);
    private static PhoneNumberUtil instance = null;
    private static final Logger logger = Logger.getLogger(PhoneNumberUtil.class.getName());
    private final Map<Integer, List<String>> countryCallingCodeToRegionCodeMap;
    private final Set<Integer> countryCodesForNonGeographicalRegion = new HashSet();
    private final MatcherApi matcherApi = RegexBasedMatcher.create();
    private final MetadataSource metadataSource;
    private final Set<String> nanpaRegions = new HashSet(35);
    private final RegexCache regexCache = new RegexCache(100);
    private final Set<String> supportedRegions = new HashSet(320);

    public enum Leniency {
        POSSIBLE {
            /* access modifiers changed from: package-private */
            public boolean verify(Phonenumber.PhoneNumber phoneNumber, CharSequence charSequence, PhoneNumberUtil phoneNumberUtil, PhoneNumberMatcher phoneNumberMatcher) {
                return phoneNumberUtil.isPossibleNumber(phoneNumber);
            }
        },
        VALID {
            /* access modifiers changed from: package-private */
            public boolean verify(Phonenumber.PhoneNumber phoneNumber, CharSequence charSequence, PhoneNumberUtil phoneNumberUtil, PhoneNumberMatcher phoneNumberMatcher) {
                if (!phoneNumberUtil.isValidNumber(phoneNumber) || !PhoneNumberMatcher.containsOnlyValidXChars(phoneNumber, charSequence.toString(), phoneNumberUtil)) {
                    return false;
                }
                return PhoneNumberMatcher.isNationalPrefixPresentIfRequired(phoneNumber, phoneNumberUtil);
            }
        },
        STRICT_GROUPING {
            /* access modifiers changed from: package-private */
            public boolean verify(Phonenumber.PhoneNumber phoneNumber, CharSequence charSequence, PhoneNumberUtil phoneNumberUtil, PhoneNumberMatcher phoneNumberMatcher) {
                String charSequence2 = charSequence.toString();
                if (!phoneNumberUtil.isValidNumber(phoneNumber) || !PhoneNumberMatcher.containsOnlyValidXChars(phoneNumber, charSequence2, phoneNumberUtil) || PhoneNumberMatcher.containsMoreThanOneSlashInNationalNumber(phoneNumber, charSequence2) || !PhoneNumberMatcher.isNationalPrefixPresentIfRequired(phoneNumber, phoneNumberUtil)) {
                    return false;
                }
                return phoneNumberMatcher.checkNumberGroupingIsValid(phoneNumber, charSequence, phoneNumberUtil, new PhoneNumberMatcher.NumberGroupingChecker() {
                    public boolean checkGroups(PhoneNumberUtil phoneNumberUtil, Phonenumber.PhoneNumber phoneNumber, StringBuilder sb, String[] strArr) {
                        return PhoneNumberMatcher.allNumberGroupsRemainGrouped(phoneNumberUtil, phoneNumber, sb, strArr);
                    }
                });
            }
        },
        EXACT_GROUPING {
            /* access modifiers changed from: package-private */
            public boolean verify(Phonenumber.PhoneNumber phoneNumber, CharSequence charSequence, PhoneNumberUtil phoneNumberUtil, PhoneNumberMatcher phoneNumberMatcher) {
                String charSequence2 = charSequence.toString();
                if (!phoneNumberUtil.isValidNumber(phoneNumber) || !PhoneNumberMatcher.containsOnlyValidXChars(phoneNumber, charSequence2, phoneNumberUtil) || PhoneNumberMatcher.containsMoreThanOneSlashInNationalNumber(phoneNumber, charSequence2) || !PhoneNumberMatcher.isNationalPrefixPresentIfRequired(phoneNumber, phoneNumberUtil)) {
                    return false;
                }
                return phoneNumberMatcher.checkNumberGroupingIsValid(phoneNumber, charSequence, phoneNumberUtil, new PhoneNumberMatcher.NumberGroupingChecker() {
                    public boolean checkGroups(PhoneNumberUtil phoneNumberUtil, Phonenumber.PhoneNumber phoneNumber, StringBuilder sb, String[] strArr) {
                        return PhoneNumberMatcher.allNumberGroupsAreExactlyPresent(phoneNumberUtil, phoneNumber, sb, strArr);
                    }
                });
            }
        };

        /* access modifiers changed from: package-private */
        public abstract boolean verify(Phonenumber.PhoneNumber phoneNumber, CharSequence charSequence, PhoneNumberUtil phoneNumberUtil, PhoneNumberMatcher phoneNumberMatcher);
    }

    public enum MatchType {
        NOT_A_NUMBER,
        NO_MATCH,
        SHORT_NSN_MATCH,
        NSN_MATCH,
        EXACT_MATCH
    }

    public enum PhoneNumberFormat {
        E164,
        INTERNATIONAL,
        NATIONAL,
        RFC3966
    }

    public enum PhoneNumberType {
        FIXED_LINE,
        MOBILE,
        FIXED_LINE_OR_MOBILE,
        TOLL_FREE,
        PREMIUM_RATE,
        SHARED_COST,
        VOIP,
        PERSONAL_NUMBER,
        PAGER,
        UAN,
        VOICEMAIL,
        UNKNOWN
    }

    public enum ValidationResult {
        IS_POSSIBLE,
        IS_POSSIBLE_LOCAL_ONLY,
        INVALID_COUNTRY_CODE,
        TOO_SHORT,
        INVALID_LENGTH,
        TOO_LONG
    }

    static {
        HashMap hashMap = new HashMap();
        hashMap.put(54, "9");
        MOBILE_TOKEN_MAPPINGS = Collections.unmodifiableMap(hashMap);
        HashSet hashSet = new HashSet();
        hashSet.add(86);
        GEO_MOBILE_COUNTRIES_WITHOUT_MOBILE_AREA_CODES = Collections.unmodifiableSet(hashSet);
        HashSet hashSet2 = new HashSet();
        hashSet2.add(52);
        hashSet2.add(54);
        hashSet2.add(55);
        hashSet2.add(62);
        hashSet2.addAll(hashSet);
        GEO_MOBILE_COUNTRIES = Collections.unmodifiableSet(hashSet2);
        HashMap hashMap2 = new HashMap();
        hashMap2.put('0', '0');
        hashMap2.put('1', '1');
        hashMap2.put('2', '2');
        hashMap2.put('3', '3');
        hashMap2.put('4', '4');
        hashMap2.put('5', '5');
        hashMap2.put('6', '6');
        hashMap2.put('7', '7');
        hashMap2.put('8', '8');
        hashMap2.put('9', '9');
        HashMap hashMap3 = new HashMap(40);
        hashMap3.put(Character.valueOf(DtmfTransport.DTMF_MESSAGE_START), '2');
        hashMap3.put('B', '2');
        hashMap3.put('C', '2');
        hashMap3.put(Character.valueOf(DtmfTransport.DTMF_MESSAGE_DELIMITER), '3');
        hashMap3.put('E', '3');
        hashMap3.put('F', '3');
        hashMap3.put('G', '4');
        hashMap3.put('H', '4');
        hashMap3.put('I', '4');
        hashMap3.put('J', '5');
        hashMap3.put('K', '5');
        hashMap3.put('L', '5');
        hashMap3.put('M', '6');
        hashMap3.put('N', '6');
        hashMap3.put('O', '6');
        hashMap3.put('P', '7');
        hashMap3.put('Q', '7');
        hashMap3.put('R', '7');
        hashMap3.put('S', '7');
        hashMap3.put('T', '8');
        hashMap3.put('U', '8');
        hashMap3.put('V', '8');
        hashMap3.put('W', '9');
        hashMap3.put('X', '9');
        hashMap3.put('Y', '9');
        hashMap3.put('Z', '9');
        Map<Character, Character> unmodifiableMap = Collections.unmodifiableMap(hashMap3);
        ALPHA_MAPPINGS = unmodifiableMap;
        HashMap hashMap4 = new HashMap(100);
        hashMap4.putAll(unmodifiableMap);
        hashMap4.putAll(hashMap2);
        ALPHA_PHONE_MAPPINGS = Collections.unmodifiableMap(hashMap4);
        HashMap hashMap5 = new HashMap();
        hashMap5.putAll(hashMap2);
        Character valueOf = Character.valueOf(PLUS_SIGN);
        hashMap5.put(valueOf, valueOf);
        Character valueOf2 = Character.valueOf(STAR_SIGN);
        hashMap5.put(valueOf2, valueOf2);
        hashMap5.put('#', '#');
        DIALLABLE_CHAR_MAPPINGS = Collections.unmodifiableMap(hashMap5);
        HashMap hashMap6 = new HashMap();
        for (Character charValue : unmodifiableMap.keySet()) {
            char charValue2 = charValue.charValue();
            hashMap6.put(Character.valueOf(Character.toLowerCase(charValue2)), Character.valueOf(charValue2));
            hashMap6.put(Character.valueOf(charValue2), Character.valueOf(charValue2));
        }
        hashMap6.putAll(hashMap2);
        hashMap6.put('-', '-');
        hashMap6.put(65293, '-');
        hashMap6.put(8208, '-');
        hashMap6.put(8209, '-');
        hashMap6.put(8210, '-');
        hashMap6.put(Character.valueOf(Typography.ndash), '-');
        hashMap6.put(Character.valueOf(Typography.mdash), '-');
        hashMap6.put(8213, '-');
        hashMap6.put(8722, '-');
        hashMap6.put('/', '/');
        hashMap6.put(65295, '/');
        hashMap6.put(' ', ' ');
        hashMap6.put(12288, ' ');
        hashMap6.put(8288, ' ');
        hashMap6.put('.', '.');
        hashMap6.put(65294, '.');
        ALL_PLUS_NUMBER_GROUPING_SYMBOLS = Collections.unmodifiableMap(hashMap6);
        StringBuilder sb = new StringBuilder();
        Map<Character, Character> map = ALPHA_MAPPINGS;
        sb.append(Arrays.toString(map.keySet().toArray()).replaceAll("[, \\[\\]]", ""));
        sb.append(Arrays.toString(map.keySet().toArray()).toLowerCase().replaceAll("[, \\[\\]]", ""));
        String sb2 = sb.toString();
        VALID_ALPHA = sb2;
        String str = "\\p{Nd}{2}|[+＋]*+(?:[-x‐-―−ー－-／  ­​⁠　()（）［］.\\[\\]/~⁓∼～*]*\\p{Nd}){3,}[-x‐-―−ー－-／  ­​⁠　()（）［］.\\[\\]/~⁓∼～*" + sb2 + DIGITS + "]*";
        VALID_PHONE_NUMBER = str;
        String createExtnPattern = createExtnPattern(true);
        EXTN_PATTERNS_FOR_PARSING = createExtnPattern;
        EXTN_PATTERN = Pattern.compile("(?:" + createExtnPattern + ")$", 66);
        VALID_PHONE_NUMBER_PATTERN = Pattern.compile(str + "(?:" + createExtnPattern + ")?", 66);
    }

    private static String extnDigits(int i) {
        return "(\\p{Nd}{1," + i + "})";
    }

    private static String createExtnPattern(boolean z) {
        String str = (RFC3966_EXTN_PREFIX + extnDigits(20)) + "|" + ("[  \\t,]*" + "(?:e?xt(?:ensi(?:ó?|ó))?n?|ｅ?ｘｔｎ?|доб|anexo)" + "[:\\.．]?[  \\t,-]*" + extnDigits(20) + "#?") + "|" + ("[  \\t,]*" + "(?:[xｘ#＃~～]|int|ｉｎｔ)" + "[:\\.．]?[  \\t,-]*" + extnDigits(9) + "#?") + "|" + ("[- ]+" + extnDigits(6) + "#");
        if (!z) {
            return str;
        }
        return str + "|" + ("[  \\t]*" + "(?:,{2}|;)" + "[:\\.．]?[  \\t,-]*" + extnDigits(15) + "#?") + "|" + ("[  \\t]*" + "(?:,)+" + "[:\\.．]?[  \\t,-]*" + extnDigits(9) + "#?");
    }

    PhoneNumberUtil(MetadataSource metadataSource2, Map<Integer, List<String>> map) {
        this.metadataSource = metadataSource2;
        this.countryCallingCodeToRegionCodeMap = map;
        for (Map.Entry next : map.entrySet()) {
            List list = (List) next.getValue();
            if (list.size() != 1 || !REGION_CODE_FOR_NON_GEO_ENTITY.equals(list.get(0))) {
                this.supportedRegions.addAll(list);
            } else {
                this.countryCodesForNonGeographicalRegion.add((Integer) next.getKey());
            }
        }
        if (this.supportedRegions.remove(REGION_CODE_FOR_NON_GEO_ENTITY)) {
            logger.log(Level.WARNING, "invalid metadata (country calling code was mapped to the non-geo entity as well as specific region(s))");
        }
        this.nanpaRegions.addAll(map.get(1));
    }

    static CharSequence extractPossibleNumber(CharSequence charSequence) {
        Matcher matcher = VALID_START_CHAR_PATTERN.matcher(charSequence);
        if (!matcher.find()) {
            return "";
        }
        CharSequence subSequence = charSequence.subSequence(matcher.start(), charSequence.length());
        Matcher matcher2 = UNWANTED_END_CHAR_PATTERN.matcher(subSequence);
        if (matcher2.find()) {
            subSequence = subSequence.subSequence(0, matcher2.start());
        }
        Matcher matcher3 = SECOND_NUMBER_START_PATTERN.matcher(subSequence);
        return matcher3.find() ? subSequence.subSequence(0, matcher3.start()) : subSequence;
    }

    static boolean isViablePhoneNumber(CharSequence charSequence) {
        if (charSequence.length() < 2) {
            return false;
        }
        return VALID_PHONE_NUMBER_PATTERN.matcher(charSequence).matches();
    }

    static StringBuilder normalize(StringBuilder sb) {
        if (VALID_ALPHA_PHONE_PATTERN.matcher(sb).matches()) {
            sb.replace(0, sb.length(), normalizeHelper(sb, ALPHA_PHONE_MAPPINGS, true));
        } else {
            sb.replace(0, sb.length(), normalizeDigitsOnly(sb));
        }
        return sb;
    }

    public static String normalizeDigitsOnly(CharSequence charSequence) {
        return normalizeDigits(charSequence, false).toString();
    }

    static StringBuilder normalizeDigits(CharSequence charSequence, boolean z) {
        StringBuilder sb = new StringBuilder(charSequence.length());
        for (int i = 0; i < charSequence.length(); i++) {
            char charAt = charSequence.charAt(i);
            int digit = Character.digit(charAt, 10);
            if (digit != -1) {
                sb.append(digit);
            } else if (z) {
                sb.append(charAt);
            }
        }
        return sb;
    }

    public static String normalizeDiallableCharsOnly(CharSequence charSequence) {
        return normalizeHelper(charSequence, DIALLABLE_CHAR_MAPPINGS, true);
    }

    public static String convertAlphaCharactersInNumber(CharSequence charSequence) {
        return normalizeHelper(charSequence, ALPHA_PHONE_MAPPINGS, false);
    }

    public int getLengthOfGeographicalAreaCode(Phonenumber.PhoneNumber phoneNumber) {
        Phonemetadata.PhoneMetadata metadataForRegion = getMetadataForRegion(getRegionCodeForNumber(phoneNumber));
        if (metadataForRegion == null) {
            return 0;
        }
        if (!metadataForRegion.hasNationalPrefix() && !phoneNumber.isItalianLeadingZero()) {
            return 0;
        }
        PhoneNumberType numberType = getNumberType(phoneNumber);
        int countryCode = phoneNumber.getCountryCode();
        if ((numberType != PhoneNumberType.MOBILE || !GEO_MOBILE_COUNTRIES_WITHOUT_MOBILE_AREA_CODES.contains(Integer.valueOf(countryCode))) && isNumberGeographical(numberType, countryCode)) {
            return getLengthOfNationalDestinationCode(phoneNumber);
        }
        return 0;
    }

    public int getLengthOfNationalDestinationCode(Phonenumber.PhoneNumber phoneNumber) {
        Phonenumber.PhoneNumber phoneNumber2;
        if (phoneNumber.hasExtension()) {
            phoneNumber2 = new Phonenumber.PhoneNumber();
            phoneNumber2.mergeFrom(phoneNumber);
            phoneNumber2.clearExtension();
        } else {
            phoneNumber2 = phoneNumber;
        }
        String[] split = NON_DIGITS_PATTERN.split(format(phoneNumber2, PhoneNumberFormat.INTERNATIONAL));
        if (split.length <= 3) {
            return 0;
        }
        if (getNumberType(phoneNumber) != PhoneNumberType.MOBILE || getCountryMobileToken(phoneNumber.getCountryCode()).equals("")) {
            return split[2].length();
        }
        return split[2].length() + split[3].length();
    }

    public static String getCountryMobileToken(int i) {
        Map<Integer, String> map = MOBILE_TOKEN_MAPPINGS;
        return map.containsKey(Integer.valueOf(i)) ? map.get(Integer.valueOf(i)) : "";
    }

    private static String normalizeHelper(CharSequence charSequence, Map<Character, Character> map, boolean z) {
        StringBuilder sb = new StringBuilder(charSequence.length());
        for (int i = 0; i < charSequence.length(); i++) {
            char charAt = charSequence.charAt(i);
            Character ch = map.get(Character.valueOf(Character.toUpperCase(charAt)));
            if (ch != null) {
                sb.append(ch);
            } else if (!z) {
                sb.append(charAt);
            }
        }
        return sb.toString();
    }

    static synchronized void setInstance(PhoneNumberUtil phoneNumberUtil) {
        synchronized (PhoneNumberUtil.class) {
            instance = phoneNumberUtil;
        }
    }

    public Set<String> getSupportedRegions() {
        return Collections.unmodifiableSet(this.supportedRegions);
    }

    public Set<Integer> getSupportedGlobalNetworkCallingCodes() {
        return Collections.unmodifiableSet(this.countryCodesForNonGeographicalRegion);
    }

    public Set<Integer> getSupportedCallingCodes() {
        return Collections.unmodifiableSet(this.countryCallingCodeToRegionCodeMap.keySet());
    }

    private static boolean descHasPossibleNumberData(Phonemetadata.PhoneNumberDesc phoneNumberDesc) {
        return (phoneNumberDesc.getPossibleLengthCount() == 1 && phoneNumberDesc.getPossibleLength(0) == -1) ? false : true;
    }

    private static boolean descHasData(Phonemetadata.PhoneNumberDesc phoneNumberDesc) {
        return phoneNumberDesc.hasExampleNumber() || descHasPossibleNumberData(phoneNumberDesc) || phoneNumberDesc.hasNationalNumberPattern();
    }

    private Set<PhoneNumberType> getSupportedTypesForMetadata(Phonemetadata.PhoneMetadata phoneMetadata) {
        TreeSet treeSet = new TreeSet();
        for (PhoneNumberType phoneNumberType : PhoneNumberType.values()) {
            if (!(phoneNumberType == PhoneNumberType.FIXED_LINE_OR_MOBILE || phoneNumberType == PhoneNumberType.UNKNOWN || !descHasData(getNumberDescByType(phoneMetadata, phoneNumberType)))) {
                treeSet.add(phoneNumberType);
            }
        }
        return Collections.unmodifiableSet(treeSet);
    }

    public Set<PhoneNumberType> getSupportedTypesForRegion(String str) {
        if (isValidRegionCode(str)) {
            return getSupportedTypesForMetadata(getMetadataForRegion(str));
        }
        Logger logger2 = logger;
        Level level = Level.WARNING;
        logger2.log(level, "Invalid or unknown region code provided: " + str);
        return Collections.unmodifiableSet(new TreeSet());
    }

    public Set<PhoneNumberType> getSupportedTypesForNonGeoEntity(int i) {
        Phonemetadata.PhoneMetadata metadataForNonGeographicalRegion = getMetadataForNonGeographicalRegion(i);
        if (metadataForNonGeographicalRegion != null) {
            return getSupportedTypesForMetadata(metadataForNonGeographicalRegion);
        }
        Logger logger2 = logger;
        Level level = Level.WARNING;
        logger2.log(level, "Unknown country calling code for a non-geographical entity provided: " + i);
        return Collections.unmodifiableSet(new TreeSet());
    }

    public static synchronized PhoneNumberUtil getInstance() {
        PhoneNumberUtil phoneNumberUtil;
        synchronized (PhoneNumberUtil.class) {
            if (instance == null) {
                setInstance(createInstance(MetadataManager.DEFAULT_METADATA_LOADER));
            }
            phoneNumberUtil = instance;
        }
        return phoneNumberUtil;
    }

    public static PhoneNumberUtil createInstance(MetadataLoader metadataLoader) {
        if (metadataLoader != null) {
            return createInstance((MetadataSource) new MultiFileMetadataSourceImpl(metadataLoader));
        }
        throw new IllegalArgumentException("metadataLoader could not be null.");
    }

    private static PhoneNumberUtil createInstance(MetadataSource metadataSource2) {
        if (metadataSource2 != null) {
            return new PhoneNumberUtil(metadataSource2, CountryCodeToRegionCodeMap.getCountryCodeToRegionCodeMap());
        }
        throw new IllegalArgumentException("metadataSource could not be null.");
    }

    static boolean formattingRuleHasFirstGroupOnly(String str) {
        return str.length() == 0 || FIRST_GROUP_ONLY_PREFIX_PATTERN.matcher(str).matches();
    }

    public boolean isNumberGeographical(Phonenumber.PhoneNumber phoneNumber) {
        return isNumberGeographical(getNumberType(phoneNumber), phoneNumber.getCountryCode());
    }

    public boolean isNumberGeographical(PhoneNumberType phoneNumberType, int i) {
        return phoneNumberType == PhoneNumberType.FIXED_LINE || phoneNumberType == PhoneNumberType.FIXED_LINE_OR_MOBILE || (GEO_MOBILE_COUNTRIES.contains(Integer.valueOf(i)) && phoneNumberType == PhoneNumberType.MOBILE);
    }

    private boolean isValidRegionCode(String str) {
        return str != null && this.supportedRegions.contains(str);
    }

    private boolean hasValidCountryCallingCode(int i) {
        return this.countryCallingCodeToRegionCodeMap.containsKey(Integer.valueOf(i));
    }

    public String format(Phonenumber.PhoneNumber phoneNumber, PhoneNumberFormat phoneNumberFormat) {
        if (phoneNumber.getNationalNumber() == 0 && phoneNumber.hasRawInput()) {
            String rawInput = phoneNumber.getRawInput();
            if (rawInput.length() > 0) {
                return rawInput;
            }
        }
        StringBuilder sb = new StringBuilder(20);
        format(phoneNumber, phoneNumberFormat, sb);
        return sb.toString();
    }

    public void format(Phonenumber.PhoneNumber phoneNumber, PhoneNumberFormat phoneNumberFormat, StringBuilder sb) {
        sb.setLength(0);
        int countryCode = phoneNumber.getCountryCode();
        String nationalSignificantNumber = getNationalSignificantNumber(phoneNumber);
        PhoneNumberFormat phoneNumberFormat2 = PhoneNumberFormat.E164;
        if (phoneNumberFormat == phoneNumberFormat2) {
            sb.append(nationalSignificantNumber);
            prefixNumberWithCountryCallingCode(countryCode, phoneNumberFormat2, sb);
        } else if (!hasValidCountryCallingCode(countryCode)) {
            sb.append(nationalSignificantNumber);
        } else {
            Phonemetadata.PhoneMetadata metadataForRegionOrCallingCode = getMetadataForRegionOrCallingCode(countryCode, getRegionCodeForCountryCode(countryCode));
            sb.append(formatNsn(nationalSignificantNumber, metadataForRegionOrCallingCode, phoneNumberFormat));
            maybeAppendFormattedExtension(phoneNumber, metadataForRegionOrCallingCode, phoneNumberFormat, sb);
            prefixNumberWithCountryCallingCode(countryCode, phoneNumberFormat, sb);
        }
    }

    public String formatByPattern(Phonenumber.PhoneNumber phoneNumber, PhoneNumberFormat phoneNumberFormat, List<Phonemetadata.NumberFormat> list) {
        int countryCode = phoneNumber.getCountryCode();
        String nationalSignificantNumber = getNationalSignificantNumber(phoneNumber);
        if (!hasValidCountryCallingCode(countryCode)) {
            return nationalSignificantNumber;
        }
        Phonemetadata.PhoneMetadata metadataForRegionOrCallingCode = getMetadataForRegionOrCallingCode(countryCode, getRegionCodeForCountryCode(countryCode));
        StringBuilder sb = new StringBuilder(20);
        Phonemetadata.NumberFormat chooseFormattingPatternForNumber = chooseFormattingPatternForNumber(list, nationalSignificantNumber);
        if (chooseFormattingPatternForNumber == null) {
            sb.append(nationalSignificantNumber);
        } else {
            Phonemetadata.NumberFormat.Builder newBuilder = Phonemetadata.NumberFormat.newBuilder();
            newBuilder.mergeFrom(chooseFormattingPatternForNumber);
            String nationalPrefixFormattingRule = chooseFormattingPatternForNumber.getNationalPrefixFormattingRule();
            if (nationalPrefixFormattingRule.length() > 0) {
                String nationalPrefix = metadataForRegionOrCallingCode.getNationalPrefix();
                if (nationalPrefix.length() > 0) {
                    newBuilder.setNationalPrefixFormattingRule(nationalPrefixFormattingRule.replace(NP_STRING, nationalPrefix).replace(FG_STRING, "$1"));
                } else {
                    newBuilder.clearNationalPrefixFormattingRule();
                }
            }
            sb.append(formatNsnUsingPattern(nationalSignificantNumber, newBuilder.build(), phoneNumberFormat));
        }
        maybeAppendFormattedExtension(phoneNumber, metadataForRegionOrCallingCode, phoneNumberFormat, sb);
        prefixNumberWithCountryCallingCode(countryCode, phoneNumberFormat, sb);
        return sb.toString();
    }

    public String formatNationalNumberWithCarrierCode(Phonenumber.PhoneNumber phoneNumber, CharSequence charSequence) {
        int countryCode = phoneNumber.getCountryCode();
        String nationalSignificantNumber = getNationalSignificantNumber(phoneNumber);
        if (!hasValidCountryCallingCode(countryCode)) {
            return nationalSignificantNumber;
        }
        Phonemetadata.PhoneMetadata metadataForRegionOrCallingCode = getMetadataForRegionOrCallingCode(countryCode, getRegionCodeForCountryCode(countryCode));
        StringBuilder sb = new StringBuilder(20);
        PhoneNumberFormat phoneNumberFormat = PhoneNumberFormat.NATIONAL;
        sb.append(formatNsn(nationalSignificantNumber, metadataForRegionOrCallingCode, phoneNumberFormat, charSequence));
        maybeAppendFormattedExtension(phoneNumber, metadataForRegionOrCallingCode, phoneNumberFormat, sb);
        prefixNumberWithCountryCallingCode(countryCode, phoneNumberFormat, sb);
        return sb.toString();
    }

    private Phonemetadata.PhoneMetadata getMetadataForRegionOrCallingCode(int i, String str) {
        if (REGION_CODE_FOR_NON_GEO_ENTITY.equals(str)) {
            return getMetadataForNonGeographicalRegion(i);
        }
        return getMetadataForRegion(str);
    }

    public String formatNationalNumberWithPreferredCarrierCode(Phonenumber.PhoneNumber phoneNumber, CharSequence charSequence) {
        if (phoneNumber.getPreferredDomesticCarrierCode().length() > 0) {
            charSequence = phoneNumber.getPreferredDomesticCarrierCode();
        }
        return formatNationalNumberWithCarrierCode(phoneNumber, charSequence);
    }

    public String formatNumberForMobileDialing(Phonenumber.PhoneNumber phoneNumber, String str, boolean z) {
        String format;
        int countryCode = phoneNumber.getCountryCode();
        String str2 = "";
        if (!hasValidCountryCallingCode(countryCode)) {
            return phoneNumber.hasRawInput() ? phoneNumber.getRawInput() : str2;
        }
        Phonenumber.PhoneNumber clearExtension = new Phonenumber.PhoneNumber().mergeFrom(phoneNumber).clearExtension();
        String regionCodeForCountryCode = getRegionCodeForCountryCode(countryCode);
        PhoneNumberType numberType = getNumberType(clearExtension);
        boolean z2 = false;
        boolean z3 = numberType != PhoneNumberType.UNKNOWN;
        if (str.equals(regionCodeForCountryCode)) {
            PhoneNumberType phoneNumberType = PhoneNumberType.FIXED_LINE;
            if (numberType == phoneNumberType || numberType == PhoneNumberType.MOBILE || numberType == PhoneNumberType.FIXED_LINE_OR_MOBILE) {
                z2 = true;
            }
            if (regionCodeForCountryCode.equals("CO") && numberType == phoneNumberType) {
                format = formatNationalNumberWithCarrierCode(clearExtension, "3");
            } else if (!regionCodeForCountryCode.equals("BR") || !z2) {
                if (countryCode == 1) {
                    Phonemetadata.PhoneMetadata metadataForRegion = getMetadataForRegion(str);
                    if (!canBeInternationallyDialled(clearExtension) || testNumberLength(getNationalSignificantNumber(clearExtension), metadataForRegion) == ValidationResult.TOO_SHORT) {
                        format = format(clearExtension, PhoneNumberFormat.NATIONAL);
                    } else {
                        format = format(clearExtension, PhoneNumberFormat.INTERNATIONAL);
                    }
                } else if ((regionCodeForCountryCode.equals(REGION_CODE_FOR_NON_GEO_ENTITY) || ((regionCodeForCountryCode.equals("MX") || regionCodeForCountryCode.equals("CL") || regionCodeForCountryCode.equals("UZ")) && z2)) && canBeInternationallyDialled(clearExtension)) {
                    format = format(clearExtension, PhoneNumberFormat.INTERNATIONAL);
                } else {
                    format = format(clearExtension, PhoneNumberFormat.NATIONAL);
                }
            } else if (clearExtension.getPreferredDomesticCarrierCode().length() > 0) {
                str2 = formatNationalNumberWithPreferredCarrierCode(clearExtension, str2);
            }
            str2 = format;
        } else if (z3 && canBeInternationallyDialled(clearExtension)) {
            if (z) {
                return format(clearExtension, PhoneNumberFormat.INTERNATIONAL);
            }
            return format(clearExtension, PhoneNumberFormat.E164);
        }
        return z ? str2 : normalizeDiallableCharsOnly(str2);
    }

    public String formatOutOfCountryCallingNumber(Phonenumber.PhoneNumber phoneNumber, String str) {
        if (!isValidRegionCode(str)) {
            Logger logger2 = logger;
            Level level = Level.WARNING;
            logger2.log(level, "Trying to format number from invalid region " + str + ". International formatting applied.");
            return format(phoneNumber, PhoneNumberFormat.INTERNATIONAL);
        }
        int countryCode = phoneNumber.getCountryCode();
        String nationalSignificantNumber = getNationalSignificantNumber(phoneNumber);
        if (!hasValidCountryCallingCode(countryCode)) {
            return nationalSignificantNumber;
        }
        if (countryCode == 1) {
            if (isNANPACountry(str)) {
                return countryCode + " " + format(phoneNumber, PhoneNumberFormat.NATIONAL);
            }
        } else if (countryCode == getCountryCodeForValidRegion(str)) {
            return format(phoneNumber, PhoneNumberFormat.NATIONAL);
        }
        Phonemetadata.PhoneMetadata metadataForRegion = getMetadataForRegion(str);
        String internationalPrefix = metadataForRegion.getInternationalPrefix();
        if (metadataForRegion.hasPreferredInternationalPrefix()) {
            internationalPrefix = metadataForRegion.getPreferredInternationalPrefix();
        } else if (!SINGLE_INTERNATIONAL_PREFIX.matcher(internationalPrefix).matches()) {
            internationalPrefix = "";
        }
        Phonemetadata.PhoneMetadata metadataForRegionOrCallingCode = getMetadataForRegionOrCallingCode(countryCode, getRegionCodeForCountryCode(countryCode));
        PhoneNumberFormat phoneNumberFormat = PhoneNumberFormat.INTERNATIONAL;
        StringBuilder sb = new StringBuilder(formatNsn(nationalSignificantNumber, metadataForRegionOrCallingCode, phoneNumberFormat));
        maybeAppendFormattedExtension(phoneNumber, metadataForRegionOrCallingCode, phoneNumberFormat, sb);
        if (internationalPrefix.length() > 0) {
            sb.insert(0, " ").insert(0, countryCode).insert(0, " ").insert(0, internationalPrefix);
        } else {
            prefixNumberWithCountryCallingCode(countryCode, phoneNumberFormat, sb);
        }
        return sb.toString();
    }

    public String formatInOriginalFormat(Phonenumber.PhoneNumber phoneNumber, String str) {
        String str2;
        String nationalPrefixFormattingRule;
        int indexOf;
        if (phoneNumber.hasRawInput() && !hasFormattingPatternForNumber(phoneNumber)) {
            return phoneNumber.getRawInput();
        }
        if (!phoneNumber.hasCountryCodeSource()) {
            return format(phoneNumber, PhoneNumberFormat.NATIONAL);
        }
        int i = AnonymousClass2.$SwitchMap$com$google$i18n$phonenumbers$Phonenumber$PhoneNumber$CountryCodeSource[phoneNumber.getCountryCodeSource().ordinal()];
        if (i == 1) {
            str2 = format(phoneNumber, PhoneNumberFormat.INTERNATIONAL);
        } else if (i == 2) {
            str2 = formatOutOfCountryCallingNumber(phoneNumber, str);
        } else if (i != 3) {
            String regionCodeForCountryCode = getRegionCodeForCountryCode(phoneNumber.getCountryCode());
            String nddPrefixForRegion = getNddPrefixForRegion(regionCodeForCountryCode, true);
            PhoneNumberFormat phoneNumberFormat = PhoneNumberFormat.NATIONAL;
            str2 = format(phoneNumber, phoneNumberFormat);
            if (!(nddPrefixForRegion == null || nddPrefixForRegion.length() == 0 || rawInputContainsNationalPrefix(phoneNumber.getRawInput(), nddPrefixForRegion, regionCodeForCountryCode))) {
                Phonemetadata.NumberFormat chooseFormattingPatternForNumber = chooseFormattingPatternForNumber(getMetadataForRegion(regionCodeForCountryCode).getNumberFormatList(), getNationalSignificantNumber(phoneNumber));
                if (!(chooseFormattingPatternForNumber == null || (indexOf = nationalPrefixFormattingRule.indexOf("$1")) <= 0 || normalizeDigitsOnly((nationalPrefixFormattingRule = chooseFormattingPatternForNumber.getNationalPrefixFormattingRule()).substring(0, indexOf)).length() == 0)) {
                    Phonemetadata.NumberFormat.Builder newBuilder = Phonemetadata.NumberFormat.newBuilder();
                    newBuilder.mergeFrom(chooseFormattingPatternForNumber);
                    newBuilder.clearNationalPrefixFormattingRule();
                    ArrayList arrayList = new ArrayList(1);
                    arrayList.add(newBuilder.build());
                    str2 = formatByPattern(phoneNumber, phoneNumberFormat, arrayList);
                }
            }
        } else {
            str2 = format(phoneNumber, PhoneNumberFormat.INTERNATIONAL).substring(1);
        }
        String rawInput = phoneNumber.getRawInput();
        return (str2 == null || rawInput.length() <= 0 || normalizeDiallableCharsOnly(str2).equals(normalizeDiallableCharsOnly(rawInput))) ? str2 : rawInput;
    }

    private boolean rawInputContainsNationalPrefix(String str, String str2, String str3) {
        String normalizeDigitsOnly = normalizeDigitsOnly(str);
        if (normalizeDigitsOnly.startsWith(str2)) {
            try {
                return isValidNumber(parse(normalizeDigitsOnly.substring(str2.length()), str3));
            } catch (NumberParseException unused) {
            }
        }
        return false;
    }

    private boolean hasFormattingPatternForNumber(Phonenumber.PhoneNumber phoneNumber) {
        int countryCode = phoneNumber.getCountryCode();
        Phonemetadata.PhoneMetadata metadataForRegionOrCallingCode = getMetadataForRegionOrCallingCode(countryCode, getRegionCodeForCountryCode(countryCode));
        if (metadataForRegionOrCallingCode == null) {
            return false;
        }
        if (chooseFormattingPatternForNumber(metadataForRegionOrCallingCode.getNumberFormatList(), getNationalSignificantNumber(phoneNumber)) != null) {
            return true;
        }
        return false;
    }

    public String formatOutOfCountryKeepingAlphaChars(Phonenumber.PhoneNumber phoneNumber, String str) {
        String str2;
        int indexOf;
        String rawInput = phoneNumber.getRawInput();
        if (rawInput.length() == 0) {
            return formatOutOfCountryCallingNumber(phoneNumber, str);
        }
        int countryCode = phoneNumber.getCountryCode();
        if (!hasValidCountryCallingCode(countryCode)) {
            return rawInput;
        }
        String normalizeHelper = normalizeHelper(rawInput, ALL_PLUS_NUMBER_GROUPING_SYMBOLS, true);
        String nationalSignificantNumber = getNationalSignificantNumber(phoneNumber);
        if (nationalSignificantNumber.length() > 3 && (indexOf = normalizeHelper.indexOf(nationalSignificantNumber.substring(0, 3))) != -1) {
            normalizeHelper = normalizeHelper.substring(indexOf);
        }
        Phonemetadata.PhoneMetadata metadataForRegion = getMetadataForRegion(str);
        if (countryCode == 1) {
            if (isNANPACountry(str)) {
                return countryCode + " " + normalizeHelper;
            }
        } else if (metadataForRegion != null && countryCode == getCountryCodeForValidRegion(str)) {
            Phonemetadata.NumberFormat chooseFormattingPatternForNumber = chooseFormattingPatternForNumber(metadataForRegion.getNumberFormatList(), nationalSignificantNumber);
            if (chooseFormattingPatternForNumber == null) {
                return normalizeHelper;
            }
            Phonemetadata.NumberFormat.Builder newBuilder = Phonemetadata.NumberFormat.newBuilder();
            newBuilder.mergeFrom(chooseFormattingPatternForNumber);
            newBuilder.setPattern("(\\d+)(.*)");
            newBuilder.setFormat("$1$2");
            return formatNsnUsingPattern(normalizeHelper, newBuilder.build(), PhoneNumberFormat.NATIONAL);
        }
        if (metadataForRegion != null) {
            str2 = metadataForRegion.getInternationalPrefix();
            if (!SINGLE_INTERNATIONAL_PREFIX.matcher(str2).matches()) {
                str2 = metadataForRegion.getPreferredInternationalPrefix();
            }
        } else {
            str2 = "";
        }
        StringBuilder sb = new StringBuilder(normalizeHelper);
        Phonemetadata.PhoneMetadata metadataForRegionOrCallingCode = getMetadataForRegionOrCallingCode(countryCode, getRegionCodeForCountryCode(countryCode));
        PhoneNumberFormat phoneNumberFormat = PhoneNumberFormat.INTERNATIONAL;
        maybeAppendFormattedExtension(phoneNumber, metadataForRegionOrCallingCode, phoneNumberFormat, sb);
        if (str2.length() > 0) {
            sb.insert(0, " ").insert(0, countryCode).insert(0, " ").insert(0, str2);
        } else {
            if (!isValidRegionCode(str)) {
                Logger logger2 = logger;
                Level level = Level.WARNING;
                logger2.log(level, "Trying to format number from invalid region " + str + ". International formatting applied.");
            }
            prefixNumberWithCountryCallingCode(countryCode, phoneNumberFormat, sb);
        }
        return sb.toString();
    }

    public String getNationalSignificantNumber(Phonenumber.PhoneNumber phoneNumber) {
        StringBuilder sb = new StringBuilder();
        if (phoneNumber.isItalianLeadingZero() && phoneNumber.getNumberOfLeadingZeros() > 0) {
            char[] cArr = new char[phoneNumber.getNumberOfLeadingZeros()];
            Arrays.fill(cArr, '0');
            sb.append(new String(cArr));
        }
        sb.append(phoneNumber.getNationalNumber());
        return sb.toString();
    }

    private void prefixNumberWithCountryCallingCode(int i, PhoneNumberFormat phoneNumberFormat, StringBuilder sb) {
        int i2 = AnonymousClass2.$SwitchMap$com$google$i18n$phonenumbers$PhoneNumberUtil$PhoneNumberFormat[phoneNumberFormat.ordinal()];
        if (i2 == 1) {
            sb.insert(0, i).insert(0, PLUS_SIGN);
        } else if (i2 == 2) {
            sb.insert(0, " ").insert(0, i).insert(0, PLUS_SIGN);
        } else if (i2 == 3) {
            sb.insert(0, "-").insert(0, i).insert(0, PLUS_SIGN).insert(0, RFC3966_PREFIX);
        }
    }

    private String formatNsn(String str, Phonemetadata.PhoneMetadata phoneMetadata, PhoneNumberFormat phoneNumberFormat) {
        return formatNsn(str, phoneMetadata, phoneNumberFormat, (CharSequence) null);
    }

    private String formatNsn(String str, Phonemetadata.PhoneMetadata phoneMetadata, PhoneNumberFormat phoneNumberFormat, CharSequence charSequence) {
        List<Phonemetadata.NumberFormat> list;
        if (phoneMetadata.getIntlNumberFormatList().size() == 0 || phoneNumberFormat == PhoneNumberFormat.NATIONAL) {
            list = phoneMetadata.getNumberFormatList();
        } else {
            list = phoneMetadata.getIntlNumberFormatList();
        }
        Phonemetadata.NumberFormat chooseFormattingPatternForNumber = chooseFormattingPatternForNumber(list, str);
        return chooseFormattingPatternForNumber == null ? str : formatNsnUsingPattern(str, chooseFormattingPatternForNumber, phoneNumberFormat, charSequence);
    }

    /* access modifiers changed from: package-private */
    public Phonemetadata.NumberFormat chooseFormattingPatternForNumber(List<Phonemetadata.NumberFormat> list, String str) {
        for (Phonemetadata.NumberFormat next : list) {
            int leadingDigitsPatternCount = next.getLeadingDigitsPatternCount();
            if ((leadingDigitsPatternCount == 0 || this.regexCache.getPatternForRegex(next.getLeadingDigitsPattern(leadingDigitsPatternCount - 1)).matcher(str).lookingAt()) && this.regexCache.getPatternForRegex(next.getPattern()).matcher(str).matches()) {
                return next;
            }
        }
        return null;
    }

    /* access modifiers changed from: package-private */
    public String formatNsnUsingPattern(String str, Phonemetadata.NumberFormat numberFormat, PhoneNumberFormat phoneNumberFormat) {
        return formatNsnUsingPattern(str, numberFormat, phoneNumberFormat, (CharSequence) null);
    }

    private String formatNsnUsingPattern(String str, Phonemetadata.NumberFormat numberFormat, PhoneNumberFormat phoneNumberFormat, CharSequence charSequence) {
        String str2;
        String format = numberFormat.getFormat();
        Matcher matcher = this.regexCache.getPatternForRegex(numberFormat.getPattern()).matcher(str);
        PhoneNumberFormat phoneNumberFormat2 = PhoneNumberFormat.NATIONAL;
        if (phoneNumberFormat != phoneNumberFormat2 || charSequence == null || charSequence.length() <= 0 || numberFormat.getDomesticCarrierCodeFormattingRule().length() <= 0) {
            String nationalPrefixFormattingRule = numberFormat.getNationalPrefixFormattingRule();
            if (phoneNumberFormat != phoneNumberFormat2 || nationalPrefixFormattingRule == null || nationalPrefixFormattingRule.length() <= 0) {
                str2 = matcher.replaceAll(format);
            } else {
                str2 = matcher.replaceAll(FIRST_GROUP_PATTERN.matcher(format).replaceFirst(nationalPrefixFormattingRule));
            }
        } else {
            str2 = matcher.replaceAll(FIRST_GROUP_PATTERN.matcher(format).replaceFirst(numberFormat.getDomesticCarrierCodeFormattingRule().replace(CC_STRING, charSequence)));
        }
        if (phoneNumberFormat != PhoneNumberFormat.RFC3966) {
            return str2;
        }
        Matcher matcher2 = SEPARATOR_PATTERN.matcher(str2);
        if (matcher2.lookingAt()) {
            str2 = matcher2.replaceFirst("");
        }
        return matcher2.reset(str2).replaceAll("-");
    }

    public Phonenumber.PhoneNumber getExampleNumber(String str) {
        return getExampleNumberForType(str, PhoneNumberType.FIXED_LINE);
    }

    public Phonenumber.PhoneNumber getInvalidExampleNumber(String str) {
        if (!isValidRegionCode(str)) {
            logger.log(Level.WARNING, "Invalid or unknown region code provided: " + str);
            return null;
        }
        Phonemetadata.PhoneNumberDesc numberDescByType = getNumberDescByType(getMetadataForRegion(str), PhoneNumberType.FIXED_LINE);
        if (!numberDescByType.hasExampleNumber()) {
            return null;
        }
        String exampleNumber = numberDescByType.getExampleNumber();
        int length = exampleNumber.length();
        while (true) {
            length--;
            if (length < 2) {
                return null;
            }
            try {
                Phonenumber.PhoneNumber parse = parse(exampleNumber.substring(0, length), str);
                if (!isValidNumber(parse)) {
                    return parse;
                }
            } catch (NumberParseException unused) {
            }
        }
    }

    public Phonenumber.PhoneNumber getExampleNumberForType(String str, PhoneNumberType phoneNumberType) {
        if (!isValidRegionCode(str)) {
            Logger logger2 = logger;
            Level level = Level.WARNING;
            logger2.log(level, "Invalid or unknown region code provided: " + str);
            return null;
        }
        Phonemetadata.PhoneNumberDesc numberDescByType = getNumberDescByType(getMetadataForRegion(str), phoneNumberType);
        try {
            if (numberDescByType.hasExampleNumber()) {
                return parse(numberDescByType.getExampleNumber(), str);
            }
        } catch (NumberParseException e) {
            logger.log(Level.SEVERE, e.toString());
        }
        return null;
    }

    public Phonenumber.PhoneNumber getExampleNumberForType(PhoneNumberType phoneNumberType) {
        for (String exampleNumberForType : getSupportedRegions()) {
            Phonenumber.PhoneNumber exampleNumberForType2 = getExampleNumberForType(exampleNumberForType, phoneNumberType);
            if (exampleNumberForType2 != null) {
                return exampleNumberForType2;
            }
        }
        for (Integer intValue : getSupportedGlobalNetworkCallingCodes()) {
            int intValue2 = intValue.intValue();
            Phonemetadata.PhoneNumberDesc numberDescByType = getNumberDescByType(getMetadataForNonGeographicalRegion(intValue2), phoneNumberType);
            try {
                if (numberDescByType.hasExampleNumber()) {
                    return parse("+" + intValue2 + numberDescByType.getExampleNumber(), UNKNOWN_REGION);
                }
            } catch (NumberParseException e) {
                logger.log(Level.SEVERE, e.toString());
            }
        }
        return null;
    }

    public Phonenumber.PhoneNumber getExampleNumberForNonGeoEntity(int i) {
        Phonemetadata.PhoneMetadata metadataForNonGeographicalRegion = getMetadataForNonGeographicalRegion(i);
        if (metadataForNonGeographicalRegion != null) {
            for (Phonemetadata.PhoneNumberDesc phoneNumberDesc : Arrays.asList(new Phonemetadata.PhoneNumberDesc[]{metadataForNonGeographicalRegion.getMobile(), metadataForNonGeographicalRegion.getTollFree(), metadataForNonGeographicalRegion.getSharedCost(), metadataForNonGeographicalRegion.getVoip(), metadataForNonGeographicalRegion.getVoicemail(), metadataForNonGeographicalRegion.getUan(), metadataForNonGeographicalRegion.getPremiumRate()})) {
                if (phoneNumberDesc != null) {
                    try {
                        if (phoneNumberDesc.hasExampleNumber()) {
                            return parse("+" + i + phoneNumberDesc.getExampleNumber(), UNKNOWN_REGION);
                        }
                    } catch (NumberParseException e) {
                        logger.log(Level.SEVERE, e.toString());
                    }
                }
            }
            return null;
        }
        Logger logger2 = logger;
        Level level = Level.WARNING;
        logger2.log(level, "Invalid or unknown country calling code provided: " + i);
        return null;
    }

    private void maybeAppendFormattedExtension(Phonenumber.PhoneNumber phoneNumber, Phonemetadata.PhoneMetadata phoneMetadata, PhoneNumberFormat phoneNumberFormat, StringBuilder sb) {
        if (phoneNumber.hasExtension() && phoneNumber.getExtension().length() > 0) {
            if (phoneNumberFormat == PhoneNumberFormat.RFC3966) {
                sb.append(RFC3966_EXTN_PREFIX);
                sb.append(phoneNumber.getExtension());
            } else if (phoneMetadata.hasPreferredExtnPrefix()) {
                sb.append(phoneMetadata.getPreferredExtnPrefix());
                sb.append(phoneNumber.getExtension());
            } else {
                sb.append(DEFAULT_EXTN_PREFIX);
                sb.append(phoneNumber.getExtension());
            }
        }
    }

    /* renamed from: com.android.internal.telephony.phonenumbers.PhoneNumberUtil$2  reason: invalid class name */
    static /* synthetic */ class AnonymousClass2 {
        static final /* synthetic */ int[] $SwitchMap$com$google$i18n$phonenumbers$PhoneNumberUtil$PhoneNumberFormat;
        static final /* synthetic */ int[] $SwitchMap$com$google$i18n$phonenumbers$PhoneNumberUtil$PhoneNumberType;
        static final /* synthetic */ int[] $SwitchMap$com$google$i18n$phonenumbers$Phonenumber$PhoneNumber$CountryCodeSource;

        /* JADX WARNING: Can't wrap try/catch for region: R(39:0|(2:1|2)|3|(2:5|6)|7|(2:9|10)|11|13|14|15|16|17|18|19|20|21|22|23|24|25|26|(2:27|28)|29|31|32|33|34|35|36|37|38|39|41|42|43|44|45|46|(3:47|48|50)) */
        /* JADX WARNING: Can't wrap try/catch for region: R(40:0|(2:1|2)|3|(2:5|6)|7|9|10|11|13|14|15|16|17|18|19|20|21|22|23|24|25|26|(2:27|28)|29|31|32|33|34|35|36|37|38|39|41|42|43|44|45|46|(3:47|48|50)) */
        /* JADX WARNING: Can't wrap try/catch for region: R(43:0|(2:1|2)|3|(2:5|6)|7|9|10|11|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|31|32|33|34|35|36|37|38|39|41|42|43|44|45|46|47|48|50) */
        /* JADX WARNING: Can't wrap try/catch for region: R(44:0|(2:1|2)|3|5|6|7|9|10|11|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|31|32|33|34|35|36|37|38|39|41|42|43|44|45|46|47|48|50) */
        /* JADX WARNING: Can't wrap try/catch for region: R(45:0|1|2|3|5|6|7|9|10|11|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|31|32|33|34|35|36|37|38|39|41|42|43|44|45|46|47|48|50) */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:15:0x0033 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:17:0x003e */
        /* JADX WARNING: Missing exception handler attribute for start block: B:19:0x0049 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:21:0x0054 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:23:0x0060 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:25:0x006c */
        /* JADX WARNING: Missing exception handler attribute for start block: B:27:0x0078 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:33:0x0095 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:35:0x009f */
        /* JADX WARNING: Missing exception handler attribute for start block: B:37:0x00a9 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:43:0x00c4 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:45:0x00ce */
        /* JADX WARNING: Missing exception handler attribute for start block: B:47:0x00d8 */
        static {
            /*
                com.android.internal.telephony.phonenumbers.PhoneNumberUtil$PhoneNumberType[] r0 = com.android.internal.telephony.phonenumbers.PhoneNumberUtil.PhoneNumberType.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$google$i18n$phonenumbers$PhoneNumberUtil$PhoneNumberType = r0
                r1 = 1
                com.android.internal.telephony.phonenumbers.PhoneNumberUtil$PhoneNumberType r2 = com.android.internal.telephony.phonenumbers.PhoneNumberUtil.PhoneNumberType.PREMIUM_RATE     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r2 = r2.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r0[r2] = r1     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                r0 = 2
                int[] r2 = $SwitchMap$com$google$i18n$phonenumbers$PhoneNumberUtil$PhoneNumberType     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.phonenumbers.PhoneNumberUtil$PhoneNumberType r3 = com.android.internal.telephony.phonenumbers.PhoneNumberUtil.PhoneNumberType.TOLL_FREE     // Catch:{ NoSuchFieldError -> 0x001d }
                int r3 = r3.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2[r3] = r0     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                r2 = 3
                int[] r3 = $SwitchMap$com$google$i18n$phonenumbers$PhoneNumberUtil$PhoneNumberType     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.phonenumbers.PhoneNumberUtil$PhoneNumberType r4 = com.android.internal.telephony.phonenumbers.PhoneNumberUtil.PhoneNumberType.MOBILE     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r4 = r4.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r3[r4] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                r3 = 4
                int[] r4 = $SwitchMap$com$google$i18n$phonenumbers$PhoneNumberUtil$PhoneNumberType     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.phonenumbers.PhoneNumberUtil$PhoneNumberType r5 = com.android.internal.telephony.phonenumbers.PhoneNumberUtil.PhoneNumberType.FIXED_LINE     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r4[r5] = r3     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                int[] r4 = $SwitchMap$com$google$i18n$phonenumbers$PhoneNumberUtil$PhoneNumberType     // Catch:{ NoSuchFieldError -> 0x003e }
                com.android.internal.telephony.phonenumbers.PhoneNumberUtil$PhoneNumberType r5 = com.android.internal.telephony.phonenumbers.PhoneNumberUtil.PhoneNumberType.FIXED_LINE_OR_MOBILE     // Catch:{ NoSuchFieldError -> 0x003e }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x003e }
                r6 = 5
                r4[r5] = r6     // Catch:{ NoSuchFieldError -> 0x003e }
            L_0x003e:
                int[] r4 = $SwitchMap$com$google$i18n$phonenumbers$PhoneNumberUtil$PhoneNumberType     // Catch:{ NoSuchFieldError -> 0x0049 }
                com.android.internal.telephony.phonenumbers.PhoneNumberUtil$PhoneNumberType r5 = com.android.internal.telephony.phonenumbers.PhoneNumberUtil.PhoneNumberType.SHARED_COST     // Catch:{ NoSuchFieldError -> 0x0049 }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x0049 }
                r6 = 6
                r4[r5] = r6     // Catch:{ NoSuchFieldError -> 0x0049 }
            L_0x0049:
                int[] r4 = $SwitchMap$com$google$i18n$phonenumbers$PhoneNumberUtil$PhoneNumberType     // Catch:{ NoSuchFieldError -> 0x0054 }
                com.android.internal.telephony.phonenumbers.PhoneNumberUtil$PhoneNumberType r5 = com.android.internal.telephony.phonenumbers.PhoneNumberUtil.PhoneNumberType.VOIP     // Catch:{ NoSuchFieldError -> 0x0054 }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x0054 }
                r6 = 7
                r4[r5] = r6     // Catch:{ NoSuchFieldError -> 0x0054 }
            L_0x0054:
                int[] r4 = $SwitchMap$com$google$i18n$phonenumbers$PhoneNumberUtil$PhoneNumberType     // Catch:{ NoSuchFieldError -> 0x0060 }
                com.android.internal.telephony.phonenumbers.PhoneNumberUtil$PhoneNumberType r5 = com.android.internal.telephony.phonenumbers.PhoneNumberUtil.PhoneNumberType.PERSONAL_NUMBER     // Catch:{ NoSuchFieldError -> 0x0060 }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x0060 }
                r6 = 8
                r4[r5] = r6     // Catch:{ NoSuchFieldError -> 0x0060 }
            L_0x0060:
                int[] r4 = $SwitchMap$com$google$i18n$phonenumbers$PhoneNumberUtil$PhoneNumberType     // Catch:{ NoSuchFieldError -> 0x006c }
                com.android.internal.telephony.phonenumbers.PhoneNumberUtil$PhoneNumberType r5 = com.android.internal.telephony.phonenumbers.PhoneNumberUtil.PhoneNumberType.PAGER     // Catch:{ NoSuchFieldError -> 0x006c }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x006c }
                r6 = 9
                r4[r5] = r6     // Catch:{ NoSuchFieldError -> 0x006c }
            L_0x006c:
                int[] r4 = $SwitchMap$com$google$i18n$phonenumbers$PhoneNumberUtil$PhoneNumberType     // Catch:{ NoSuchFieldError -> 0x0078 }
                com.android.internal.telephony.phonenumbers.PhoneNumberUtil$PhoneNumberType r5 = com.android.internal.telephony.phonenumbers.PhoneNumberUtil.PhoneNumberType.UAN     // Catch:{ NoSuchFieldError -> 0x0078 }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x0078 }
                r6 = 10
                r4[r5] = r6     // Catch:{ NoSuchFieldError -> 0x0078 }
            L_0x0078:
                int[] r4 = $SwitchMap$com$google$i18n$phonenumbers$PhoneNumberUtil$PhoneNumberType     // Catch:{ NoSuchFieldError -> 0x0084 }
                com.android.internal.telephony.phonenumbers.PhoneNumberUtil$PhoneNumberType r5 = com.android.internal.telephony.phonenumbers.PhoneNumberUtil.PhoneNumberType.VOICEMAIL     // Catch:{ NoSuchFieldError -> 0x0084 }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x0084 }
                r6 = 11
                r4[r5] = r6     // Catch:{ NoSuchFieldError -> 0x0084 }
            L_0x0084:
                com.android.internal.telephony.phonenumbers.PhoneNumberUtil$PhoneNumberFormat[] r4 = com.android.internal.telephony.phonenumbers.PhoneNumberUtil.PhoneNumberFormat.values()
                int r4 = r4.length
                int[] r4 = new int[r4]
                $SwitchMap$com$google$i18n$phonenumbers$PhoneNumberUtil$PhoneNumberFormat = r4
                com.android.internal.telephony.phonenumbers.PhoneNumberUtil$PhoneNumberFormat r5 = com.android.internal.telephony.phonenumbers.PhoneNumberUtil.PhoneNumberFormat.E164     // Catch:{ NoSuchFieldError -> 0x0095 }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x0095 }
                r4[r5] = r1     // Catch:{ NoSuchFieldError -> 0x0095 }
            L_0x0095:
                int[] r4 = $SwitchMap$com$google$i18n$phonenumbers$PhoneNumberUtil$PhoneNumberFormat     // Catch:{ NoSuchFieldError -> 0x009f }
                com.android.internal.telephony.phonenumbers.PhoneNumberUtil$PhoneNumberFormat r5 = com.android.internal.telephony.phonenumbers.PhoneNumberUtil.PhoneNumberFormat.INTERNATIONAL     // Catch:{ NoSuchFieldError -> 0x009f }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x009f }
                r4[r5] = r0     // Catch:{ NoSuchFieldError -> 0x009f }
            L_0x009f:
                int[] r4 = $SwitchMap$com$google$i18n$phonenumbers$PhoneNumberUtil$PhoneNumberFormat     // Catch:{ NoSuchFieldError -> 0x00a9 }
                com.android.internal.telephony.phonenumbers.PhoneNumberUtil$PhoneNumberFormat r5 = com.android.internal.telephony.phonenumbers.PhoneNumberUtil.PhoneNumberFormat.RFC3966     // Catch:{ NoSuchFieldError -> 0x00a9 }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x00a9 }
                r4[r5] = r2     // Catch:{ NoSuchFieldError -> 0x00a9 }
            L_0x00a9:
                int[] r4 = $SwitchMap$com$google$i18n$phonenumbers$PhoneNumberUtil$PhoneNumberFormat     // Catch:{ NoSuchFieldError -> 0x00b3 }
                com.android.internal.telephony.phonenumbers.PhoneNumberUtil$PhoneNumberFormat r5 = com.android.internal.telephony.phonenumbers.PhoneNumberUtil.PhoneNumberFormat.NATIONAL     // Catch:{ NoSuchFieldError -> 0x00b3 }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x00b3 }
                r4[r5] = r3     // Catch:{ NoSuchFieldError -> 0x00b3 }
            L_0x00b3:
                com.android.internal.telephony.phonenumbers.Phonenumber$PhoneNumber$CountryCodeSource[] r4 = com.android.internal.telephony.phonenumbers.Phonenumber.PhoneNumber.CountryCodeSource.values()
                int r4 = r4.length
                int[] r4 = new int[r4]
                $SwitchMap$com$google$i18n$phonenumbers$Phonenumber$PhoneNumber$CountryCodeSource = r4
                com.android.internal.telephony.phonenumbers.Phonenumber$PhoneNumber$CountryCodeSource r5 = com.android.internal.telephony.phonenumbers.Phonenumber.PhoneNumber.CountryCodeSource.FROM_NUMBER_WITH_PLUS_SIGN     // Catch:{ NoSuchFieldError -> 0x00c4 }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x00c4 }
                r4[r5] = r1     // Catch:{ NoSuchFieldError -> 0x00c4 }
            L_0x00c4:
                int[] r1 = $SwitchMap$com$google$i18n$phonenumbers$Phonenumber$PhoneNumber$CountryCodeSource     // Catch:{ NoSuchFieldError -> 0x00ce }
                com.android.internal.telephony.phonenumbers.Phonenumber$PhoneNumber$CountryCodeSource r4 = com.android.internal.telephony.phonenumbers.Phonenumber.PhoneNumber.CountryCodeSource.FROM_NUMBER_WITH_IDD     // Catch:{ NoSuchFieldError -> 0x00ce }
                int r4 = r4.ordinal()     // Catch:{ NoSuchFieldError -> 0x00ce }
                r1[r4] = r0     // Catch:{ NoSuchFieldError -> 0x00ce }
            L_0x00ce:
                int[] r0 = $SwitchMap$com$google$i18n$phonenumbers$Phonenumber$PhoneNumber$CountryCodeSource     // Catch:{ NoSuchFieldError -> 0x00d8 }
                com.android.internal.telephony.phonenumbers.Phonenumber$PhoneNumber$CountryCodeSource r1 = com.android.internal.telephony.phonenumbers.Phonenumber.PhoneNumber.CountryCodeSource.FROM_NUMBER_WITHOUT_PLUS_SIGN     // Catch:{ NoSuchFieldError -> 0x00d8 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00d8 }
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00d8 }
            L_0x00d8:
                int[] r0 = $SwitchMap$com$google$i18n$phonenumbers$Phonenumber$PhoneNumber$CountryCodeSource     // Catch:{ NoSuchFieldError -> 0x00e2 }
                com.android.internal.telephony.phonenumbers.Phonenumber$PhoneNumber$CountryCodeSource r1 = com.android.internal.telephony.phonenumbers.Phonenumber.PhoneNumber.CountryCodeSource.FROM_DEFAULT_COUNTRY     // Catch:{ NoSuchFieldError -> 0x00e2 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00e2 }
                r0[r1] = r3     // Catch:{ NoSuchFieldError -> 0x00e2 }
            L_0x00e2:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.phonenumbers.PhoneNumberUtil.AnonymousClass2.<clinit>():void");
        }
    }

    /* access modifiers changed from: package-private */
    public Phonemetadata.PhoneNumberDesc getNumberDescByType(Phonemetadata.PhoneMetadata phoneMetadata, PhoneNumberType phoneNumberType) {
        switch (AnonymousClass2.$SwitchMap$com$google$i18n$phonenumbers$PhoneNumberUtil$PhoneNumberType[phoneNumberType.ordinal()]) {
            case 1:
                return phoneMetadata.getPremiumRate();
            case 2:
                return phoneMetadata.getTollFree();
            case 3:
                return phoneMetadata.getMobile();
            case 4:
            case 5:
                return phoneMetadata.getFixedLine();
            case 6:
                return phoneMetadata.getSharedCost();
            case 7:
                return phoneMetadata.getVoip();
            case 8:
                return phoneMetadata.getPersonalNumber();
            case 9:
                return phoneMetadata.getPager();
            case 10:
                return phoneMetadata.getUan();
            case 11:
                return phoneMetadata.getVoicemail();
            default:
                return phoneMetadata.getGeneralDesc();
        }
    }

    public PhoneNumberType getNumberType(Phonenumber.PhoneNumber phoneNumber) {
        Phonemetadata.PhoneMetadata metadataForRegionOrCallingCode = getMetadataForRegionOrCallingCode(phoneNumber.getCountryCode(), getRegionCodeForNumber(phoneNumber));
        if (metadataForRegionOrCallingCode == null) {
            return PhoneNumberType.UNKNOWN;
        }
        return getNumberTypeHelper(getNationalSignificantNumber(phoneNumber), metadataForRegionOrCallingCode);
    }

    private PhoneNumberType getNumberTypeHelper(String str, Phonemetadata.PhoneMetadata phoneMetadata) {
        if (!isNumberMatchingDesc(str, phoneMetadata.getGeneralDesc())) {
            return PhoneNumberType.UNKNOWN;
        }
        if (isNumberMatchingDesc(str, phoneMetadata.getPremiumRate())) {
            return PhoneNumberType.PREMIUM_RATE;
        }
        if (isNumberMatchingDesc(str, phoneMetadata.getTollFree())) {
            return PhoneNumberType.TOLL_FREE;
        }
        if (isNumberMatchingDesc(str, phoneMetadata.getSharedCost())) {
            return PhoneNumberType.SHARED_COST;
        }
        if (isNumberMatchingDesc(str, phoneMetadata.getVoip())) {
            return PhoneNumberType.VOIP;
        }
        if (isNumberMatchingDesc(str, phoneMetadata.getPersonalNumber())) {
            return PhoneNumberType.PERSONAL_NUMBER;
        }
        if (isNumberMatchingDesc(str, phoneMetadata.getPager())) {
            return PhoneNumberType.PAGER;
        }
        if (isNumberMatchingDesc(str, phoneMetadata.getUan())) {
            return PhoneNumberType.UAN;
        }
        if (isNumberMatchingDesc(str, phoneMetadata.getVoicemail())) {
            return PhoneNumberType.VOICEMAIL;
        }
        if (isNumberMatchingDesc(str, phoneMetadata.getFixedLine())) {
            if (phoneMetadata.getSameMobileAndFixedLinePattern()) {
                return PhoneNumberType.FIXED_LINE_OR_MOBILE;
            }
            if (isNumberMatchingDesc(str, phoneMetadata.getMobile())) {
                return PhoneNumberType.FIXED_LINE_OR_MOBILE;
            }
            return PhoneNumberType.FIXED_LINE;
        } else if (phoneMetadata.getSameMobileAndFixedLinePattern() || !isNumberMatchingDesc(str, phoneMetadata.getMobile())) {
            return PhoneNumberType.UNKNOWN;
        } else {
            return PhoneNumberType.MOBILE;
        }
    }

    /* access modifiers changed from: package-private */
    public Phonemetadata.PhoneMetadata getMetadataForRegion(String str) {
        if (!isValidRegionCode(str)) {
            return null;
        }
        return this.metadataSource.getMetadataForRegion(str);
    }

    /* access modifiers changed from: package-private */
    public Phonemetadata.PhoneMetadata getMetadataForNonGeographicalRegion(int i) {
        if (!this.countryCallingCodeToRegionCodeMap.containsKey(Integer.valueOf(i))) {
            return null;
        }
        return this.metadataSource.getMetadataForNonGeographicalRegion(i);
    }

    /* access modifiers changed from: package-private */
    public boolean isNumberMatchingDesc(String str, Phonemetadata.PhoneNumberDesc phoneNumberDesc) {
        int length = str.length();
        List<Integer> possibleLengthList = phoneNumberDesc.getPossibleLengthList();
        if (possibleLengthList.size() <= 0 || possibleLengthList.contains(Integer.valueOf(length))) {
            return this.matcherApi.matchNationalNumber(str, phoneNumberDesc, false);
        }
        return false;
    }

    public boolean isValidNumber(Phonenumber.PhoneNumber phoneNumber) {
        return isValidNumberForRegion(phoneNumber, getRegionCodeForNumber(phoneNumber));
    }

    public boolean isValidNumberForRegion(Phonenumber.PhoneNumber phoneNumber, String str) {
        int countryCode = phoneNumber.getCountryCode();
        Phonemetadata.PhoneMetadata metadataForRegionOrCallingCode = getMetadataForRegionOrCallingCode(countryCode, str);
        if (metadataForRegionOrCallingCode == null) {
            return false;
        }
        if ((REGION_CODE_FOR_NON_GEO_ENTITY.equals(str) || countryCode == getCountryCodeForValidRegion(str)) && getNumberTypeHelper(getNationalSignificantNumber(phoneNumber), metadataForRegionOrCallingCode) != PhoneNumberType.UNKNOWN) {
            return true;
        }
        return false;
    }

    public String getRegionCodeForNumber(Phonenumber.PhoneNumber phoneNumber) {
        int countryCode = phoneNumber.getCountryCode();
        List list = this.countryCallingCodeToRegionCodeMap.get(Integer.valueOf(countryCode));
        if (list == null) {
            Logger logger2 = logger;
            Level level = Level.INFO;
            logger2.log(level, "Missing/invalid country_code (" + countryCode + ")");
            return null;
        } else if (list.size() == 1) {
            return (String) list.get(0);
        } else {
            return getRegionCodeForNumberFromRegionList(phoneNumber, list);
        }
    }

    private String getRegionCodeForNumberFromRegionList(Phonenumber.PhoneNumber phoneNumber, List<String> list) {
        String nationalSignificantNumber = getNationalSignificantNumber(phoneNumber);
        for (String next : list) {
            Phonemetadata.PhoneMetadata metadataForRegion = getMetadataForRegion(next);
            if (metadataForRegion.hasLeadingDigits()) {
                if (this.regexCache.getPatternForRegex(metadataForRegion.getLeadingDigits()).matcher(nationalSignificantNumber).lookingAt()) {
                    return next;
                }
            } else if (getNumberTypeHelper(nationalSignificantNumber, metadataForRegion) != PhoneNumberType.UNKNOWN) {
                return next;
            }
        }
        return null;
    }

    public String getRegionCodeForCountryCode(int i) {
        List list = this.countryCallingCodeToRegionCodeMap.get(Integer.valueOf(i));
        if (list == null) {
            return UNKNOWN_REGION;
        }
        return (String) list.get(0);
    }

    public List<String> getRegionCodesForCountryCode(int i) {
        List list = this.countryCallingCodeToRegionCodeMap.get(Integer.valueOf(i));
        if (list == null) {
            list = new ArrayList(0);
        }
        return Collections.unmodifiableList(list);
    }

    public int getCountryCodeForRegion(String str) {
        if (isValidRegionCode(str)) {
            return getCountryCodeForValidRegion(str);
        }
        Logger logger2 = logger;
        Level level = Level.WARNING;
        StringBuilder sb = new StringBuilder();
        sb.append("Invalid or missing region code (");
        if (str == null) {
            str = "null";
        }
        sb.append(str);
        sb.append(") provided.");
        logger2.log(level, sb.toString());
        return 0;
    }

    private int getCountryCodeForValidRegion(String str) {
        Phonemetadata.PhoneMetadata metadataForRegion = getMetadataForRegion(str);
        if (metadataForRegion != null) {
            return metadataForRegion.getCountryCode();
        }
        throw new IllegalArgumentException("Invalid region code: " + str);
    }

    public String getNddPrefixForRegion(String str, boolean z) {
        Phonemetadata.PhoneMetadata metadataForRegion = getMetadataForRegion(str);
        if (metadataForRegion == null) {
            Logger logger2 = logger;
            Level level = Level.WARNING;
            StringBuilder sb = new StringBuilder();
            sb.append("Invalid or missing region code (");
            if (str == null) {
                str = "null";
            }
            sb.append(str);
            sb.append(") provided.");
            logger2.log(level, sb.toString());
            return null;
        }
        String nationalPrefix = metadataForRegion.getNationalPrefix();
        if (nationalPrefix.length() == 0) {
            return null;
        }
        return z ? nationalPrefix.replace("~", "") : nationalPrefix;
    }

    public boolean isNANPACountry(String str) {
        return this.nanpaRegions.contains(str);
    }

    public boolean isAlphaNumber(CharSequence charSequence) {
        if (!isViablePhoneNumber(charSequence)) {
            return false;
        }
        StringBuilder sb = new StringBuilder(charSequence);
        maybeStripExtension(sb);
        return VALID_ALPHA_PHONE_PATTERN.matcher(sb).matches();
    }

    public boolean isPossibleNumber(Phonenumber.PhoneNumber phoneNumber) {
        ValidationResult isPossibleNumberWithReason = isPossibleNumberWithReason(phoneNumber);
        return isPossibleNumberWithReason == ValidationResult.IS_POSSIBLE || isPossibleNumberWithReason == ValidationResult.IS_POSSIBLE_LOCAL_ONLY;
    }

    public boolean isPossibleNumberForType(Phonenumber.PhoneNumber phoneNumber, PhoneNumberType phoneNumberType) {
        ValidationResult isPossibleNumberForTypeWithReason = isPossibleNumberForTypeWithReason(phoneNumber, phoneNumberType);
        return isPossibleNumberForTypeWithReason == ValidationResult.IS_POSSIBLE || isPossibleNumberForTypeWithReason == ValidationResult.IS_POSSIBLE_LOCAL_ONLY;
    }

    private ValidationResult testNumberLength(CharSequence charSequence, Phonemetadata.PhoneMetadata phoneMetadata) {
        return testNumberLength(charSequence, phoneMetadata, PhoneNumberType.UNKNOWN);
    }

    private ValidationResult testNumberLength(CharSequence charSequence, Phonemetadata.PhoneMetadata phoneMetadata, PhoneNumberType phoneNumberType) {
        List<Integer> list;
        Phonemetadata.PhoneNumberDesc numberDescByType = getNumberDescByType(phoneMetadata, phoneNumberType);
        ArrayList possibleLengthList = numberDescByType.getPossibleLengthList().isEmpty() ? phoneMetadata.getGeneralDesc().getPossibleLengthList() : numberDescByType.getPossibleLengthList();
        List<Integer> possibleLengthLocalOnlyList = numberDescByType.getPossibleLengthLocalOnlyList();
        if (phoneNumberType == PhoneNumberType.FIXED_LINE_OR_MOBILE) {
            if (!descHasPossibleNumberData(getNumberDescByType(phoneMetadata, PhoneNumberType.FIXED_LINE))) {
                return testNumberLength(charSequence, phoneMetadata, PhoneNumberType.MOBILE);
            }
            Phonemetadata.PhoneNumberDesc numberDescByType2 = getNumberDescByType(phoneMetadata, PhoneNumberType.MOBILE);
            if (descHasPossibleNumberData(numberDescByType2)) {
                ArrayList arrayList = new ArrayList(possibleLengthList);
                if (numberDescByType2.getPossibleLengthCount() == 0) {
                    list = phoneMetadata.getGeneralDesc().getPossibleLengthList();
                } else {
                    list = numberDescByType2.getPossibleLengthList();
                }
                arrayList.addAll(list);
                Collections.sort(arrayList);
                if (possibleLengthLocalOnlyList.isEmpty()) {
                    possibleLengthLocalOnlyList = numberDescByType2.getPossibleLengthLocalOnlyList();
                } else {
                    ArrayList arrayList2 = new ArrayList(possibleLengthLocalOnlyList);
                    arrayList2.addAll(numberDescByType2.getPossibleLengthLocalOnlyList());
                    Collections.sort(arrayList2);
                    possibleLengthLocalOnlyList = arrayList2;
                }
                possibleLengthList = arrayList;
            }
        }
        if (((Integer) possibleLengthList.get(0)).intValue() == -1) {
            return ValidationResult.INVALID_LENGTH;
        }
        int length = charSequence.length();
        if (possibleLengthLocalOnlyList.contains(Integer.valueOf(length))) {
            return ValidationResult.IS_POSSIBLE_LOCAL_ONLY;
        }
        int intValue = ((Integer) possibleLengthList.get(0)).intValue();
        if (intValue == length) {
            return ValidationResult.IS_POSSIBLE;
        }
        if (intValue > length) {
            return ValidationResult.TOO_SHORT;
        }
        if (((Integer) possibleLengthList.get(possibleLengthList.size() - 1)).intValue() < length) {
            return ValidationResult.TOO_LONG;
        }
        return possibleLengthList.subList(1, possibleLengthList.size()).contains(Integer.valueOf(length)) ? ValidationResult.IS_POSSIBLE : ValidationResult.INVALID_LENGTH;
    }

    public ValidationResult isPossibleNumberWithReason(Phonenumber.PhoneNumber phoneNumber) {
        return isPossibleNumberForTypeWithReason(phoneNumber, PhoneNumberType.UNKNOWN);
    }

    public ValidationResult isPossibleNumberForTypeWithReason(Phonenumber.PhoneNumber phoneNumber, PhoneNumberType phoneNumberType) {
        String nationalSignificantNumber = getNationalSignificantNumber(phoneNumber);
        int countryCode = phoneNumber.getCountryCode();
        if (!hasValidCountryCallingCode(countryCode)) {
            return ValidationResult.INVALID_COUNTRY_CODE;
        }
        return testNumberLength(nationalSignificantNumber, getMetadataForRegionOrCallingCode(countryCode, getRegionCodeForCountryCode(countryCode)), phoneNumberType);
    }

    public boolean isPossibleNumber(CharSequence charSequence, String str) {
        try {
            return isPossibleNumber(parse(charSequence, str));
        } catch (NumberParseException unused) {
            return false;
        }
    }

    public boolean truncateTooLongNumber(Phonenumber.PhoneNumber phoneNumber) {
        if (isValidNumber(phoneNumber)) {
            return true;
        }
        Phonenumber.PhoneNumber phoneNumber2 = new Phonenumber.PhoneNumber();
        phoneNumber2.mergeFrom(phoneNumber);
        long nationalNumber = phoneNumber.getNationalNumber();
        do {
            nationalNumber /= 10;
            phoneNumber2.setNationalNumber(nationalNumber);
            if (isPossibleNumberWithReason(phoneNumber2) == ValidationResult.TOO_SHORT || nationalNumber == 0) {
                return false;
            }
        } while (!isValidNumber(phoneNumber2));
        phoneNumber.setNationalNumber(nationalNumber);
        return true;
    }

    public AsYouTypeFormatter getAsYouTypeFormatter(String str) {
        return new AsYouTypeFormatter(str);
    }

    /* access modifiers changed from: package-private */
    public int extractCountryCode(StringBuilder sb, StringBuilder sb2) {
        if (!(sb.length() == 0 || sb.charAt(0) == '0')) {
            int length = sb.length();
            int i = 1;
            while (i <= 3 && i <= length) {
                int parseInt = Integer.parseInt(sb.substring(0, i));
                if (this.countryCallingCodeToRegionCodeMap.containsKey(Integer.valueOf(parseInt))) {
                    sb2.append(sb.substring(i));
                    return parseInt;
                }
                i++;
            }
        }
        return 0;
    }

    /* access modifiers changed from: package-private */
    public int maybeExtractCountryCode(CharSequence charSequence, Phonemetadata.PhoneMetadata phoneMetadata, StringBuilder sb, boolean z, Phonenumber.PhoneNumber phoneNumber) throws NumberParseException {
        if (charSequence.length() == 0) {
            return 0;
        }
        StringBuilder sb2 = new StringBuilder(charSequence);
        Phonenumber.PhoneNumber.CountryCodeSource maybeStripInternationalPrefixAndNormalize = maybeStripInternationalPrefixAndNormalize(sb2, phoneMetadata != null ? phoneMetadata.getInternationalPrefix() : "NonMatch");
        if (z) {
            phoneNumber.setCountryCodeSource(maybeStripInternationalPrefixAndNormalize);
        }
        if (maybeStripInternationalPrefixAndNormalize == Phonenumber.PhoneNumber.CountryCodeSource.FROM_DEFAULT_COUNTRY) {
            if (phoneMetadata != null) {
                int countryCode = phoneMetadata.getCountryCode();
                String valueOf = String.valueOf(countryCode);
                String sb3 = sb2.toString();
                if (sb3.startsWith(valueOf)) {
                    StringBuilder sb4 = new StringBuilder(sb3.substring(valueOf.length()));
                    Phonemetadata.PhoneNumberDesc generalDesc = phoneMetadata.getGeneralDesc();
                    maybeStripNationalPrefixAndCarrierCode(sb4, phoneMetadata, (StringBuilder) null);
                    if ((!this.matcherApi.matchNationalNumber(sb2, generalDesc, false) && this.matcherApi.matchNationalNumber(sb4, generalDesc, false)) || testNumberLength(sb2, phoneMetadata) == ValidationResult.TOO_LONG) {
                        sb.append(sb4);
                        if (z) {
                            phoneNumber.setCountryCodeSource(Phonenumber.PhoneNumber.CountryCodeSource.FROM_NUMBER_WITHOUT_PLUS_SIGN);
                        }
                        phoneNumber.setCountryCode(countryCode);
                        return countryCode;
                    }
                }
            }
            phoneNumber.setCountryCode(0);
            return 0;
        } else if (sb2.length() > 2) {
            int extractCountryCode = extractCountryCode(sb2, sb);
            if (extractCountryCode != 0) {
                phoneNumber.setCountryCode(extractCountryCode);
                return extractCountryCode;
            }
            throw new NumberParseException(NumberParseException.ErrorType.INVALID_COUNTRY_CODE, "Country calling code supplied was not recognised.");
        } else {
            throw new NumberParseException(NumberParseException.ErrorType.TOO_SHORT_AFTER_IDD, "Phone number had an IDD, but after this was not long enough to be a viable phone number.");
        }
    }

    private boolean parsePrefixAsIdd(Pattern pattern, StringBuilder sb) {
        Matcher matcher = pattern.matcher(sb);
        if (!matcher.lookingAt()) {
            return false;
        }
        int end = matcher.end();
        Matcher matcher2 = CAPTURING_DIGIT_PATTERN.matcher(sb.substring(end));
        if (matcher2.find() && normalizeDigitsOnly(matcher2.group(1)).equals("0")) {
            return false;
        }
        sb.delete(0, end);
        return true;
    }

    /* access modifiers changed from: package-private */
    public Phonenumber.PhoneNumber.CountryCodeSource maybeStripInternationalPrefixAndNormalize(StringBuilder sb, String str) {
        if (sb.length() == 0) {
            return Phonenumber.PhoneNumber.CountryCodeSource.FROM_DEFAULT_COUNTRY;
        }
        Matcher matcher = PLUS_CHARS_PATTERN.matcher(sb);
        if (matcher.lookingAt()) {
            sb.delete(0, matcher.end());
            normalize(sb);
            return Phonenumber.PhoneNumber.CountryCodeSource.FROM_NUMBER_WITH_PLUS_SIGN;
        }
        Pattern patternForRegex = this.regexCache.getPatternForRegex(str);
        normalize(sb);
        if (parsePrefixAsIdd(patternForRegex, sb)) {
            return Phonenumber.PhoneNumber.CountryCodeSource.FROM_NUMBER_WITH_IDD;
        }
        return Phonenumber.PhoneNumber.CountryCodeSource.FROM_DEFAULT_COUNTRY;
    }

    /* access modifiers changed from: package-private */
    public boolean maybeStripNationalPrefixAndCarrierCode(StringBuilder sb, Phonemetadata.PhoneMetadata phoneMetadata, StringBuilder sb2) {
        int length = sb.length();
        String nationalPrefixForParsing = phoneMetadata.getNationalPrefixForParsing();
        if (!(length == 0 || nationalPrefixForParsing.length() == 0)) {
            Matcher matcher = this.regexCache.getPatternForRegex(nationalPrefixForParsing).matcher(sb);
            if (matcher.lookingAt()) {
                Phonemetadata.PhoneNumberDesc generalDesc = phoneMetadata.getGeneralDesc();
                boolean matchNationalNumber = this.matcherApi.matchNationalNumber(sb, generalDesc, false);
                int groupCount = matcher.groupCount();
                String nationalPrefixTransformRule = phoneMetadata.getNationalPrefixTransformRule();
                if (nationalPrefixTransformRule != null && nationalPrefixTransformRule.length() != 0 && matcher.group(groupCount) != null) {
                    StringBuilder sb3 = new StringBuilder(sb);
                    sb3.replace(0, length, matcher.replaceFirst(nationalPrefixTransformRule));
                    if (matchNationalNumber && !this.matcherApi.matchNationalNumber(sb3.toString(), generalDesc, false)) {
                        return false;
                    }
                    if (sb2 != null && groupCount > 1) {
                        sb2.append(matcher.group(1));
                    }
                    sb.replace(0, sb.length(), sb3.toString());
                    return true;
                } else if (matchNationalNumber && !this.matcherApi.matchNationalNumber(sb.substring(matcher.end()), generalDesc, false)) {
                    return false;
                } else {
                    if (!(sb2 == null || groupCount <= 0 || matcher.group(groupCount) == null)) {
                        sb2.append(matcher.group(1));
                    }
                    sb.delete(0, matcher.end());
                    return true;
                }
            }
        }
        return false;
    }

    /* access modifiers changed from: package-private */
    public String maybeStripExtension(StringBuilder sb) {
        Matcher matcher = EXTN_PATTERN.matcher(sb);
        if (!matcher.find() || !isViablePhoneNumber(sb.substring(0, matcher.start()))) {
            return "";
        }
        int groupCount = matcher.groupCount();
        for (int i = 1; i <= groupCount; i++) {
            if (matcher.group(i) != null) {
                String group = matcher.group(i);
                sb.delete(matcher.start(), sb.length());
                return group;
            }
        }
        return "";
    }

    private boolean checkRegionForParsing(CharSequence charSequence, String str) {
        if (!isValidRegionCode(str)) {
            return (charSequence == null || charSequence.length() == 0 || !PLUS_CHARS_PATTERN.matcher(charSequence).lookingAt()) ? false : true;
        }
        return true;
    }

    public Phonenumber.PhoneNumber parse(CharSequence charSequence, String str) throws NumberParseException {
        Phonenumber.PhoneNumber phoneNumber = new Phonenumber.PhoneNumber();
        parse(charSequence, str, phoneNumber);
        return phoneNumber;
    }

    public void parse(CharSequence charSequence, String str, Phonenumber.PhoneNumber phoneNumber) throws NumberParseException {
        parseHelper(charSequence, str, false, true, phoneNumber);
    }

    public Phonenumber.PhoneNumber parseAndKeepRawInput(CharSequence charSequence, String str) throws NumberParseException {
        Phonenumber.PhoneNumber phoneNumber = new Phonenumber.PhoneNumber();
        parseAndKeepRawInput(charSequence, str, phoneNumber);
        return phoneNumber;
    }

    public void parseAndKeepRawInput(CharSequence charSequence, String str, Phonenumber.PhoneNumber phoneNumber) throws NumberParseException {
        parseHelper(charSequence, str, true, true, phoneNumber);
    }

    public Iterable<PhoneNumberMatch> findNumbers(CharSequence charSequence, String str) {
        return findNumbers(charSequence, str, Leniency.VALID, Long.MAX_VALUE);
    }

    public Iterable<PhoneNumberMatch> findNumbers(CharSequence charSequence, String str, Leniency leniency, long j) {
        final CharSequence charSequence2 = charSequence;
        final String str2 = str;
        final Leniency leniency2 = leniency;
        final long j2 = j;
        return new Iterable<PhoneNumberMatch>() {
            public Iterator<PhoneNumberMatch> iterator() {
                return new PhoneNumberMatcher(PhoneNumberUtil.this, charSequence2, str2, leniency2, j2);
            }
        };
    }

    static void setItalianLeadingZerosForPhoneNumber(CharSequence charSequence, Phonenumber.PhoneNumber phoneNumber) {
        if (charSequence.length() > 1 && charSequence.charAt(0) == '0') {
            phoneNumber.setItalianLeadingZero(true);
            int i = 1;
            while (i < charSequence.length() - 1 && charSequence.charAt(i) == '0') {
                i++;
            }
            if (i != 1) {
                phoneNumber.setNumberOfLeadingZeros(i);
            }
        }
    }

    private void parseHelper(CharSequence charSequence, String str, boolean z, boolean z2, Phonenumber.PhoneNumber phoneNumber) throws NumberParseException {
        int i;
        if (charSequence == null) {
            throw new NumberParseException(NumberParseException.ErrorType.NOT_A_NUMBER, "The phone number supplied was null.");
        } else if (charSequence.length() <= 250) {
            StringBuilder sb = new StringBuilder();
            String charSequence2 = charSequence.toString();
            buildNationalNumberForParsing(charSequence2, sb);
            if (!isViablePhoneNumber(sb)) {
                throw new NumberParseException(NumberParseException.ErrorType.NOT_A_NUMBER, "The string supplied did not seem to be a phone number.");
            } else if (!z2 || checkRegionForParsing(sb, str)) {
                if (z) {
                    phoneNumber.setRawInput(charSequence2);
                }
                String maybeStripExtension = maybeStripExtension(sb);
                if (maybeStripExtension.length() > 0) {
                    phoneNumber.setExtension(maybeStripExtension);
                }
                Phonemetadata.PhoneMetadata metadataForRegion = getMetadataForRegion(str);
                StringBuilder sb2 = new StringBuilder();
                try {
                    i = maybeExtractCountryCode(sb, metadataForRegion, sb2, z, phoneNumber);
                } catch (NumberParseException e) {
                    Matcher matcher = PLUS_CHARS_PATTERN.matcher(sb);
                    if (e.getErrorType() != NumberParseException.ErrorType.INVALID_COUNTRY_CODE || !matcher.lookingAt()) {
                        throw new NumberParseException(e.getErrorType(), e.getMessage());
                    }
                    i = maybeExtractCountryCode(sb.substring(matcher.end()), metadataForRegion, sb2, z, phoneNumber);
                    if (i == 0) {
                        throw new NumberParseException(NumberParseException.ErrorType.INVALID_COUNTRY_CODE, "Could not interpret numbers after plus-sign.");
                    }
                }
                if (i != 0) {
                    String regionCodeForCountryCode = getRegionCodeForCountryCode(i);
                    if (!regionCodeForCountryCode.equals(str)) {
                        metadataForRegion = getMetadataForRegionOrCallingCode(i, regionCodeForCountryCode);
                    }
                } else {
                    sb2.append(normalize(sb));
                    if (str != null) {
                        phoneNumber.setCountryCode(metadataForRegion.getCountryCode());
                    } else if (z) {
                        phoneNumber.clearCountryCodeSource();
                    }
                }
                if (sb2.length() >= 2) {
                    if (metadataForRegion != null) {
                        StringBuilder sb3 = new StringBuilder();
                        StringBuilder sb4 = new StringBuilder(sb2);
                        maybeStripNationalPrefixAndCarrierCode(sb4, metadataForRegion, sb3);
                        ValidationResult testNumberLength = testNumberLength(sb4, metadataForRegion);
                        if (!(testNumberLength == ValidationResult.TOO_SHORT || testNumberLength == ValidationResult.IS_POSSIBLE_LOCAL_ONLY || testNumberLength == ValidationResult.INVALID_LENGTH)) {
                            if (z && sb3.length() > 0) {
                                phoneNumber.setPreferredDomesticCarrierCode(sb3.toString());
                            }
                            sb2 = sb4;
                        }
                    }
                    int length = sb2.length();
                    if (length < 2) {
                        throw new NumberParseException(NumberParseException.ErrorType.TOO_SHORT_NSN, "The string supplied is too short to be a phone number.");
                    } else if (length <= 17) {
                        setItalianLeadingZerosForPhoneNumber(sb2, phoneNumber);
                        phoneNumber.setNationalNumber(Long.parseLong(sb2.toString()));
                    } else {
                        throw new NumberParseException(NumberParseException.ErrorType.TOO_LONG, "The string supplied is too long to be a phone number.");
                    }
                } else {
                    throw new NumberParseException(NumberParseException.ErrorType.TOO_SHORT_NSN, "The string supplied is too short to be a phone number.");
                }
            } else {
                throw new NumberParseException(NumberParseException.ErrorType.INVALID_COUNTRY_CODE, "Missing or invalid default region.");
            }
        } else {
            throw new NumberParseException(NumberParseException.ErrorType.TOO_LONG, "The string supplied was too long to parse.");
        }
    }

    private void buildNationalNumberForParsing(String str, StringBuilder sb) {
        int indexOf = str.indexOf(RFC3966_PHONE_CONTEXT);
        if (indexOf >= 0) {
            int i = indexOf + 15;
            if (i < str.length() - 1 && str.charAt(i) == '+') {
                int indexOf2 = str.indexOf(59, i);
                if (indexOf2 > 0) {
                    sb.append(str.substring(i, indexOf2));
                } else {
                    sb.append(str.substring(i));
                }
            }
            int indexOf3 = str.indexOf(RFC3966_PREFIX);
            sb.append(str.substring(indexOf3 >= 0 ? indexOf3 + 4 : 0, indexOf));
        } else {
            sb.append(extractPossibleNumber(str));
        }
        int indexOf4 = sb.indexOf(RFC3966_ISDN_SUBADDRESS);
        if (indexOf4 > 0) {
            sb.delete(indexOf4, sb.length());
        }
    }

    private static Phonenumber.PhoneNumber copyCoreFieldsOnly(Phonenumber.PhoneNumber phoneNumber) {
        Phonenumber.PhoneNumber phoneNumber2 = new Phonenumber.PhoneNumber();
        phoneNumber2.setCountryCode(phoneNumber.getCountryCode());
        phoneNumber2.setNationalNumber(phoneNumber.getNationalNumber());
        if (phoneNumber.getExtension().length() > 0) {
            phoneNumber2.setExtension(phoneNumber.getExtension());
        }
        if (phoneNumber.isItalianLeadingZero()) {
            phoneNumber2.setItalianLeadingZero(true);
            phoneNumber2.setNumberOfLeadingZeros(phoneNumber.getNumberOfLeadingZeros());
        }
        return phoneNumber2;
    }

    public MatchType isNumberMatch(Phonenumber.PhoneNumber phoneNumber, Phonenumber.PhoneNumber phoneNumber2) {
        Phonenumber.PhoneNumber copyCoreFieldsOnly = copyCoreFieldsOnly(phoneNumber);
        Phonenumber.PhoneNumber copyCoreFieldsOnly2 = copyCoreFieldsOnly(phoneNumber2);
        if (copyCoreFieldsOnly.hasExtension() && copyCoreFieldsOnly2.hasExtension() && !copyCoreFieldsOnly.getExtension().equals(copyCoreFieldsOnly2.getExtension())) {
            return MatchType.NO_MATCH;
        }
        int countryCode = copyCoreFieldsOnly.getCountryCode();
        int countryCode2 = copyCoreFieldsOnly2.getCountryCode();
        if (countryCode == 0 || countryCode2 == 0) {
            copyCoreFieldsOnly.setCountryCode(countryCode2);
            if (copyCoreFieldsOnly.exactlySameAs(copyCoreFieldsOnly2)) {
                return MatchType.NSN_MATCH;
            }
            if (isNationalNumberSuffixOfTheOther(copyCoreFieldsOnly, copyCoreFieldsOnly2)) {
                return MatchType.SHORT_NSN_MATCH;
            }
            return MatchType.NO_MATCH;
        } else if (copyCoreFieldsOnly.exactlySameAs(copyCoreFieldsOnly2)) {
            return MatchType.EXACT_MATCH;
        } else {
            if (countryCode != countryCode2 || !isNationalNumberSuffixOfTheOther(copyCoreFieldsOnly, copyCoreFieldsOnly2)) {
                return MatchType.NO_MATCH;
            }
            return MatchType.SHORT_NSN_MATCH;
        }
    }

    private boolean isNationalNumberSuffixOfTheOther(Phonenumber.PhoneNumber phoneNumber, Phonenumber.PhoneNumber phoneNumber2) {
        String valueOf = String.valueOf(phoneNumber.getNationalNumber());
        String valueOf2 = String.valueOf(phoneNumber2.getNationalNumber());
        return valueOf.endsWith(valueOf2) || valueOf2.endsWith(valueOf);
    }

    public MatchType isNumberMatch(CharSequence charSequence, CharSequence charSequence2) {
        try {
            return isNumberMatch(parse(charSequence, UNKNOWN_REGION), charSequence2);
        } catch (NumberParseException e) {
            if (e.getErrorType() == NumberParseException.ErrorType.INVALID_COUNTRY_CODE) {
                try {
                    return isNumberMatch(parse(charSequence2, UNKNOWN_REGION), charSequence);
                } catch (NumberParseException e2) {
                    if (e2.getErrorType() == NumberParseException.ErrorType.INVALID_COUNTRY_CODE) {
                        try {
                            Phonenumber.PhoneNumber phoneNumber = new Phonenumber.PhoneNumber();
                            Phonenumber.PhoneNumber phoneNumber2 = new Phonenumber.PhoneNumber();
                            parseHelper(charSequence, (String) null, false, false, phoneNumber);
                            parseHelper(charSequence2, (String) null, false, false, phoneNumber2);
                            return isNumberMatch(phoneNumber, phoneNumber2);
                        } catch (NumberParseException unused) {
                            return MatchType.NOT_A_NUMBER;
                        }
                    }
                    return MatchType.NOT_A_NUMBER;
                }
            }
            return MatchType.NOT_A_NUMBER;
        }
    }

    public MatchType isNumberMatch(Phonenumber.PhoneNumber phoneNumber, CharSequence charSequence) {
        try {
            return isNumberMatch(phoneNumber, parse(charSequence, UNKNOWN_REGION));
        } catch (NumberParseException e) {
            if (e.getErrorType() == NumberParseException.ErrorType.INVALID_COUNTRY_CODE) {
                String regionCodeForCountryCode = getRegionCodeForCountryCode(phoneNumber.getCountryCode());
                try {
                    if (!regionCodeForCountryCode.equals(UNKNOWN_REGION)) {
                        MatchType isNumberMatch = isNumberMatch(phoneNumber, parse(charSequence, regionCodeForCountryCode));
                        return isNumberMatch == MatchType.EXACT_MATCH ? MatchType.NSN_MATCH : isNumberMatch;
                    }
                    Phonenumber.PhoneNumber phoneNumber2 = new Phonenumber.PhoneNumber();
                    parseHelper(charSequence, (String) null, false, false, phoneNumber2);
                    return isNumberMatch(phoneNumber, phoneNumber2);
                } catch (NumberParseException unused) {
                    return MatchType.NOT_A_NUMBER;
                }
            }
            return MatchType.NOT_A_NUMBER;
        }
    }

    public boolean canBeInternationallyDialled(Phonenumber.PhoneNumber phoneNumber) {
        Phonemetadata.PhoneMetadata metadataForRegion = getMetadataForRegion(getRegionCodeForNumber(phoneNumber));
        if (metadataForRegion == null) {
            return true;
        }
        return !isNumberMatchingDesc(getNationalSignificantNumber(phoneNumber), metadataForRegion.getNoInternationalDialling());
    }

    public boolean isMobileNumberPortableRegion(String str) {
        Phonemetadata.PhoneMetadata metadataForRegion = getMetadataForRegion(str);
        if (metadataForRegion != null) {
            return metadataForRegion.getMobileNumberPortableRegion();
        }
        Logger logger2 = logger;
        Level level = Level.WARNING;
        logger2.log(level, "Invalid or unknown region code provided: " + str);
        return false;
    }
}
