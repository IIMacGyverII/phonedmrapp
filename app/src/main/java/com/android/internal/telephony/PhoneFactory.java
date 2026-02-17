package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.os.Looper;
import android.preference.PreferenceManager;
import android.provider.Settings;
import android.telephony.AnomalyReporter;
import android.telephony.RadioAccessFamily;
import android.telephony.TelephonyManager;
import com.android.internal.telephony.cdma.CdmaSubscriptionSourceManager;
import com.android.internal.telephony.data.CellularNetworkValidator;
import com.android.internal.telephony.data.PhoneSwitcher;
import com.android.internal.telephony.data.TelephonyNetworkFactory;
import com.android.internal.telephony.euicc.EuiccCardController;
import com.android.internal.telephony.euicc.EuiccController;
import com.android.internal.telephony.imsphone.ImsPhoneFactory;
import com.android.internal.telephony.metrics.MetricsCollector;
import com.android.internal.telephony.uicc.UiccController;
import com.android.internal.telephony.util.NotificationChannelController;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

public class PhoneFactory {
    static final boolean DBG = false;
    static final String LOG_TAG = "PhoneFactory";
    static final int SOCKET_OPEN_MAX_RETRY = 3;
    static final int SOCKET_OPEN_RETRY_MILLIS = 2000;
    private static CellularNetworkValidator sCellularNetworkValidator = null;
    private static CommandsInterface[] sCommandsInterfaces = null;
    @UnsupportedAppUsage
    private static Context sContext = null;
    private static EuiccCardController sEuiccCardController = null;
    private static EuiccController sEuiccController = null;
    private static IntentBroadcaster sIntentBroadcaster = null;
    private static final HashMap<String, LocalLog> sLocalLogs = new HashMap<>();
    static final Object sLockProxyPhones = new Object();
    @UnsupportedAppUsage
    private static boolean sMadeDefaults = false;
    private static MetricsCollector sMetricsCollector;
    private static NotificationChannelController sNotificationChannelController;
    private static Phone sPhone;
    private static PhoneConfigurationManager sPhoneConfigurationManager;
    @UnsupportedAppUsage
    private static PhoneNotifier sPhoneNotifier;
    private static PhoneSwitcher sPhoneSwitcher;
    private static Phone[] sPhones;
    private static ProxyController sProxyController;
    private static RadioInterfaceCapabilityController sRadioHalCapabilities;
    private static SubscriptionInfoUpdater sSubInfoRecordUpdater;
    private static TelephonyNetworkFactory[] sTelephonyNetworkFactories;
    private static UiccController sUiccController;

    public static void makeDefaultPhones(Context context) {
        makeDefaultPhone(context);
    }

