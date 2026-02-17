package com.android.internal.telephony.emergency;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.AsyncResult;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.os.ParcelFileDescriptor;
import android.os.PersistableBundle;
import android.os.SystemProperties;
import android.telephony.CarrierConfigManager;
import android.telephony.PhoneNumberUtils;
import android.telephony.emergency.EmergencyNumber;
import android.text.TextUtils;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.HalVersion;
import com.android.internal.telephony.IndentingPrintWriter;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.LocaleTracker;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.ServiceStateTracker;
import com.android.internal.telephony.SubscriptionController;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.internal.telephony.phonenumbers.ShortNumberInfo;
import com.android.phone.ecc.nano.ProtobufEccData;
import com.android.telephony.Rlog;
import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.zip.GZIPInputStream;

public class EmergencyNumberTracker extends Handler {
    public static final int ADD_EMERGENCY_NUMBER_TEST_MODE = 1;
    public static boolean DBG = false;
    private static final String EMERGENCY_NUMBER_DB_ASSETS_FILE = "eccdata";
    private static final String EMERGENCY_NUMBER_DB_OTA_FILE_NAME = "emergency_number_db";
    private static final String EMERGENCY_NUMBER_DB_OTA_FILE_PATH = "misc/emergencynumberdb/emergency_number_db";
    @VisibleForTesting
    public static final int EVENT_OVERRIDE_OTA_EMERGENCY_NUMBER_DB_FILE_PATH = 6;
    private static final int EVENT_UNSOL_EMERGENCY_NUMBER_LIST = 1;
    private static final int EVENT_UPDATE_DB_COUNTRY_ISO_CHANGED = 2;
    private static final int EVENT_UPDATE_EMERGENCY_NUMBER_PREFIX = 4;
    private static final int EVENT_UPDATE_EMERGENCY_NUMBER_TEST_MODE = 3;
    @VisibleForTesting
    public static final int EVENT_UPDATE_OTA_EMERGENCY_NUMBER_DB = 5;
    private static final int INVALID_DATABASE_VERSION = -1;
    public static final int REMOVE_EMERGENCY_NUMBER_TEST_MODE = 2;
    public static final int RESET_EMERGENCY_NUMBER_TEST_MODE = 3;
    private static final String TAG = EmergencyNumberTracker.class.getSimpleName();
    private final CommandsInterface mCi;
    private String mCountryIso;
    private int mCurrentDatabaseVersion = -1;
    private List<EmergencyNumber> mEmergencyNumberList = new ArrayList();
    private final LocalLog mEmergencyNumberListDatabaseLocalLog = new LocalLog(16);
    private List<EmergencyNumber> mEmergencyNumberListFromDatabase = new ArrayList();
    private List<EmergencyNumber> mEmergencyNumberListFromRadio = new ArrayList();
    private List<EmergencyNumber> mEmergencyNumberListFromTestMode = new ArrayList();
    private final LocalLog mEmergencyNumberListLocalLog = new LocalLog(16);
    private final LocalLog mEmergencyNumberListPrefixLocalLog = new LocalLog(16);
    private final LocalLog mEmergencyNumberListRadioLocalLog = new LocalLog(16);
    private final LocalLog mEmergencyNumberListTestModeLocalLog = new LocalLog(16);
    private List<EmergencyNumber> mEmergencyNumberListWithPrefix = new ArrayList();
    private String[] mEmergencyNumberPrefix = new String[0];
    private BroadcastReceiver mIntentReceiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            int intExtra;
            if (intent.getAction().equals("android.telephony.action.CARRIER_CONFIG_CHANGED")) {
                EmergencyNumberTracker.this.onCarrierConfigChanged();
            } else if (intent.getAction().equals("android.telephony.action.NETWORK_COUNTRY_CHANGED") && (intExtra = intent.getIntExtra("phone", -1)) == EmergencyNumberTracker.this.mPhone.getPhoneId()) {
                String stringExtra = intent.getStringExtra("android.telephony.extra.NETWORK_COUNTRY");
                EmergencyNumberTracker.logd("ACTION_NETWORK_COUNTRY_CHANGED: PhoneId: " + intExtra + " CountryIso: " + stringExtra);
                EmergencyNumberTracker emergencyNumberTracker = EmergencyNumberTracker.this;
                if (stringExtra == null) {
                    stringExtra = "";
                }
                emergencyNumberTracker.updateEmergencyCountryIsoAllPhones(stringExtra);
            }
        }
    };
    public boolean mIsCountrySetByAnotherSub = false;
    private String mLastKnownEmergencyCountryIso = "";
    private ParcelFileDescriptor mOverridedOtaDbParcelFileDescriptor = null;
    /* access modifiers changed from: private */
    public final Phone mPhone;

    public EmergencyNumberTracker(Phone phone, CommandsInterface commandsInterface) {
        this.mPhone = phone;
        this.mCi = commandsInterface;
        if (phone != null) {
            CarrierConfigManager carrierConfigManager = (CarrierConfigManager) phone.getContext().getSystemService("carrier_config");
            if (carrierConfigManager != null) {
                PersistableBundle configForSubId = carrierConfigManager.getConfigForSubId(phone.getSubId());
                if (configForSubId != null) {
                    this.mEmergencyNumberPrefix = configForSubId.getStringArray("emergency_number_prefix_string_array");
                }
            } else {
                loge("CarrierConfigManager is null.");
            }
            IntentFilter intentFilter = new IntentFilter("android.telephony.action.CARRIER_CONFIG_CHANGED");
            intentFilter.addAction("android.telephony.action.NETWORK_COUNTRY_CHANGED");
            phone.getContext().registerReceiver(this.mIntentReceiver, intentFilter);
        } else {
            loge("mPhone is null.");
        }
        initializeDatabaseEmergencyNumberList();
        commandsInterface.registerForEmergencyNumberList(this, 1, (Object) null);
    }

    public void handleMessage(Message message) {
        switch (message.what) {
            case 1:
                AsyncResult asyncResult = (AsyncResult) message.obj;
                Object obj = asyncResult.result;
                if (obj == null) {
                    loge("EVENT_UNSOL_EMERGENCY_NUMBER_LIST: Result from RIL is null.");
                    return;
                } else if (obj == null || asyncResult.exception != null) {
                    loge("EVENT_UNSOL_EMERGENCY_NUMBER_LIST: Exception from RIL : " + asyncResult.exception);
                    return;
                } else {
                    updateRadioEmergencyNumberListAndNotify((List) obj);
                    return;
                }
            case 2:
                Object obj2 = message.obj;
                if (obj2 == null) {
                    loge("EVENT_UPDATE_DB_COUNTRY_ISO_CHANGED: Result from UpdateCountryIso is null.");
                    return;
                } else {
                    updateEmergencyNumberListDatabaseAndNotify((String) obj2);
                    return;
                }
            case 3:
                Object obj3 = message.obj;
                if (obj3 != null || message.arg1 == 3) {
                    updateEmergencyNumberListTestModeAndNotify(message.arg1, (EmergencyNumber) obj3);
                    return;
                } else {
                    loge("EVENT_UPDATE_EMERGENCY_NUMBER_TEST_MODE: Result from executeEmergencyNumberTestModeCommand is null.");
                    return;
                }
            case 4:
                Object obj4 = message.obj;
                if (obj4 == null) {
                    loge("EVENT_UPDATE_EMERGENCY_NUMBER_PREFIX: Result from onCarrierConfigChanged is null.");
                    return;
                } else {
                    updateEmergencyNumberPrefixAndNotify((String[]) obj4);
                    return;
                }
            case 5:
                updateOtaEmergencyNumberListDatabaseAndNotify();
                return;
            case 6:
                Object obj5 = message.obj;
                if (obj5 == null) {
                    overrideOtaEmergencyNumberDbFilePath((ParcelFileDescriptor) null);
                    return;
                } else {
                    overrideOtaEmergencyNumberDbFilePath((ParcelFileDescriptor) obj5);
                    return;
                }
            default:
                return;
        }
    }

    private boolean isAirplaneModeEnabled() {
        ServiceStateTracker serviceStateTracker = this.mPhone.getServiceStateTracker();
        return serviceStateTracker != null && serviceStateTracker.getServiceState().getState() == 3;
    }

    @VisibleForTesting
    public boolean isSimAbsent() {
        for (Phone phone : PhoneFactory.getPhones()) {
            int slotIndex = SubscriptionController.getInstance().getSlotIndex(phone.getSubId());
            if (slotIndex != -1) {
                logd("found sim in slotId: " + slotIndex + " subid: " + phone.getSubId());
                return false;
            }
        }
        return true;
    }

    private void initializeDatabaseEmergencyNumberList() {
        if (this.mCountryIso == null) {
            String lowerCase = getInitialCountryIso().toLowerCase();
            updateEmergencyCountryIso(lowerCase);
            if (TextUtils.isEmpty(lowerCase) && isAirplaneModeEnabled()) {
                lowerCase = getCountryIsoForCachingDatabase();
            }
            cacheEmergencyDatabaseByCountry(lowerCase);
        }
    }

    @VisibleForTesting
    public void updateEmergencyCountryIsoAllPhones(String str) {
        this.mIsCountrySetByAnotherSub = false;
        updateEmergencyNumberDatabaseCountryChange(str);
        for (Phone phone : PhoneFactory.getPhones()) {
            if (!(phone.getPhoneId() == this.mPhone.getPhoneId() || phone.getEmergencyNumberTracker() == null)) {
                EmergencyNumberTracker emergencyNumberTracker = phone.getEmergencyNumberTracker();
                if (!TextUtils.isEmpty(str) && (TextUtils.isEmpty(emergencyNumberTracker.getEmergencyCountryIso()) || emergencyNumberTracker.mIsCountrySetByAnotherSub)) {
                    emergencyNumberTracker.mIsCountrySetByAnotherSub = true;
                    emergencyNumberTracker.updateEmergencyNumberDatabaseCountryChange(str);
                }
            }
        }
    }

    /* access modifiers changed from: private */
    public void onCarrierConfigChanged() {
        PersistableBundle configForSubId;
        Phone phone = this.mPhone;
        if (phone != null) {
            CarrierConfigManager carrierConfigManager = (CarrierConfigManager) phone.getContext().getSystemService("carrier_config");
            if (carrierConfigManager != null && (configForSubId = carrierConfigManager.getConfigForSubId(this.mPhone.getSubId())) != null) {
                String[] stringArray = configForSubId.getStringArray("emergency_number_prefix_string_array");
                if (!Arrays.equals(this.mEmergencyNumberPrefix, stringArray)) {
                    obtainMessage(4, stringArray).sendToTarget();
                    return;
                }
                return;
            }
            return;
        }
        loge("onCarrierConfigChanged mPhone is null.");
    }

    private String getInitialCountryIso() {
        LocaleTracker localeTracker;
        Phone phone = this.mPhone;
        if (phone != null) {
            ServiceStateTracker serviceStateTracker = phone.getServiceStateTracker();
            if (serviceStateTracker == null || (localeTracker = serviceStateTracker.getLocaleTracker()) == null) {
                return "";
            }
            return localeTracker.getCurrentCountry();
        }
        loge("getInitialCountryIso mPhone is null.");
        return "";
    }

    public void updateEmergencyNumberDatabaseCountryChange(String str) {
        obtainMessage(2, str).sendToTarget();
    }

    public void updateOtaEmergencyNumberDatabase() {
        obtainMessage(5).sendToTarget();
    }

    public void updateOtaEmergencyNumberDbFilePath(ParcelFileDescriptor parcelFileDescriptor) {
        obtainMessage(6, parcelFileDescriptor).sendToTarget();
    }

    public void resetOtaEmergencyNumberDbFilePath() {
        obtainMessage(6, (Object) null).sendToTarget();
    }

    private EmergencyNumber convertEmergencyNumberFromEccInfo(ProtobufEccData.EccInfo eccInfo, String str) {
        String trim = eccInfo.phoneNumber.trim();
        if (trim.isEmpty()) {
            loge("EccInfo has empty phone number.");
            return null;
        }
        int i = 0;
        for (int i2 : eccInfo.types) {
            switch (i2) {
                case 1:
                    i |= 1;
                    break;
                case 2:
                    i |= 2;
                    break;
                case 3:
                    i |= 4;
                    break;
                case 4:
                    i |= 8;
                    break;
                case 5:
                    i |= 16;
                    break;
                case 6:
                    i |= 32;
                    break;
                case 7:
                    i |= 64;
                    break;
            }
        }
        return new EmergencyNumber(trim, str, "", i, new ArrayList(), 16, 0);
    }

    private void cacheEmergencyDatabaseByCountry(String str) {
        GZIPInputStream gZIPInputStream;
        ArrayList arrayList = new ArrayList();
        try {
            BufferedInputStream bufferedInputStream = new BufferedInputStream(this.mPhone.getContext().getAssets().open(EMERGENCY_NUMBER_DB_ASSETS_FILE));
            try {
                gZIPInputStream = new GZIPInputStream(bufferedInputStream);
                ProtobufEccData.AllInfo parseFrom = ProtobufEccData.AllInfo.parseFrom(readInputStreamToByteArray(gZIPInputStream));
                int i = parseFrom.revision;
                logd(str + " asset emergency database is loaded. Ver: " + i + " Phone Id: " + this.mPhone.getPhoneId());
                ProtobufEccData.CountryInfo[] countryInfoArr = parseFrom.countries;
                int length = countryInfoArr.length;
                for (int i2 = 0; i2 < length; i2++) {
                    ProtobufEccData.CountryInfo countryInfo = countryInfoArr[i2];
                    if (countryInfo.isoCode.equals(str.toUpperCase())) {
                        for (ProtobufEccData.EccInfo convertEmergencyNumberFromEccInfo : countryInfo.eccs) {
                            arrayList.add(convertEmergencyNumberFromEccInfo(convertEmergencyNumberFromEccInfo, str));
                        }
                    }
                }
                EmergencyNumber.mergeSameNumbersInEmergencyNumberList(arrayList);
                gZIPInputStream.close();
                bufferedInputStream.close();
                int cacheOtaEmergencyNumberDatabase = cacheOtaEmergencyNumberDatabase();
                if (cacheOtaEmergencyNumberDatabase == -1 && i == -1) {
                    loge("No database available. Phone Id: " + this.mPhone.getPhoneId());
                    return;
                } else if (i > cacheOtaEmergencyNumberDatabase) {
                    logd("Using Asset Emergency database. Version: " + i);
                    this.mCurrentDatabaseVersion = i;
                    this.mEmergencyNumberListFromDatabase = arrayList;
                    return;
                } else {
                    logd("Using Ota Emergency database. Version: " + cacheOtaEmergencyNumberDatabase);
                    return;
                }
            } catch (Throwable th) {
                bufferedInputStream.close();
                throw th;
            }
            throw th;
        } catch (IOException e) {
            logw("Cache asset emergency database failure: " + e);
        } catch (Throwable th2) {
            th.addSuppressed(th2);
        }
    }

    private int cacheOtaEmergencyNumberDatabase() {
        File file;
        Throwable th;
        Throwable th2;
        GZIPInputStream gZIPInputStream;
        Throwable th3;
        ArrayList arrayList = new ArrayList();
        ParcelFileDescriptor parcelFileDescriptor = this.mOverridedOtaDbParcelFileDescriptor;
        if (parcelFileDescriptor == null) {
            file = new File(Environment.getDataDirectory(), EMERGENCY_NUMBER_DB_OTA_FILE_PATH);
        } else {
            try {
                file = ParcelFileDescriptor.getFile(parcelFileDescriptor.getFileDescriptor()).getAbsoluteFile();
            } catch (IOException e) {
                loge("Cache ota emergency database IOException: " + e);
                return -1;
            }
        }
        try {
            FileInputStream fileInputStream = new FileInputStream(file);
            try {
                BufferedInputStream bufferedInputStream = new BufferedInputStream(fileInputStream);
                try {
                    gZIPInputStream = new GZIPInputStream(bufferedInputStream);
                    ProtobufEccData.AllInfo parseFrom = ProtobufEccData.AllInfo.parseFrom(readInputStreamToByteArray(gZIPInputStream));
                    String lastKnownEmergencyCountryIso = getLastKnownEmergencyCountryIso();
                    logd(lastKnownEmergencyCountryIso + " ota emergency database is loaded. Ver: " + -1);
                    int i = parseFrom.revision;
                    for (ProtobufEccData.CountryInfo countryInfo : parseFrom.countries) {
                        if (countryInfo.isoCode.equals(lastKnownEmergencyCountryIso.toUpperCase())) {
                            for (ProtobufEccData.EccInfo convertEmergencyNumberFromEccInfo : countryInfo.eccs) {
                                arrayList.add(convertEmergencyNumberFromEccInfo(convertEmergencyNumberFromEccInfo, lastKnownEmergencyCountryIso));
                            }
                        }
                    }
                    EmergencyNumber.mergeSameNumbersInEmergencyNumberList(arrayList);
                    gZIPInputStream.close();
                    bufferedInputStream.close();
                    fileInputStream.close();
                    if (i != -1 && this.mCurrentDatabaseVersion < i) {
                        this.mCurrentDatabaseVersion = i;
                        this.mEmergencyNumberListFromDatabase = arrayList;
                    }
                    return i;
                } catch (Throwable th4) {
                    th2 = th4;
                    bufferedInputStream.close();
                    throw th2;
                }
                throw th3;
            } catch (Throwable th5) {
                th = th5;
                fileInputStream.close();
                throw th;
            }
        } catch (IOException e2) {
            loge("Cache ota emergency database IOException: " + e2);
            return -1;
        } catch (Throwable th6) {
            th.addSuppressed(th6);
        }
    }

    private static byte[] readInputStreamToByteArray(InputStream inputStream) throws IOException {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        byte[] bArr = new byte[16384];
        while (true) {
            int read = inputStream.read(bArr, 0, 16384);
            if (read != -1) {
                byteArrayOutputStream.write(bArr, 0, read);
            } else {
                byteArrayOutputStream.flush();
                return byteArrayOutputStream.toByteArray();
            }
        }
    }

    private void updateRadioEmergencyNumberListAndNotify(List<EmergencyNumber> list) {
        Collections.sort(list);
        logd("updateRadioEmergencyNumberListAndNotify(): receiving " + list);
        if (!list.equals(this.mEmergencyNumberListFromRadio)) {
            try {
                EmergencyNumber.mergeSameNumbersInEmergencyNumberList(list);
                writeUpdatedEmergencyNumberListMetrics(list);
                this.mEmergencyNumberListFromRadio = list;
                if (!DBG) {
                    LocalLog localLog = this.mEmergencyNumberListRadioLocalLog;
                    localLog.log("updateRadioEmergencyNumberList:" + list);
                }
                updateEmergencyNumberList();
                if (!DBG) {
                    LocalLog localLog2 = this.mEmergencyNumberListLocalLog;
                    localLog2.log("updateRadioEmergencyNumberListAndNotify:" + this.mEmergencyNumberList);
                }
                notifyEmergencyNumberList();
            } catch (NullPointerException e) {
                loge("updateRadioEmergencyNumberListAndNotify() Phone already destroyed: " + e + " EmergencyNumberList not notified");
            }
        }
    }

    private void updateEmergencyNumberListDatabaseAndNotify(String str) {
        logd("updateEmergencyNumberListDatabaseAndNotify(): receiving countryIso: " + str);
        updateEmergencyCountryIso(str.toLowerCase());
        if (TextUtils.isEmpty(str) && isAirplaneModeEnabled()) {
            str = getCountryIsoForCachingDatabase();
            logd("updateEmergencyNumberListDatabaseAndNotify(): using cached APM country " + str);
        }
        cacheEmergencyDatabaseByCountry(str);
        writeUpdatedEmergencyNumberListMetrics(this.mEmergencyNumberListFromDatabase);
        if (!DBG) {
            LocalLog localLog = this.mEmergencyNumberListDatabaseLocalLog;
            localLog.log("updateEmergencyNumberListDatabaseAndNotify:" + this.mEmergencyNumberListFromDatabase);
        }
        updateEmergencyNumberList();
        if (!DBG) {
            LocalLog localLog2 = this.mEmergencyNumberListLocalLog;
            localLog2.log("updateEmergencyNumberListDatabaseAndNotify:" + this.mEmergencyNumberList);
        }
        notifyEmergencyNumberList();
    }

    private void overrideOtaEmergencyNumberDbFilePath(ParcelFileDescriptor parcelFileDescriptor) {
        logd("overrideOtaEmergencyNumberDbFilePath:" + parcelFileDescriptor);
        this.mOverridedOtaDbParcelFileDescriptor = parcelFileDescriptor;
    }

    private void updateOtaEmergencyNumberListDatabaseAndNotify() {
        logd("updateOtaEmergencyNumberListDatabaseAndNotify(): receiving Emegency Number database OTA update");
        if (cacheOtaEmergencyNumberDatabase() != -1) {
            writeUpdatedEmergencyNumberListMetrics(this.mEmergencyNumberListFromDatabase);
            if (!DBG) {
                LocalLog localLog = this.mEmergencyNumberListDatabaseLocalLog;
                localLog.log("updateOtaEmergencyNumberListDatabaseAndNotify:" + this.mEmergencyNumberListFromDatabase);
            }
            updateEmergencyNumberList();
            if (!DBG) {
                LocalLog localLog2 = this.mEmergencyNumberListLocalLog;
                localLog2.log("updateOtaEmergencyNumberListDatabaseAndNotify:" + this.mEmergencyNumberList);
            }
            notifyEmergencyNumberList();
        }
    }

    private void updateEmergencyNumberPrefixAndNotify(String[] strArr) {
        logd("updateEmergencyNumberPrefixAndNotify(): receiving emergencyNumberPrefix: " + Arrays.toString(strArr));
        this.mEmergencyNumberPrefix = strArr;
        updateEmergencyNumberList();
        if (!DBG) {
            LocalLog localLog = this.mEmergencyNumberListLocalLog;
            localLog.log("updateEmergencyNumberPrefixAndNotify:" + this.mEmergencyNumberList);
        }
        notifyEmergencyNumberList();
    }

    private void notifyEmergencyNumberList() {
        try {
            if (getEmergencyNumberList() != null) {
                this.mPhone.notifyEmergencyNumberList();
                logd("notifyEmergencyNumberList(): notified");
            }
        } catch (NullPointerException e) {
            loge("notifyEmergencyNumberList(): failure: Phone already destroyed: " + e);
        }
    }

    private void updateEmergencyNumberList() {
        ArrayList arrayList = new ArrayList(this.mEmergencyNumberListFromDatabase);
        arrayList.addAll(this.mEmergencyNumberListFromRadio);
        this.mEmergencyNumberListWithPrefix.clear();
        if (this.mEmergencyNumberPrefix.length != 0) {
            this.mEmergencyNumberListWithPrefix.addAll(getEmergencyNumberListWithPrefix(this.mEmergencyNumberListFromRadio));
            this.mEmergencyNumberListWithPrefix.addAll(getEmergencyNumberListWithPrefix(this.mEmergencyNumberListFromDatabase));
        }
        if (!DBG) {
            LocalLog localLog = this.mEmergencyNumberListPrefixLocalLog;
            localLog.log("updateEmergencyNumberList:" + this.mEmergencyNumberListWithPrefix);
        }
        arrayList.addAll(this.mEmergencyNumberListWithPrefix);
        arrayList.addAll(this.mEmergencyNumberListFromTestMode);
        EmergencyNumber.mergeSameNumbersInEmergencyNumberList(arrayList);
        this.mEmergencyNumberList = arrayList;
    }

    public List<EmergencyNumber> getEmergencyNumberList() {
        if (!this.mEmergencyNumberListFromRadio.isEmpty()) {
            return Collections.unmodifiableList(this.mEmergencyNumberList);
        }
        return getEmergencyNumberListFromEccListDatabaseAndTest();
    }

    public boolean isEmergencyNumber(String str, boolean z) {
        if (str == null || PhoneNumberUtils.isUriNumber(str)) {
            return false;
        }
        String extractNetworkPortionAlt = PhoneNumberUtils.extractNetworkPortionAlt(str);
        if (!this.mEmergencyNumberListFromRadio.isEmpty()) {
            for (EmergencyNumber next : this.mEmergencyNumberList) {
                String lastKnownEmergencyCountryIso = getLastKnownEmergencyCountryIso();
                if (lastKnownEmergencyCountryIso.equals("br") || lastKnownEmergencyCountryIso.equals("cl") || lastKnownEmergencyCountryIso.equals("ni")) {
                    z = true;
                }
                if (z) {
                    if (next.getNumber().equals(extractNetworkPortionAlt)) {
                        if (lastKnownEmergencyCountryIso.equals("co") && next.getNumber().equals("123")) {
                            return false;
                        }
                        logd("Found in mEmergencyNumberList [exact match] ");
                        return true;
                    }
                } else if (extractNetworkPortionAlt.startsWith(next.getNumber())) {
                    if (lastKnownEmergencyCountryIso.equals("co") && next.getNumber().equals("123")) {
                        return false;
                    }
                    logd("Found in mEmergencyNumberList [not exact match] ");
                    return true;
                }
            }
            return false;
        }
        boolean isEmergencyNumberFromEccList = isEmergencyNumberFromEccList(extractNetworkPortionAlt, z);
        boolean isEmergencyNumberFromDatabase = isEmergencyNumberFromDatabase(extractNetworkPortionAlt);
        boolean isEmergencyNumberForTest = isEmergencyNumberForTest(extractNetworkPortionAlt);
        logd("Search results - inRilEccList:" + isEmergencyNumberFromEccList + " inEmergencyNumberDb:" + isEmergencyNumberFromDatabase + " inEmergencyNumberTestList: " + isEmergencyNumberForTest);
        if (isEmergencyNumberFromEccList || isEmergencyNumberFromDatabase || isEmergencyNumberForTest) {
            return true;
        }
        return false;
    }

    public EmergencyNumber getEmergencyNumber(String str) {
        String stripSeparators = PhoneNumberUtils.stripSeparators(str);
        for (EmergencyNumber next : getEmergencyNumberList()) {
            if (next.getNumber().equals(stripSeparators)) {
                return next;
            }
        }
        return null;
    }

    public int getEmergencyServiceCategories(String str) {
        String stripSeparators = PhoneNumberUtils.stripSeparators(str);
        for (EmergencyNumber next : getEmergencyNumberList()) {
            if (next.getNumber().equals(stripSeparators) && (next.isFromSources(1) || next.isFromSources(2))) {
                return next.getEmergencyServiceCategoryBitmask();
            }
        }
        return 0;
    }

    public int getEmergencyCallRouting(String str) {
        String stripSeparators = PhoneNumberUtils.stripSeparators(str);
        for (EmergencyNumber next : getEmergencyNumberList()) {
            if (next.getNumber().equals(stripSeparators) && next.isFromSources(16)) {
                return next.getEmergencyCallRouting();
            }
        }
        return 0;
    }

    public String getEmergencyCountryIso() {
        return this.mCountryIso;
    }

    public String getLastKnownEmergencyCountryIso() {
        return this.mLastKnownEmergencyCountryIso;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:2:0x0008, code lost:
        r0 = r0.getLocaleTracker();
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private java.lang.String getCountryIsoForCachingDatabase() {
        /*
            r0 = this;
            com.android.internal.telephony.Phone r0 = r0.mPhone
            com.android.internal.telephony.ServiceStateTracker r0 = r0.getServiceStateTracker()
            if (r0 == 0) goto L_0x0013
            com.android.internal.telephony.LocaleTracker r0 = r0.getLocaleTracker()
            if (r0 == 0) goto L_0x0013
            java.lang.String r0 = r0.getLastKnownCountryIso()
            return r0
        L_0x0013:
            java.lang.String r0 = ""
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.emergency.EmergencyNumberTracker.getCountryIsoForCachingDatabase():java.lang.String");
    }

    public int getEmergencyNumberDbVersion() {
        return this.mCurrentDatabaseVersion;
    }

    private synchronized void updateEmergencyCountryIso(String str) {
        this.mCountryIso = str;
        if (!TextUtils.isEmpty(str)) {
            this.mLastKnownEmergencyCountryIso = this.mCountryIso;
        }
        this.mCurrentDatabaseVersion = -1;
    }

    private List<EmergencyNumber> getEmergencyNumberListFromEccList() {
        ArrayList arrayList = new ArrayList();
        int slotIndex = SubscriptionController.getInstance().getSlotIndex(this.mPhone.getSubId());
        String str = "ril.ecclist";
        if (slotIndex > 0) {
            str = str + slotIndex;
        }
        String str2 = SystemProperties.get(str, "");
        if (TextUtils.isEmpty(str2)) {
            str2 = SystemProperties.get("ro.ril.ecclist");
        }
        if (!TextUtils.isEmpty(str2)) {
            for (String labeledEmergencyNumberForEcclist : str2.split(",")) {
                arrayList.add(getLabeledEmergencyNumberForEcclist(labeledEmergencyNumberForEcclist));
            }
        }
        for (String labeledEmergencyNumberForEcclist2 : (isSimAbsent() ? "112,911,000,08,110,118,119,999" : "112,911").split(",")) {
            arrayList.add(getLabeledEmergencyNumberForEcclist(labeledEmergencyNumberForEcclist2));
        }
        if (this.mEmergencyNumberPrefix.length != 0) {
            arrayList.addAll(getEmergencyNumberListWithPrefix(arrayList));
        }
        EmergencyNumber.mergeSameNumbersInEmergencyNumberList(arrayList);
        return arrayList;
    }

    private List<EmergencyNumber> getEmergencyNumberListWithPrefix(List<EmergencyNumber> list) {
        ArrayList arrayList = new ArrayList();
        if (list != null) {
            for (EmergencyNumber next : list) {
                for (String str : this.mEmergencyNumberPrefix) {
                    if (!next.getNumber().startsWith(str)) {
                        arrayList.add(new EmergencyNumber(str + next.getNumber(), next.getCountryIso(), next.getMnc(), next.getEmergencyServiceCategoryBitmask(), next.getEmergencyUrns(), next.getEmergencyNumberSourceBitmask(), next.getEmergencyCallRouting()));
                    }
                }
            }
        }
        return arrayList;
    }

    private boolean isEmergencyNumberForTest(String str) {
        String stripSeparators = PhoneNumberUtils.stripSeparators(str);
        for (EmergencyNumber number : this.mEmergencyNumberListFromTestMode) {
            if (number.getNumber().equals(stripSeparators)) {
                return true;
            }
        }
        return false;
    }

    private boolean isEmergencyNumberFromDatabase(String str) {
        if (!this.mPhone.getHalVersion().greaterOrEqual(new HalVersion(1, 4))) {
            return false;
        }
        String stripSeparators = PhoneNumberUtils.stripSeparators(str);
        for (EmergencyNumber number : this.mEmergencyNumberListFromDatabase) {
            if (number.getNumber().equals(stripSeparators)) {
                return true;
            }
        }
        for (EmergencyNumber number2 : getEmergencyNumberListWithPrefix(this.mEmergencyNumberListFromDatabase)) {
            if (number2.getNumber().equals(stripSeparators)) {
                return true;
            }
        }
        return false;
    }

    private EmergencyNumber getLabeledEmergencyNumberForEcclist(String str) {
        String stripSeparators = PhoneNumberUtils.stripSeparators(str);
        for (EmergencyNumber next : this.mEmergencyNumberListFromDatabase) {
            if (next.getNumber().equals(stripSeparators)) {
                return new EmergencyNumber(stripSeparators, getLastKnownEmergencyCountryIso().toLowerCase(), "", next.getEmergencyServiceCategoryBitmask(), new ArrayList(), 16, 0);
            }
        }
        return new EmergencyNumber(stripSeparators, "", "", 0, new ArrayList(), 0, 0);
    }

    private boolean isEmergencyNumberFromEccList(String str, boolean z) {
        if (str == null) {
            return false;
        }
        int slotIndex = SubscriptionController.getInstance().getSlotIndex(this.mPhone.getSubId());
        String lastKnownEmergencyCountryIso = getLastKnownEmergencyCountryIso();
        if (!this.mPhone.getHalVersion().greaterOrEqual(new HalVersion(1, 4))) {
            String str2 = "ril.ecclist";
            if (slotIndex > 0) {
                str2 = str2 + slotIndex;
            }
            String str3 = SystemProperties.get(str2, "");
            logd("slotId:" + slotIndex + " country:" + lastKnownEmergencyCountryIso + " emergencyNumbers: " + str3);
            if (TextUtils.isEmpty(str3)) {
                str3 = SystemProperties.get("ro.ril.ecclist");
            }
            if (!TextUtils.isEmpty(str3)) {
                for (String str4 : str3.split(",")) {
                    if (z || lastKnownEmergencyCountryIso.equals("br") || lastKnownEmergencyCountryIso.equals("cl") || lastKnownEmergencyCountryIso.equals("ni")) {
                        if (str.equals(str4)) {
                            return true;
                        }
                        for (String str5 : this.mEmergencyNumberPrefix) {
                            if (str.equals(str5 + str4)) {
                                return true;
                            }
                        }
                        continue;
                    } else if (str.startsWith(str4)) {
                        return true;
                    } else {
                        for (String str6 : this.mEmergencyNumberPrefix) {
                            if (str.startsWith(str6 + str4)) {
                                return true;
                            }
                        }
                        continue;
                    }
                }
                return false;
            }
        }
        logd("System property doesn't provide any emergency numbers. Use embedded logic for determining ones.");
        for (String str7 : (isSimAbsent() ? "112,911,000,08,110,118,119,999" : "112,911").split(",")) {
            if (z) {
                if (str.equals(str7)) {
                    return true;
                }
                for (String str8 : this.mEmergencyNumberPrefix) {
                    if (str.equals(str8 + str7)) {
                        return true;
                    }
                }
                continue;
            } else if (str.startsWith(str7)) {
                return true;
            } else {
                for (String str9 : this.mEmergencyNumberPrefix) {
                    if (str.equals(str9 + str7)) {
                        return true;
                    }
                }
                continue;
            }
        }
        if (isSimAbsent() && lastKnownEmergencyCountryIso != null) {
            ShortNumberInfo instance = ShortNumberInfo.getInstance();
            if (z) {
                if (instance.isEmergencyNumber(str, lastKnownEmergencyCountryIso.toUpperCase())) {
                    return true;
                }
                for (String str10 : this.mEmergencyNumberPrefix) {
                    if (instance.isEmergencyNumber(str10 + str, lastKnownEmergencyCountryIso.toUpperCase())) {
                        return true;
                    }
                }
                return false;
            } else if (instance.connectsToEmergencyNumber(str, lastKnownEmergencyCountryIso.toUpperCase())) {
                return true;
            } else {
                for (String str11 : this.mEmergencyNumberPrefix) {
                    if (instance.connectsToEmergencyNumber(str11 + str, lastKnownEmergencyCountryIso.toUpperCase())) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    public void executeEmergencyNumberTestModeCommand(int i, EmergencyNumber emergencyNumber) {
        obtainMessage(3, i, 0, emergencyNumber).sendToTarget();
    }

    private void updateEmergencyNumberListTestModeAndNotify(int i, EmergencyNumber emergencyNumber) {
        if (i == 1) {
            if (!isEmergencyNumber(emergencyNumber.getNumber(), true)) {
                this.mEmergencyNumberListFromTestMode.add(emergencyNumber);
            }
        } else if (i == 3) {
            this.mEmergencyNumberListFromTestMode.clear();
        } else if (i == 2) {
            this.mEmergencyNumberListFromTestMode.remove(emergencyNumber);
        } else {
            loge("updateEmergencyNumberListTestModeAndNotify: Unexpected action in test mode.");
            return;
        }
        if (!DBG) {
            LocalLog localLog = this.mEmergencyNumberListTestModeLocalLog;
            localLog.log("updateEmergencyNumberListTestModeAndNotify:" + this.mEmergencyNumberListFromTestMode);
        }
        updateEmergencyNumberList();
        if (!DBG) {
            LocalLog localLog2 = this.mEmergencyNumberListLocalLog;
            localLog2.log("updateEmergencyNumberListTestModeAndNotify:" + this.mEmergencyNumberList);
        }
        notifyEmergencyNumberList();
    }

    private List<EmergencyNumber> getEmergencyNumberListFromEccListDatabaseAndTest() {
        List<EmergencyNumber> emergencyNumberListFromEccList = getEmergencyNumberListFromEccList();
        if (this.mPhone.getHalVersion().greaterOrEqual(new HalVersion(1, 4))) {
            loge("getEmergencyNumberListFromEccListDatabaseAndTest: radio indication is unavailable in 1.4 HAL.");
            emergencyNumberListFromEccList.addAll(this.mEmergencyNumberListFromDatabase);
            emergencyNumberListFromEccList.addAll(getEmergencyNumberListWithPrefix(this.mEmergencyNumberListFromDatabase));
        }
        emergencyNumberListFromEccList.addAll(getEmergencyNumberListTestMode());
        EmergencyNumber.mergeSameNumbersInEmergencyNumberList(emergencyNumberListFromEccList);
        return emergencyNumberListFromEccList;
    }

    public List<EmergencyNumber> getEmergencyNumberListTestMode() {
        return Collections.unmodifiableList(this.mEmergencyNumberListFromTestMode);
    }

    @VisibleForTesting
    public List<EmergencyNumber> getRadioEmergencyNumberList() {
        return new ArrayList(this.mEmergencyNumberListFromRadio);
    }

    /* access modifiers changed from: private */
    public static void logd(String str) {
        Rlog.d(TAG, str);
    }

    private static void logw(String str) {
        Rlog.w(TAG, str);
    }

    private static void loge(String str) {
        Rlog.e(TAG, str);
    }

    private void writeUpdatedEmergencyNumberListMetrics(List<EmergencyNumber> list) {
        if (list != null) {
            for (EmergencyNumber writeEmergencyNumberUpdateEvent : list) {
                TelephonyMetrics.getInstance().writeEmergencyNumberUpdateEvent(this.mPhone.getPhoneId(), writeEmergencyNumberUpdateEvent, getEmergencyNumberDbVersion());
            }
        }
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, "  ");
        indentingPrintWriter.println(" Hal Version:" + this.mPhone.getHalVersion());
        indentingPrintWriter.println(" ========================================= ");
        indentingPrintWriter.println(" Country Iso:" + getEmergencyCountryIso());
        indentingPrintWriter.println(" ========================================= ");
        indentingPrintWriter.println(" Database Version:" + getEmergencyNumberDbVersion());
        indentingPrintWriter.println(" ========================================= ");
        indentingPrintWriter.println("mEmergencyNumberListDatabaseLocalLog:");
        indentingPrintWriter.increaseIndent();
        this.mEmergencyNumberListDatabaseLocalLog.dump(fileDescriptor, printWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println(" ========================================= ");
        indentingPrintWriter.println("mEmergencyNumberListRadioLocalLog:");
        indentingPrintWriter.increaseIndent();
        this.mEmergencyNumberListRadioLocalLog.dump(fileDescriptor, printWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println(" ========================================= ");
        indentingPrintWriter.println("mEmergencyNumberListPrefixLocalLog:");
        indentingPrintWriter.increaseIndent();
        this.mEmergencyNumberListPrefixLocalLog.dump(fileDescriptor, printWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println(" ========================================= ");
        indentingPrintWriter.println("mEmergencyNumberListTestModeLocalLog:");
        indentingPrintWriter.increaseIndent();
        this.mEmergencyNumberListTestModeLocalLog.dump(fileDescriptor, printWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println(" ========================================= ");
        indentingPrintWriter.println("mEmergencyNumberListLocalLog (valid >= 1.4 HAL):");
        indentingPrintWriter.increaseIndent();
        this.mEmergencyNumberListLocalLog.dump(fileDescriptor, printWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println(" ========================================= ");
        int slotIndex = SubscriptionController.getInstance().getSlotIndex(this.mPhone.getSubId());
        String str = "ril.ecclist";
        if (slotIndex > 0) {
            str = str + slotIndex;
        }
        indentingPrintWriter.println(" ril.ecclist: " + SystemProperties.get(str, ""));
        indentingPrintWriter.println(" ========================================= ");
        indentingPrintWriter.println("Emergency Number List for Phone(" + this.mPhone.getPhoneId() + ")");
        indentingPrintWriter.increaseIndent();
        indentingPrintWriter.println(getEmergencyNumberList());
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println(" ========================================= ");
        indentingPrintWriter.flush();
    }
}