    /* JADX WARNING: Code restructure failed: missing block: B:16:?, code lost:
        r2 = com.android.internal.telephony.TelephonyComponentFactory.getInstance().inject(com.android.internal.telephony.TelephonyComponentFactory.class.getName());
        sMetricsCollector = new com.android.internal.telephony.metrics.MetricsCollector(r11);
        sPhoneNotifier = r2.makeDefaultPhoneNotifier(r11);
        r4 = com.android.internal.telephony.cdma.CdmaSubscriptionSourceManager.getDefault(r11);
        com.android.telephony.Rlog.i(LOG_TAG, "Cdma Subscription set to " + r4);
        r5 = android.telephony.TelephonyManager.getDefault().getActiveModemCount();
        r6 = new int[r5];
        sPhones = new com.android.internal.telephony.Phone[r5];
        sCommandsInterfaces = new com.android.internal.telephony.RIL[r5];
        sTelephonyNetworkFactories = new com.android.internal.telephony.data.TelephonyNetworkFactory[r5];
        r7 = 0;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:17:0x006f, code lost:
        if (r7 >= r5) goto L_0x00a2;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:18:0x0071, code lost:
        r6[r7] = com.android.internal.telephony.RILConstants.PREFERRED_NETWORK_MODE;
        com.android.telephony.Rlog.i(LOG_TAG, "Network Mode set to " + java.lang.Integer.toString(r6[r7]));
        sCommandsInterfaces[r7] = r2.makeRil(r11, r6[r7], r4, java.lang.Integer.valueOf(r7));
        r7 = r7 + 1;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:19:0x00a2, code lost:
        r2.initRadioManager(r11, r5, sCommandsInterfaces);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:20:0x00a7, code lost:
        if (r5 <= 0) goto L_0x00c0;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:21:0x00a9, code lost:
        sRadioHalCapabilities = com.android.internal.telephony.RadioInterfaceCapabilityController.init(com.android.internal.telephony.RadioConfig.make(r11, sCommandsInterfaces[0].getHalVersion()), sCommandsInterfaces[0]);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:22:0x00c0, code lost:
        sRadioHalCapabilities = com.android.internal.telephony.RadioInterfaceCapabilityController.init(com.android.internal.telephony.RadioConfig.make(r11, com.android.internal.telephony.HalVersion.UNKNOWN), (com.android.internal.telephony.CommandsInterface) null);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:23:0x00cd, code lost:
        sUiccController = com.android.internal.telephony.uicc.UiccController.make(r11);
        com.android.telephony.Rlog.i(LOG_TAG, "Creating SubscriptionController");
        com.android.internal.telephony.TelephonyComponentFactory.getInstance().inject(com.android.internal.telephony.SubscriptionController.class.getName()).initSubscriptionController(r11);
        com.android.internal.telephony.TelephonyComponentFactory.getInstance().inject(com.android.internal.telephony.MultiSimSettingController.class.getName()).initMultiSimSettingController(r11, com.android.internal.telephony.SubscriptionController.getInstance());
     */
    /* JADX WARNING: Code restructure failed: missing block: B:24:0x010a, code lost:
        if (r11.getPackageManager().hasSystemFeature("android.hardware.telephony.euicc") == false) goto L_0x0118;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:25:0x010c, code lost:
        sEuiccController = com.android.internal.telephony.euicc.EuiccController.init(r11);
        sEuiccCardController = com.android.internal.telephony.euicc.EuiccCardController.init(r11);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:26:0x0118, code lost:
        r4 = 0;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:27:0x0119, code lost:
        if (r4 >= r5) goto L_0x0126;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:28:0x011b, code lost:
        sPhones[r4] = createPhone(r11, r4);
        r4 = r4 + 1;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:29:0x0126, code lost:
        if (r5 <= 0) goto L_0x012e;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:30:0x0128, code lost:
        sPhone = sPhones[0];
     */
    /* JADX WARNING: Code restructure failed: missing block: B:31:0x012e, code lost:
        r4 = com.android.internal.telephony.SmsApplication.getDefaultSmsApplication(r11, true);
        r6 = "NONE";
     */
    /* JADX WARNING: Code restructure failed: missing block: B:32:0x0134, code lost:
        if (r4 == null) goto L_0x013a;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:33:0x0136, code lost:
        r6 = r4.getPackageName();
     */
    /* JADX WARNING: Code restructure failed: missing block: B:34:0x013a, code lost:
        com.android.telephony.Rlog.i(LOG_TAG, "defaultSmsApplication: " + r6);
        com.android.internal.telephony.SmsApplication.initSmsPackageMonitor(r11);
        sMadeDefaults = true;
        com.android.telephony.Rlog.i(LOG_TAG, "Creating SubInfoRecordUpdater ");
        r3 = new android.os.HandlerThread("PhoneFactoryHandlerThread");
        r3.start();
        sSubInfoRecordUpdater = com.android.internal.telephony.TelephonyComponentFactory.getInstance().inject(com.android.internal.telephony.SubscriptionInfoUpdater.class.getName()).makeSubscriptionInfoUpdater(r3.getLooper(), r11, com.android.internal.telephony.SubscriptionController.getInstance());
        r2.makeSuppServManager(sContext, sPhones);
        r2.makeSmartDataSwitchAssistant(sContext, sPhones);
        r2.initVoDataService(r11);
        r2.initGwsdService(r11);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:35:0x01a0, code lost:
        if (r11.getPackageManager().hasSystemFeature("android.hardware.telephony.ims") == false) goto L_0x01af;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:36:0x01a2, code lost:
        r3 = 0;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:37:0x01a3, code lost:
        if (r3 >= r5) goto L_0x01b6;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:38:0x01a5, code lost:
        sPhones[r3].createImsPhone();
        r3 = r3 + 1;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:39:0x01af, code lost:
        com.android.telephony.Rlog.i(LOG_TAG, "IMS is not supported on this device, skipping ImsResolver.");
     */
    /* JADX WARNING: Code restructure failed: missing block: B:40:0x01b6, code lost:
        r2.makeDataHelper(sContext, sPhones);
        sPhoneConfigurationManager = com.android.internal.telephony.PhoneConfigurationManager.init(sContext);
        sCellularNetworkValidator = com.android.internal.telephony.data.CellularNetworkValidator.make(sContext);
        sPhoneSwitcher = com.android.internal.telephony.TelephonyComponentFactory.getInstance().inject(com.android.internal.telephony.data.PhoneSwitcher.class.getName()).makePhoneSwitcher(sPhoneConfigurationManager.getNumberOfModemsWithSimultaneousDataConnections(), sContext, android.os.Looper.myLooper());
        sProxyController = com.android.internal.telephony.ProxyController.getInstance(r11);
        sIntentBroadcaster = com.android.internal.telephony.IntentBroadcaster.getInstance(r11);
        sNotificationChannelController = new com.android.internal.telephony.util.NotificationChannelController(r11);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:41:0x0200, code lost:
        if (r1 >= r5) goto L_0x0215;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:42:0x0202, code lost:
        sTelephonyNetworkFactories[r1] = r2.makeTelephonyNetworkFactories(android.os.Looper.myLooper(), sPhones[r1]);
        r1 = r1 + 1;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:43:0x0215, code lost:
        r2.makeWorldPhoneManager();
        r2.initCarrierExpress();
     */
    @android.compat.annotation.UnsupportedAppUsage
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public static void makeDefaultPhone(android.content.Context r11) {
        /*
            java.lang.Object r0 = sLockProxyPhones
            monitor-enter(r0)
            boolean r1 = sMadeDefaults     // Catch:{ all -> 0x0230 }
            if (r1 != 0) goto L_0x022e
            sContext = r11     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.TelephonyDevController.create()     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.metrics.TelephonyMetrics r1 = com.android.internal.telephony.metrics.TelephonyMetrics.getInstance()     // Catch:{ all -> 0x0230 }
            r1.setContext(r11)     // Catch:{ all -> 0x0230 }
            r1 = 0
            r2 = r1
        L_0x0015:
            r3 = 1
            int r2 = r2 + r3
            android.net.LocalServerSocket r4 = new android.net.LocalServerSocket     // Catch:{ IOException -> 0x0020 }
            java.lang.String r5 = "com.android.internal.telephony"
            r4.<init>(r5)     // Catch:{ IOException -> 0x0020 }
            r4 = r1
            goto L_0x0021
        L_0x0020:
            r4 = r3
        L_0x0021:
            if (r4 != 0) goto L_0x021c
            com.android.internal.telephony.TelephonyComponentFactory r2 = com.android.internal.telephony.TelephonyComponentFactory.getInstance()     // Catch:{ all -> 0x0230 }
            java.lang.Class<com.android.internal.telephony.TelephonyComponentFactory> r4 = com.android.internal.telephony.TelephonyComponentFactory.class
            java.lang.String r4 = r4.getName()     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.TelephonyComponentFactory r2 = r2.inject(r4)     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.metrics.MetricsCollector r4 = new com.android.internal.telephony.metrics.MetricsCollector     // Catch:{ all -> 0x0230 }
            r4.<init>(r11)     // Catch:{ all -> 0x0230 }
            sMetricsCollector = r4     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.DefaultPhoneNotifier r4 = r2.makeDefaultPhoneNotifier(r11)     // Catch:{ all -> 0x0230 }
            sPhoneNotifier = r4     // Catch:{ all -> 0x0230 }
            int r4 = com.android.internal.telephony.cdma.CdmaSubscriptionSourceManager.getDefault(r11)     // Catch:{ all -> 0x0230 }
            java.lang.String r5 = "PhoneFactory"
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x0230 }
            r6.<init>()     // Catch:{ all -> 0x0230 }
            java.lang.String r7 = "Cdma Subscription set to "
            r6.append(r7)     // Catch:{ all -> 0x0230 }
            r6.append(r4)     // Catch:{ all -> 0x0230 }
            java.lang.String r6 = r6.toString()     // Catch:{ all -> 0x0230 }
            com.android.telephony.Rlog.i(r5, r6)     // Catch:{ all -> 0x0230 }
            android.telephony.TelephonyManager r5 = android.telephony.TelephonyManager.getDefault()     // Catch:{ all -> 0x0230 }
            int r5 = r5.getActiveModemCount()     // Catch:{ all -> 0x0230 }
            int[] r6 = new int[r5]     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.Phone[] r7 = new com.android.internal.telephony.Phone[r5]     // Catch:{ all -> 0x0230 }
            sPhones = r7     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.RIL[] r7 = new com.android.internal.telephony.RIL[r5]     // Catch:{ all -> 0x0230 }
            sCommandsInterfaces = r7     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.data.TelephonyNetworkFactory[] r7 = new com.android.internal.telephony.data.TelephonyNetworkFactory[r5]     // Catch:{ all -> 0x0230 }
            sTelephonyNetworkFactories = r7     // Catch:{ all -> 0x0230 }
            r7 = r1
        L_0x006f:
            if (r7 >= r5) goto L_0x00a2
            int r8 = com.android.internal.telephony.RILConstants.PREFERRED_NETWORK_MODE     // Catch:{ all -> 0x0230 }
            r6[r7] = r8     // Catch:{ all -> 0x0230 }
            java.lang.String r8 = "PhoneFactory"
            java.lang.StringBuilder r9 = new java.lang.StringBuilder     // Catch:{ all -> 0x0230 }
            r9.<init>()     // Catch:{ all -> 0x0230 }
            java.lang.String r10 = "Network Mode set to "
            r9.append(r10)     // Catch:{ all -> 0x0230 }
            r10 = r6[r7]     // Catch:{ all -> 0x0230 }
            java.lang.String r10 = java.lang.Integer.toString(r10)     // Catch:{ all -> 0x0230 }
            r9.append(r10)     // Catch:{ all -> 0x0230 }
            java.lang.String r9 = r9.toString()     // Catch:{ all -> 0x0230 }
            com.android.telephony.Rlog.i(r8, r9)     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.CommandsInterface[] r8 = sCommandsInterfaces     // Catch:{ all -> 0x0230 }
            r9 = r6[r7]     // Catch:{ all -> 0x0230 }
            java.lang.Integer r10 = java.lang.Integer.valueOf(r7)     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.RIL r9 = r2.makeRil(r11, r9, r4, r10)     // Catch:{ all -> 0x0230 }
            r8[r7] = r9     // Catch:{ all -> 0x0230 }
            int r7 = r7 + 1
            goto L_0x006f
        L_0x00a2:
            com.android.internal.telephony.CommandsInterface[] r4 = sCommandsInterfaces     // Catch:{ all -> 0x0230 }
            r2.initRadioManager(r11, r5, r4)     // Catch:{ all -> 0x0230 }
            if (r5 <= 0) goto L_0x00c0
            com.android.internal.telephony.CommandsInterface[] r4 = sCommandsInterfaces     // Catch:{ all -> 0x0230 }
            r4 = r4[r1]     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.HalVersion r4 = r4.getHalVersion()     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.RadioConfig r4 = com.android.internal.telephony.RadioConfig.make(r11, r4)     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.CommandsInterface[] r6 = sCommandsInterfaces     // Catch:{ all -> 0x0230 }
            r6 = r6[r1]     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.RadioInterfaceCapabilityController r4 = com.android.internal.telephony.RadioInterfaceCapabilityController.init(r4, r6)     // Catch:{ all -> 0x0230 }
            sRadioHalCapabilities = r4     // Catch:{ all -> 0x0230 }
            goto L_0x00cd
        L_0x00c0:
            com.android.internal.telephony.HalVersion r4 = com.android.internal.telephony.HalVersion.UNKNOWN     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.RadioConfig r4 = com.android.internal.telephony.RadioConfig.make(r11, r4)     // Catch:{ all -> 0x0230 }
            r6 = 0
            com.android.internal.telephony.RadioInterfaceCapabilityController r4 = com.android.internal.telephony.RadioInterfaceCapabilityController.init(r4, r6)     // Catch:{ all -> 0x0230 }
            sRadioHalCapabilities = r4     // Catch:{ all -> 0x0230 }
        L_0x00cd:
            com.android.internal.telephony.uicc.UiccController r4 = com.android.internal.telephony.uicc.UiccController.make(r11)     // Catch:{ all -> 0x0230 }
            sUiccController = r4     // Catch:{ all -> 0x0230 }
            java.lang.String r4 = "PhoneFactory"
            java.lang.String r6 = "Creating SubscriptionController"
            com.android.telephony.Rlog.i(r4, r6)     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.TelephonyComponentFactory r4 = com.android.internal.telephony.TelephonyComponentFactory.getInstance()     // Catch:{ all -> 0x0230 }
            java.lang.Class<com.android.internal.telephony.SubscriptionController> r6 = com.android.internal.telephony.SubscriptionController.class
            java.lang.String r6 = r6.getName()     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.TelephonyComponentFactory r4 = r4.inject(r6)     // Catch:{ all -> 0x0230 }
            r4.initSubscriptionController(r11)     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.TelephonyComponentFactory r4 = com.android.internal.telephony.TelephonyComponentFactory.getInstance()     // Catch:{ all -> 0x0230 }
            java.lang.Class<com.android.internal.telephony.MultiSimSettingController> r6 = com.android.internal.telephony.MultiSimSettingController.class
            java.lang.String r6 = r6.getName()     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.TelephonyComponentFactory r4 = r4.inject(r6)     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.SubscriptionController r6 = com.android.internal.telephony.SubscriptionController.getInstance()     // Catch:{ all -> 0x0230 }
            r4.initMultiSimSettingController(r11, r6)     // Catch:{ all -> 0x0230 }
            android.content.pm.PackageManager r4 = r11.getPackageManager()     // Catch:{ all -> 0x0230 }
            java.lang.String r6 = "android.hardware.telephony.euicc"
            boolean r4 = r4.hasSystemFeature(r6)     // Catch:{ all -> 0x0230 }
            if (r4 == 0) goto L_0x0118
            com.android.internal.telephony.euicc.EuiccController r4 = com.android.internal.telephony.euicc.EuiccController.init(r11)     // Catch:{ all -> 0x0230 }
            sEuiccController = r4     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.euicc.EuiccCardController r4 = com.android.internal.telephony.euicc.EuiccCardController.init(r11)     // Catch:{ all -> 0x0230 }
            sEuiccCardController = r4     // Catch:{ all -> 0x0230 }
        L_0x0118:
            r4 = r1
        L_0x0119:
            if (r4 >= r5) goto L_0x0126
            com.android.internal.telephony.Phone[] r6 = sPhones     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.Phone r7 = createPhone(r11, r4)     // Catch:{ all -> 0x0230 }
            r6[r4] = r7     // Catch:{ all -> 0x0230 }
            int r4 = r4 + 1
            goto L_0x0119
        L_0x0126:
            if (r5 <= 0) goto L_0x012e
            com.android.internal.telephony.Phone[] r4 = sPhones     // Catch:{ all -> 0x0230 }
            r4 = r4[r1]     // Catch:{ all -> 0x0230 }
            sPhone = r4     // Catch:{ all -> 0x0230 }
        L_0x012e:
            android.content.ComponentName r4 = com.android.internal.telephony.SmsApplication.getDefaultSmsApplication(r11, r3)     // Catch:{ all -> 0x0230 }
            java.lang.String r6 = "NONE"
            if (r4 == 0) goto L_0x013a
            java.lang.String r6 = r4.getPackageName()     // Catch:{ all -> 0x0230 }
        L_0x013a:
            java.lang.String r4 = "PhoneFactory"
            java.lang.StringBuilder r7 = new java.lang.StringBuilder     // Catch:{ all -> 0x0230 }
            r7.<init>()     // Catch:{ all -> 0x0230 }
            java.lang.String r8 = "defaultSmsApplication: "
            r7.append(r8)     // Catch:{ all -> 0x0230 }
            r7.append(r6)     // Catch:{ all -> 0x0230 }
            java.lang.String r6 = r7.toString()     // Catch:{ all -> 0x0230 }
            com.android.telephony.Rlog.i(r4, r6)     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.SmsApplication.initSmsPackageMonitor(r11)     // Catch:{ all -> 0x0230 }
            sMadeDefaults = r3     // Catch:{ all -> 0x0230 }
            java.lang.String r3 = "PhoneFactory"
            java.lang.String r4 = "Creating SubInfoRecordUpdater "
            com.android.telephony.Rlog.i(r3, r4)     // Catch:{ all -> 0x0230 }
            android.os.HandlerThread r3 = new android.os.HandlerThread     // Catch:{ all -> 0x0230 }
            java.lang.String r4 = "PhoneFactoryHandlerThread"
            r3.<init>(r4)     // Catch:{ all -> 0x0230 }
            r3.start()     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.TelephonyComponentFactory r4 = com.android.internal.telephony.TelephonyComponentFactory.getInstance()     // Catch:{ all -> 0x0230 }
            java.lang.Class<com.android.internal.telephony.SubscriptionInfoUpdater> r6 = com.android.internal.telephony.SubscriptionInfoUpdater.class
            java.lang.String r6 = r6.getName()     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.TelephonyComponentFactory r4 = r4.inject(r6)     // Catch:{ all -> 0x0230 }
            android.os.Looper r3 = r3.getLooper()     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.SubscriptionController r6 = com.android.internal.telephony.SubscriptionController.getInstance()     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.SubscriptionInfoUpdater r3 = r4.makeSubscriptionInfoUpdater(r3, r11, r6)     // Catch:{ all -> 0x0230 }
            sSubInfoRecordUpdater = r3     // Catch:{ all -> 0x0230 }
            android.content.Context r3 = sContext     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.Phone[] r4 = sPhones     // Catch:{ all -> 0x0230 }
            r2.makeSuppServManager(r3, r4)     // Catch:{ all -> 0x0230 }
            android.content.Context r3 = sContext     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.Phone[] r4 = sPhones     // Catch:{ all -> 0x0230 }
            r2.makeSmartDataSwitchAssistant(r3, r4)     // Catch:{ all -> 0x0230 }
            r2.initVoDataService(r11)     // Catch:{ all -> 0x0230 }
            r2.initGwsdService(r11)     // Catch:{ all -> 0x0230 }
            android.content.pm.PackageManager r3 = r11.getPackageManager()     // Catch:{ all -> 0x0230 }
            java.lang.String r4 = "android.hardware.telephony.ims"
            boolean r3 = r3.hasSystemFeature(r4)     // Catch:{ all -> 0x0230 }
            if (r3 == 0) goto L_0x01af
            r3 = r1
        L_0x01a3:
            if (r3 >= r5) goto L_0x01b6
            com.android.internal.telephony.Phone[] r4 = sPhones     // Catch:{ all -> 0x0230 }
            r4 = r4[r3]     // Catch:{ all -> 0x0230 }
            r4.createImsPhone()     // Catch:{ all -> 0x0230 }
            int r3 = r3 + 1
            goto L_0x01a3
        L_0x01af:
            java.lang.String r3 = "PhoneFactory"
            java.lang.String r4 = "IMS is not supported on this device, skipping ImsResolver."
            com.android.telephony.Rlog.i(r3, r4)     // Catch:{ all -> 0x0230 }
        L_0x01b6:
            android.content.Context r3 = sContext     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.Phone[] r4 = sPhones     // Catch:{ all -> 0x0230 }
            r2.makeDataHelper(r3, r4)     // Catch:{ all -> 0x0230 }
            android.content.Context r3 = sContext     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.PhoneConfigurationManager r3 = com.android.internal.telephony.PhoneConfigurationManager.init(r3)     // Catch:{ all -> 0x0230 }
            sPhoneConfigurationManager = r3     // Catch:{ all -> 0x0230 }
            android.content.Context r3 = sContext     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.data.CellularNetworkValidator r3 = com.android.internal.telephony.data.CellularNetworkValidator.make(r3)     // Catch:{ all -> 0x0230 }
            sCellularNetworkValidator = r3     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.PhoneConfigurationManager r3 = sPhoneConfigurationManager     // Catch:{ all -> 0x0230 }
            int r3 = r3.getNumberOfModemsWithSimultaneousDataConnections()     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.TelephonyComponentFactory r4 = com.android.internal.telephony.TelephonyComponentFactory.getInstance()     // Catch:{ all -> 0x0230 }
            java.lang.Class<com.android.internal.telephony.data.PhoneSwitcher> r6 = com.android.internal.telephony.data.PhoneSwitcher.class
            java.lang.String r6 = r6.getName()     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.TelephonyComponentFactory r4 = r4.inject(r6)     // Catch:{ all -> 0x0230 }
            android.content.Context r6 = sContext     // Catch:{ all -> 0x0230 }
            android.os.Looper r7 = android.os.Looper.myLooper()     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.data.PhoneSwitcher r3 = r4.makePhoneSwitcher(r3, r6, r7)     // Catch:{ all -> 0x0230 }
            sPhoneSwitcher = r3     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.ProxyController r3 = com.android.internal.telephony.ProxyController.getInstance(r11)     // Catch:{ all -> 0x0230 }
            sProxyController = r3     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.IntentBroadcaster r3 = com.android.internal.telephony.IntentBroadcaster.getInstance(r11)     // Catch:{ all -> 0x0230 }
            sIntentBroadcaster = r3     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.util.NotificationChannelController r3 = new com.android.internal.telephony.util.NotificationChannelController     // Catch:{ all -> 0x0230 }
            r3.<init>(r11)     // Catch:{ all -> 0x0230 }
            sNotificationChannelController = r3     // Catch:{ all -> 0x0230 }
        L_0x0200:
            if (r1 >= r5) goto L_0x0215
            com.android.internal.telephony.data.TelephonyNetworkFactory[] r11 = sTelephonyNetworkFactories     // Catch:{ all -> 0x0230 }
            android.os.Looper r3 = android.os.Looper.myLooper()     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.Phone[] r4 = sPhones     // Catch:{ all -> 0x0230 }
            r4 = r4[r1]     // Catch:{ all -> 0x0230 }
            com.android.internal.telephony.data.TelephonyNetworkFactory r3 = r2.makeTelephonyNetworkFactories(r3, r4)     // Catch:{ all -> 0x0230 }
            r11[r1] = r3     // Catch:{ all -> 0x0230 }
            int r1 = r1 + 1
            goto L_0x0200
        L_0x0215:
            r2.makeWorldPhoneManager()     // Catch:{ all -> 0x0230 }
            r2.initCarrierExpress()     // Catch:{ all -> 0x0230 }
            goto L_0x022e
        L_0x021c:
            r3 = 3
            if (r2 > r3) goto L_0x0226
            r3 = 2000(0x7d0, double:9.88E-321)
            java.lang.Thread.sleep(r3)     // Catch:{ InterruptedException -> 0x0015 }
            goto L_0x0015
        L_0x0226:
            java.lang.RuntimeException r11 = new java.lang.RuntimeException     // Catch:{ all -> 0x0230 }
            java.lang.String r1 = "PhoneFactory probably already running"
            r11.<init>(r1)     // Catch:{ all -> 0x0230 }
            throw r11     // Catch:{ all -> 0x0230 }
        L_0x022e:
            monitor-exit(r0)     // Catch:{ all -> 0x0230 }
            return
        L_0x0230:
            r11 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0230 }
            throw r11
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.PhoneFactory.makeDefaultPhone(android.content.Context):void");
    }

    public static void onMultiSimConfigChanged(Context context, int i) {
        synchronized (sLockProxyPhones) {
            Phone[] phoneArr = sPhones;
            int length = phoneArr.length;
            if (length != i) {
                if (length <= i) {
                    sPhones = (Phone[]) Arrays.copyOf(phoneArr, i);
                    sCommandsInterfaces = (CommandsInterface[]) Arrays.copyOf(sCommandsInterfaces, i);
                    sTelephonyNetworkFactories = (TelephonyNetworkFactory[]) Arrays.copyOf(sTelephonyNetworkFactories, i);
                    int i2 = CdmaSubscriptionSourceManager.getDefault(context);
                    TelephonyComponentFactory inject = TelephonyComponentFactory.getInstance().inject(TelephonyComponentFactory.class.getName());
                    while (length < i) {
                        sCommandsInterfaces[length] = inject.makeRil(context, RILConstants.PREFERRED_NETWORK_MODE, i2, Integer.valueOf(length));
                        sPhones[length] = createPhone(context, length);
                        if (context.getPackageManager().hasSystemFeature("android.hardware.telephony.ims")) {
                            sPhones[length].createImsPhone();
                        }
                        sTelephonyNetworkFactories[length] = inject.makeTelephonyNetworkFactories(Looper.myLooper(), sPhones[length]);
                        length++;
                    }
                    inject.makeSmartDataSwitchAssistant(sContext, sPhones);
                    inject.makeDataHelper(sContext, sPhones);
                }
            }
        }
    }

    private static Phone createPhone(Context context, int i) {
        int phoneType = TelephonyManager.getPhoneType(RILConstants.PREFERRED_NETWORK_MODE);
        Rlog.i(LOG_TAG, "Creating Phone with type = " + phoneType + " phoneId = " + i);
        if (phoneType == 2) {
            phoneType = 6;
        }
        return TelephonyComponentFactory.getInstance().inject(GsmCdmaPhone.class.getName()).makePhone(context, sCommandsInterfaces[i], sPhoneNotifier, i, phoneType, TelephonyComponentFactory.getInstance());
    }

    @UnsupportedAppUsage
    public static Phone getDefaultPhone() {
        Phone phone;
        synchronized (sLockProxyPhones) {
            if (sMadeDefaults) {
                phone = sPhone;
            } else {
                throw new IllegalStateException("Default phones haven't been made yet!");
            }
        }
        return phone;
    }

    @UnsupportedAppUsage
    public static Phone getPhone(int i) {
        Phone phone;
        synchronized (sLockProxyPhones) {
            if (!sMadeDefaults) {
                throw new IllegalStateException("Default phones haven't been made yet!");
            } else if (i == Integer.MAX_VALUE) {
                phone = sPhone;
            } else {
                if (i >= 0) {
                    Phone[] phoneArr = sPhones;
                    if (i < phoneArr.length) {
                        phone = phoneArr[i];
                    }
                }
                phone = null;
            }
        }
        return phone;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public static Phone[] getPhones() {
        Phone[] phoneArr;
        synchronized (sLockProxyPhones) {
            if (sMadeDefaults) {
                phoneArr = sPhones;
            } else {
                throw new IllegalStateException("Default phones haven't been made yet!");
            }
        }
        return phoneArr;
    }

    public static SubscriptionInfoUpdater getSubscriptionInfoUpdater() {
        return sSubInfoRecordUpdater;
    }

    public static TelephonyNetworkFactory getNetworkFactory(int i) {
        TelephonyNetworkFactory telephonyNetworkFactory;
        synchronized (sLockProxyPhones) {
            if (sMadeDefaults) {
                if (i == Integer.MAX_VALUE) {
                    i = sPhone.getSubId();
                }
                TelephonyNetworkFactory[] telephonyNetworkFactoryArr = sTelephonyNetworkFactories;
                telephonyNetworkFactory = (telephonyNetworkFactoryArr == null || i < 0 || i >= telephonyNetworkFactoryArr.length) ? null : telephonyNetworkFactoryArr[i];
            } else {
                throw new IllegalStateException("Default phones haven't been made yet!");
            }
        }
        return telephonyNetworkFactory;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public static int calculatePreferredNetworkType(int i) {
        if (getPhone(i) == null) {
            Rlog.d(LOG_TAG, "Invalid phoneId return default network mode ");
            return RadioAccessFamily.getRafFromNetworkType(RILConstants.PREFERRED_NETWORK_MODE);
        }
        int allowedNetworkTypes = (int) getPhone(i).getAllowedNetworkTypes(0);
        Rlog.d(LOG_TAG, "calculatePreferredNetworkType: phoneId = " + i + " networkType = " + allowedNetworkTypes);
        return allowedNetworkTypes;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public static int getDefaultSubscription() {
        return SubscriptionController.getInstance().getDefaultSubId();
    }

    public static boolean isSMSPromptEnabled() {
        int i;
        boolean z = false;
        try {
            i = Settings.Global.getInt(sContext.getContentResolver(), "multi_sim_sms_prompt");
        } catch (Settings.SettingNotFoundException unused) {
            Rlog.e(LOG_TAG, "Settings Exception Reading Dual Sim SMS Prompt Values");
            i = 0;
        }
        if (i != 0) {
            z = true;
        }
        Rlog.d(LOG_TAG, "SMS Prompt option:" + z);
        return z;
    }

    public static Phone makeImsPhone(PhoneNotifier phoneNotifier, Phone phone) {
        return ImsPhoneFactory.makePhone(sContext, phoneNotifier, phone);
    }

    public static void requestEmbeddedSubscriptionInfoListRefresh(int i, Runnable runnable) {
        sSubInfoRecordUpdater.requestEmbeddedSubscriptionInfoListRefresh(i, runnable);
    }

    public static SmsController getSmsController() {
        SmsController smsController;
        synchronized (sLockProxyPhones) {
            if (sMadeDefaults) {
                smsController = sProxyController.getSmsController();
            } else {
                throw new IllegalStateException("Default phones haven't been made yet!");
            }
        }
        return smsController;
    }

    public static CommandsInterface[] getCommandsInterfaces() {
        CommandsInterface[] commandsInterfaceArr;
        synchronized (sLockProxyPhones) {
            commandsInterfaceArr = sCommandsInterfaces;
        }
        return commandsInterfaceArr;
    }

    public static void addLocalLog(String str, int i) {
        HashMap<String, LocalLog> hashMap = sLocalLogs;
        synchronized (hashMap) {
            if (!hashMap.containsKey(str)) {
                hashMap.put(str, new LocalLog(i));
            } else {
                throw new IllegalArgumentException("key " + str + " already present");
            }
        }
    }

    public static void localLog(String str, String str2) {
        HashMap<String, LocalLog> hashMap = sLocalLogs;
        synchronized (hashMap) {
            if (hashMap.containsKey(str)) {
                hashMap.get(str).log(str2);
            } else {
                throw new IllegalArgumentException("key " + str + " not found");
            }
        }
    }

    public static MetricsCollector getMetricsCollector() {
        return sMetricsCollector;
    }

    public static void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, "  ");
        indentingPrintWriter.println("PhoneFactory:");
        indentingPrintWriter.println(" sMadeDefaults=" + sMadeDefaults);
        sPhoneSwitcher.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.println();
        Phone[] phones = getPhones();
        for (int i = 0; i < phones.length; i++) {
            indentingPrintWriter.increaseIndent();
            try {
                phones[i].dump(fileDescriptor, indentingPrintWriter, strArr);
                indentingPrintWriter.flush();
                indentingPrintWriter.println("++++++++++++++++++++++++++++++++");
                sTelephonyNetworkFactories[i].dump(fileDescriptor, indentingPrintWriter, strArr);
                indentingPrintWriter.flush();
                indentingPrintWriter.decreaseIndent();
                indentingPrintWriter.println("++++++++++++++++++++++++++++++++");
            } catch (Exception e) {
                indentingPrintWriter.println("Telephony DebugService: Could not get Phone[" + i + "] e=" + e);
            }
        }
        indentingPrintWriter.println("UiccController:");
        indentingPrintWriter.increaseIndent();
        try {
            sUiccController.dump(fileDescriptor, indentingPrintWriter, strArr);
        } catch (Exception e2) {
            e2.printStackTrace();
        }
        indentingPrintWriter.flush();
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println("++++++++++++++++++++++++++++++++");
        indentingPrintWriter.println("SubscriptionController:");
        indentingPrintWriter.increaseIndent();
        try {
            SubscriptionController.getInstance().dump(fileDescriptor, indentingPrintWriter, strArr);
        } catch (Exception e3) {
            e3.printStackTrace();
        }
        indentingPrintWriter.flush();
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println("++++++++++++++++++++++++++++++++");
        indentingPrintWriter.println("SubInfoRecordUpdater:");
        indentingPrintWriter.increaseIndent();
        try {
            sSubInfoRecordUpdater.dump(fileDescriptor, indentingPrintWriter, strArr);
        } catch (Exception e4) {
            e4.printStackTrace();
        }
        indentingPrintWriter.flush();
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println("++++++++++++++++++++++++++++++++");
        indentingPrintWriter.println("LocalLogs:");
        indentingPrintWriter.increaseIndent();
        HashMap<String, LocalLog> hashMap = sLocalLogs;
        synchronized (hashMap) {
            for (String next : hashMap.keySet()) {
                indentingPrintWriter.println(next);
                indentingPrintWriter.increaseIndent();
                sLocalLogs.get(next).dump(fileDescriptor, indentingPrintWriter, strArr);
                indentingPrintWriter.decreaseIndent();
            }
            indentingPrintWriter.flush();
        }
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println("++++++++++++++++++++++++++++++++");
        indentingPrintWriter.println("SharedPreferences:");
        indentingPrintWriter.increaseIndent();
        try {
            Context context = sContext;
            if (context != null) {
                Map<String, ?> all = PreferenceManager.getDefaultSharedPreferences(context).getAll();
                for (String next2 : all.keySet()) {
                    indentingPrintWriter.println(next2 + " : " + all.get(next2));
                }
            }
        } catch (Exception e5) {
            e5.printStackTrace();
        }
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println("++++++++++++++++++++++++++++++++");
        indentingPrintWriter.println("DebugEvents:");
        indentingPrintWriter.increaseIndent();
        try {
            AnomalyReporter.dump(fileDescriptor, indentingPrintWriter, strArr);
        } catch (Exception e6) {
            e6.printStackTrace();
        }
        indentingPrintWriter.flush();
        indentingPrintWriter.decreaseIndent();
    }
}
