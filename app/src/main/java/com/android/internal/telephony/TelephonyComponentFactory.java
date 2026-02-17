package com.android.internal.telephony;

import android.content.Context;
import android.content.res.XmlResourceParser;
import android.database.Cursor;
import android.os.Handler;
import android.os.Looper;
import android.system.ErrnoException;
import android.system.Os;
import android.system.OsConstants;
import android.system.StructStatVfs;
import android.telephony.data.DataProfile;
import android.text.TextUtils;
import android.util.SparseArray;
import com.android.internal.telephony.cat.CatService;
import com.android.internal.telephony.cat.CommandParamsFactory;
import com.android.internal.telephony.cat.IconLoader;
import com.android.internal.telephony.cat.RilMessageDecoder;
import com.android.internal.telephony.cdma.CdmaInboundSmsHandler;
import com.android.internal.telephony.cdma.CdmaSMSDispatcher;
import com.android.internal.telephony.cdma.CdmaSubscriptionSourceManager;
import com.android.internal.telephony.cdma.EriManager;
import com.android.internal.telephony.data.AccessNetworksManager;
import com.android.internal.telephony.data.DataConfigManager;
import com.android.internal.telephony.data.DataEvaluation;
import com.android.internal.telephony.data.DataNetwork;
import com.android.internal.telephony.data.DataNetworkController;
import com.android.internal.telephony.data.DataProfileManager;
import com.android.internal.telephony.data.DataServiceManager;
import com.android.internal.telephony.data.DataSettingsManager;
import com.android.internal.telephony.data.LinkBandwidthEstimator;
import com.android.internal.telephony.data.PhoneSwitcher;
import com.android.internal.telephony.data.TelephonyNetworkFactory;
import com.android.internal.telephony.dataconnection.DataEnabledSettings;
import com.android.internal.telephony.dataconnection.DcTracker;
import com.android.internal.telephony.dataconnection.TransportManager;
import com.android.internal.telephony.emergency.EmergencyNumberTracker;
import com.android.internal.telephony.gsm.GsmInboundSmsHandler;
import com.android.internal.telephony.gsm.GsmSMSDispatcher;
import com.android.internal.telephony.imsphone.ImsExternalCallTracker;
import com.android.internal.telephony.imsphone.ImsPhone;
import com.android.internal.telephony.imsphone.ImsPhoneCallTracker;
import com.android.internal.telephony.nitz.NitzStateMachineImpl;
import com.android.internal.telephony.uicc.IccCardStatus;
import com.android.internal.telephony.uicc.IccFileHandler;
import com.android.internal.telephony.uicc.IccRecords;
import com.android.internal.telephony.uicc.UiccCard;
import com.android.internal.telephony.uicc.UiccCardApplication;
import com.android.internal.telephony.uicc.UiccController;
import com.android.internal.telephony.uicc.UiccProfile;
import com.android.internal.telephony.uicc.UiccSlot;
import com.android.telephony.Rlog;
import dalvik.system.PathClassLoader;
import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.function.Consumer;
import java.util.stream.Collectors;
import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;

public class TelephonyComponentFactory {
    public static final String LOG_TAG = "TelephonyComponentFactory";
    /* access modifiers changed from: private */
    public static final String TAG = "TelephonyComponentFactory";
    private static final boolean USE_NEW_NITZ_STATE_MACHINE = true;
    private static TelephonyComponentFactory sInstance;
    private InjectedComponents mInjectedComponents;
    private final TelephonyFacade mTelephonyFacade = new TelephonyFacade();

    public void initCarrierExpress() {
    }

    public void initGwsdService(Context context) {
    }

    public void initRadioManager(Context context, int i, CommandsInterface[] commandsInterfaceArr) {
    }

    public void initVoDataService(Context context) {
    }

    public void makeDataHelper(Context context, Phone[] phoneArr) {
    }

    public void makeSmartDataSwitchAssistant(Context context, Phone[] phoneArr) {
    }

    public void makeSuppServManager(Context context, Phone[] phoneArr) {
    }

    public void makeWorldPhoneManager() {
    }

    private static class InjectedComponents {
        private static final String ATTRIBUTE_JAR = "jar";
        private static final String ATTRIBUTE_PACKAGE = "package";
        private static final String PRODUCT = "/product/";
        private static final String SYSTEM = "/system/";
        private static final String SYSTEM_EXT = "/system_ext/";
        private static final String TAG_COMPONENT = "component";
        private static final String TAG_COMPONENTS = "components";
        private static final String TAG_INJECTION = "injection";
        /* access modifiers changed from: private */
        public final Set<String> mComponentNames;
        /* access modifiers changed from: private */
        public TelephonyComponentFactory mInjectedInstance;
        private String mJarPath;
        private String mPackageName;

        private InjectedComponents() {
            this.mComponentNames = new HashSet();
        }

        /* access modifiers changed from: private */
        public String getValidatedPaths() {
            String r0 = TelephonyComponentFactory.TAG;
            Rlog.w(r0, "getValidatedPaths: " + this.mPackageName + " ," + this.mJarPath);
            if (TextUtils.isEmpty(this.mPackageName) || TextUtils.isEmpty(this.mJarPath)) {
                return null;
            }
            String str = this.mJarPath;
            String str2 = File.pathSeparator;
            return (String) Arrays.stream(str.split(str2)).filter(new TelephonyComponentFactory$InjectedComponents$$ExternalSyntheticLambda0()).filter(new TelephonyComponentFactory$InjectedComponents$$ExternalSyntheticLambda1()).distinct().collect(Collectors.joining(str2));
        }

        /* access modifiers changed from: private */
        public static /* synthetic */ boolean lambda$getValidatedPaths$0(String str) {
            return str.startsWith(SYSTEM) || str.startsWith(PRODUCT) || str.startsWith(SYSTEM_EXT);
        }

        /* access modifiers changed from: private */
        public static /* synthetic */ boolean lambda$getValidatedPaths$1(String str) {
            try {
                StructStatVfs statvfs = Os.statvfs(str);
                String r2 = TelephonyComponentFactory.TAG;
                Rlog.w(r2, "StructStatVfs: " + statvfs.f_flag + " ," + OsConstants.ST_RDONLY);
                if ((statvfs.f_flag & ((long) OsConstants.ST_RDONLY)) != 0) {
                    return true;
                }
                return false;
            } catch (ErrnoException e) {
                String r22 = TelephonyComponentFactory.TAG;
                Rlog.w(r22, "Injection jar is not protected , path: " + str + e.getMessage());
                return false;
            }
        }

        /* access modifiers changed from: private */
        public void makeInjectedInstance() {
            String validatedPaths = getValidatedPaths();
            String r1 = TelephonyComponentFactory.TAG;
            Rlog.d(r1, "validated paths: " + validatedPaths);
            if (!TextUtils.isEmpty(validatedPaths)) {
                try {
                    this.mInjectedInstance = (TelephonyComponentFactory) new PathClassLoader(validatedPaths, ClassLoader.getSystemClassLoader()).loadClass(this.mPackageName).newInstance();
                } catch (ClassNotFoundException e) {
                    String r0 = TelephonyComponentFactory.TAG;
                    Rlog.e(r0, "failed: " + e.getMessage());
                } catch (IllegalAccessException | InstantiationException e2) {
                    String r02 = TelephonyComponentFactory.TAG;
                    Rlog.e(r02, "injection failed: " + e2.getMessage());
                }
            }
        }

        /* access modifiers changed from: private */
        public boolean isComponentInjected(String str) {
            if (this.mInjectedInstance == null) {
                return false;
            }
            return this.mComponentNames.contains(str);
        }

        /* access modifiers changed from: private */
        public void parseXml(XmlPullParser xmlPullParser) {
            parseXmlByTag(xmlPullParser, false, new TelephonyComponentFactory$InjectedComponents$$ExternalSyntheticLambda3(this), TAG_INJECTION);
        }

        /* access modifiers changed from: private */
        public /* synthetic */ void lambda$parseXml$2(XmlPullParser xmlPullParser) {
            setAttributes(xmlPullParser);
            parseInjection(xmlPullParser);
        }

        private void parseInjection(XmlPullParser xmlPullParser) {
            parseXmlByTag(xmlPullParser, false, new TelephonyComponentFactory$InjectedComponents$$ExternalSyntheticLambda4(this), TAG_COMPONENTS);
        }

        /* access modifiers changed from: private */
        /* renamed from: parseComponents */
        public void lambda$parseInjection$3(XmlPullParser xmlPullParser) {
            parseXmlByTag(xmlPullParser, true, new TelephonyComponentFactory$InjectedComponents$$ExternalSyntheticLambda2(this), TAG_COMPONENT);
        }

        /* access modifiers changed from: private */
        /* renamed from: parseComponent */
        public void lambda$parseComponents$4(XmlPullParser xmlPullParser) {
            try {
                int depth = xmlPullParser.getDepth();
                while (true) {
                    int next = xmlPullParser.next();
                    if (next == 1) {
                        return;
                    }
                    if (next == 3 && xmlPullParser.getDepth() <= depth) {
                        return;
                    }
                    if (next == 4) {
                        this.mComponentNames.add(xmlPullParser.getText());
                    }
                }
            } catch (IOException | XmlPullParserException e) {
                Rlog.e(TelephonyComponentFactory.TAG, "Failed to parse the component.", e);
            }
        }

        private void parseXmlByTag(XmlPullParser xmlPullParser, boolean z, Consumer<XmlPullParser> consumer, String str) {
            try {
                int depth = xmlPullParser.getDepth();
                while (true) {
                    int next = xmlPullParser.next();
                    if (next == 1) {
                        return;
                    }
                    if (next == 3 && xmlPullParser.getDepth() <= depth) {
                        return;
                    }
                    if (next == 2 && str.equals(xmlPullParser.getName())) {
                        consumer.accept(xmlPullParser);
                        if (!z) {
                            return;
                        }
                    }
                }
            } catch (IOException | XmlPullParserException e) {
                String r3 = TelephonyComponentFactory.TAG;
                Rlog.e(r3, "Failed to parse or find tag: " + str, e);
            }
        }

        private void setAttributes(XmlPullParser xmlPullParser) {
            for (int i = 0; i < xmlPullParser.getAttributeCount(); i++) {
                String attributeName = xmlPullParser.getAttributeName(i);
                String attributeValue = xmlPullParser.getAttributeValue(i);
                if (ATTRIBUTE_PACKAGE.equals(attributeName)) {
                    this.mPackageName = attributeValue;
                } else if (ATTRIBUTE_JAR.equals(attributeName)) {
                    this.mJarPath = attributeValue;
                }
            }
        }
    }

    public static TelephonyComponentFactory getInstance() {
        if (sInstance == null) {
            sInstance = new TelephonyComponentFactory();
        }
        return sInstance;
    }

    public void injectTheComponentFactory(XmlResourceParser xmlResourceParser) {
        if (this.mInjectedComponents != null) {
            Rlog.d(TAG, "Already injected.");
        } else if (xmlResourceParser != null) {
            InjectedComponents injectedComponents = new InjectedComponents();
            this.mInjectedComponents = injectedComponents;
            injectedComponents.parseXml(xmlResourceParser);
            this.mInjectedComponents.makeInjectedInstance();
            boolean z = !TextUtils.isEmpty(this.mInjectedComponents.getValidatedPaths());
            String str = TAG;
            StringBuilder sb = new StringBuilder();
            sb.append("Total components injected: ");
            sb.append(z ? this.mInjectedComponents.mComponentNames.size() : 0);
            Rlog.d(str, sb.toString());
        }
    }

    public TelephonyComponentFactory inject(String str) {
        InjectedComponents injectedComponents = this.mInjectedComponents;
        if (injectedComponents == null || !injectedComponents.isComponentInjected(str)) {
            return sInstance;
        }
        return this.mInjectedComponents.mInjectedInstance;
    }

    public GsmCdmaCallTracker makeGsmCdmaCallTracker(GsmCdmaPhone gsmCdmaPhone) {
        return new GsmCdmaCallTracker(gsmCdmaPhone);
    }

    public CallManager makeCallManager() {
        return new CallManager();
    }

    public SmsStorageMonitor makeSmsStorageMonitor(Phone phone) {
        return new SmsStorageMonitor(phone);
    }

    public SmsUsageMonitor makeSmsUsageMonitor(Context context) {
        return new SmsUsageMonitor(context);
    }

    public ServiceStateTracker makeServiceStateTracker(GsmCdmaPhone gsmCdmaPhone, CommandsInterface commandsInterface) {
        return new ServiceStateTracker(gsmCdmaPhone, commandsInterface);
    }

    public EmergencyNumberTracker makeEmergencyNumberTracker(Phone phone, CommandsInterface commandsInterface) {
        return new EmergencyNumberTracker(phone, commandsInterface);
    }

    public NitzStateMachine makeNitzStateMachine(GsmCdmaPhone gsmCdmaPhone) {
        return NitzStateMachineImpl.createInstance(gsmCdmaPhone);
    }

    public SimActivationTracker makeSimActivationTracker(Phone phone) {
        return new SimActivationTracker(phone);
    }

    public DcTracker makeDcTracker(Phone phone, int i) {
        return new DcTracker(phone, i);
    }

    public CarrierSignalAgent makeCarrierSignalAgent(Phone phone) {
        return new CarrierSignalAgent(phone);
    }

    public CarrierActionAgent makeCarrierActionAgent(Phone phone) {
        return new CarrierActionAgent(phone);
    }

    public CarrierResolver makeCarrierResolver(Phone phone) {
        return new CarrierResolver(phone);
    }

    public IccPhoneBookInterfaceManager makeIccPhoneBookInterfaceManager(Phone phone) {
        return new IccPhoneBookInterfaceManager(phone);
    }

    public IccSmsInterfaceManager makeIccSmsInterfaceManager(Phone phone) {
        return new IccSmsInterfaceManager(phone);
    }

    public UiccProfile makeUiccProfile(Context context, CommandsInterface commandsInterface, IccCardStatus iccCardStatus, int i, UiccCard uiccCard, Object obj) {
        return new UiccProfile(context, commandsInterface, iccCardStatus, i, uiccCard, obj);
    }

    public EriManager makeEriManager(Phone phone, int i) {
        return new EriManager(phone, i);
    }

    public WspTypeDecoder makeWspTypeDecoder(byte[] bArr) {
        return new WspTypeDecoder(bArr);
    }

    public InboundSmsTracker makeInboundSmsTracker(Context context, byte[] bArr, long j, int i, boolean z, boolean z2, String str, String str2, String str3, boolean z3, int i2, int i3) {
        return new InboundSmsTracker(context, bArr, j, i, z, z2, str, str2, str3, z3, i2, i3);
    }

    public InboundSmsTracker makeInboundSmsTracker(Context context, byte[] bArr, long j, int i, boolean z, String str, String str2, int i2, int i3, int i4, boolean z2, String str3, boolean z3, int i5, int i6) {
        return new InboundSmsTracker(context, bArr, j, i, z, str, str2, i2, i3, i4, z2, str3, z3, i5, i6);
    }

    public InboundSmsTracker makeInboundSmsTracker(Context context, Cursor cursor, boolean z) {
        return new InboundSmsTracker(context, cursor, z);
    }

    public SmsHeader makeSmsHeader() {
        return new SmsHeader();
    }

    public ImsSmsDispatcher makeImsSmsDispatcher(Phone phone, SmsDispatchersController smsDispatchersController) {
        return new ImsSmsDispatcher(phone, smsDispatchersController, new TelephonyComponentFactory$$ExternalSyntheticLambda1());
    }

    public CdmaSMSDispatcher makeCdmaSMSDispatcher(Phone phone, SmsDispatchersController smsDispatchersController) {
        return new CdmaSMSDispatcher(phone, smsDispatchersController);
    }

    public GsmSMSDispatcher makeGsmSMSDispatcher(Phone phone, SmsDispatchersController smsDispatchersController, GsmInboundSmsHandler gsmInboundSmsHandler) {
        return new GsmSMSDispatcher(phone, smsDispatchersController, gsmInboundSmsHandler);
    }

    public void makeSmsBroadcastUndelivered(Context context, GsmInboundSmsHandler gsmInboundSmsHandler, CdmaInboundSmsHandler cdmaInboundSmsHandler) {
        SmsBroadcastUndelivered.initialize(context, gsmInboundSmsHandler, cdmaInboundSmsHandler);
    }

    public WapPushOverSms makeWapPushOverSms(Context context) {
        return new WapPushOverSms(context);
    }

    public GsmInboundSmsHandler makeGsmInboundSmsHandler(Context context, SmsStorageMonitor smsStorageMonitor, Phone phone) {
        return GsmInboundSmsHandler.makeInboundSmsHandler(context, smsStorageMonitor, phone);
    }

    public CdmaInboundSmsHandler makeCdmaInboundSmsHandler(Context context, SmsStorageMonitor smsStorageMonitor, Phone phone, CdmaSMSDispatcher cdmaSMSDispatcher) {
        return new CdmaInboundSmsHandler(context, smsStorageMonitor, phone, cdmaSMSDispatcher);
    }

    public SmsDispatchersController makeSmsDispatchersController(Phone phone, SmsStorageMonitor smsStorageMonitor, SmsUsageMonitor smsUsageMonitor) {
        return new SmsDispatchersController(phone, phone.mSmsStorageMonitor, phone.mSmsUsageMonitor);
    }

    public ImsPhoneCallTracker makeImsPhoneCallTracker(ImsPhone imsPhone) {
        return new ImsPhoneCallTracker(imsPhone, new TelephonyComponentFactory$$ExternalSyntheticLambda0());
    }

    public ImsExternalCallTracker makeImsExternalCallTracker(ImsPhone imsPhone) {
        return new ImsExternalCallTracker(imsPhone, imsPhone.getContext().getMainExecutor());
    }

    public AppSmsManager makeAppSmsManager(Context context) {
        return new AppSmsManager(context);
    }

    public DeviceStateMonitor makeDeviceStateMonitor(Phone phone) {
        return new DeviceStateMonitor(phone);
    }

    public TransportManager makeTransportManager(Phone phone) {
        return new TransportManager(phone);
    }

    public AccessNetworksManager makeAccessNetworksManager(Phone phone, Looper looper) {
        return new AccessNetworksManager(phone, looper);
    }

    public CdmaSubscriptionSourceManager getCdmaSubscriptionSourceManagerInstance(Context context, CommandsInterface commandsInterface, Handler handler, int i, Object obj) {
        return CdmaSubscriptionSourceManager.getInstance(context, commandsInterface, handler, i, obj);
    }

    public LocaleTracker makeLocaleTracker(Phone phone, NitzStateMachine nitzStateMachine, Looper looper) {
        return new LocaleTracker(phone, nitzStateMachine, looper);
    }

    public DataEnabledSettings makeDataEnabledSettings(Phone phone) {
        return new DataEnabledSettings(phone);
    }

    public Phone makePhone(Context context, CommandsInterface commandsInterface, PhoneNotifier phoneNotifier, int i, int i2, TelephonyComponentFactory telephonyComponentFactory) {
        return new GsmCdmaPhone(context, commandsInterface, phoneNotifier, i, i2, telephonyComponentFactory);
    }

    public SubscriptionController initSubscriptionController(Context context) {
        return SubscriptionController.init(context);
    }

    public PhoneSwitcher makePhoneSwitcher(int i, Context context, Looper looper) {
        return PhoneSwitcher.make(i, context, looper);
    }

    public DisplayInfoController makeDisplayInfoController(Phone phone) {
        return new DisplayInfoController(phone);
    }

    public MultiSimSettingController initMultiSimSettingController(Context context, SubscriptionController subscriptionController) {
        return MultiSimSettingController.init(context, subscriptionController);
    }

    public RIL makeRil(Context context, int i, int i2, Integer num) {
        return new RIL(context, i, i2, num);
    }

    public SignalStrengthController makeSignalStrengthController(GsmCdmaPhone gsmCdmaPhone) {
        return new SignalStrengthController(gsmCdmaPhone);
    }

    public SubscriptionInfoUpdater makeSubscriptionInfoUpdater(Looper looper, Context context, SubscriptionController subscriptionController) {
        return new SubscriptionInfoUpdater(looper, context, subscriptionController);
    }

    public ProxyController makeProxyController(Context context) {
        return new ProxyController(context);
    }

    public LinkBandwidthEstimator makeLinkBandwidthEstimator(Phone phone) {
        return new LinkBandwidthEstimator(phone, this.mTelephonyFacade);
    }

    public DataNetworkController makeDataNetworkController(Phone phone, Looper looper) {
        return new DataNetworkController(phone, looper);
    }

    public DataProfileManager makeDataProfileManager(Phone phone, DataNetworkController dataNetworkController, DataServiceManager dataServiceManager, Looper looper, DataProfileManager.DataProfileManagerCallback dataProfileManagerCallback) {
        return new DataProfileManager(phone, dataNetworkController, dataServiceManager, looper, dataProfileManagerCallback);
    }

    public DataSettingsManager makeDataSettingsManager(Phone phone, DataNetworkController dataNetworkController, Looper looper, DataSettingsManager.DataSettingsManagerCallback dataSettingsManagerCallback) {
        return new DataSettingsManager(phone, dataNetworkController, looper, dataSettingsManagerCallback);
    }

    public DataNetwork makeDataNetwork(Phone phone, Looper looper, SparseArray<DataServiceManager> sparseArray, DataProfile dataProfile, DataNetworkController.NetworkRequestList networkRequestList, int i, DataEvaluation.DataAllowedReason dataAllowedReason, DataNetwork.DataNetworkCallback dataNetworkCallback) {
        return new DataNetwork(phone, looper, sparseArray, dataProfile, networkRequestList, i, dataAllowedReason, dataNetworkCallback);
    }

    public DataConfigManager makeDataConfigManager(Phone phone, Looper looper) {
        return new DataConfigManager(phone, looper);
    }

    public CdmaSubscriptionSourceManager makeCdmaSubscriptionSourceManager(Context context, CommandsInterface commandsInterface, Handler handler, int i, Object obj) {
        return new CdmaSubscriptionSourceManager(context, commandsInterface);
    }

    public UiccController makeUiccController(Context context) {
        return new UiccController(context);
    }

    public UiccSlot makeUiccSlot(Context context, boolean z) {
        return new UiccSlot(context, z);
    }

    public ImsPhone makeImsPhone(Context context, PhoneNotifier phoneNotifier, Phone phone) {
        return new ImsPhone(context, phoneNotifier, phone);
    }

    public MultiSimSettingController makeMultiSimSettingController(Context context, SubscriptionController subscriptionController) {
        return new MultiSimSettingController(context, subscriptionController);
    }

    public TelephonyNetworkFactory makeTelephonyNetworkFactories(Looper looper, Phone phone) {
        return new TelephonyNetworkFactory(looper, phone);
    }

    public DefaultPhoneNotifier makeDefaultPhoneNotifier(Context context) {
        return new DefaultPhoneNotifier(context);
    }

    public CatService makeCatService(CommandsInterface commandsInterface, UiccCardApplication uiccCardApplication, IccRecords iccRecords, Context context, IccFileHandler iccFileHandler, UiccProfile uiccProfile, int i) {
        return new CatService(commandsInterface, uiccCardApplication, iccRecords, context, iccFileHandler, uiccProfile, i);
    }

    public RilMessageDecoder makeRilMessageDecoder(Handler handler, IccFileHandler iccFileHandler, Context context, int i) {
        return new RilMessageDecoder(handler, iccFileHandler, context);
    }

    public CommandParamsFactory makeCommandParamsFactory(RilMessageDecoder rilMessageDecoder, IccFileHandler iccFileHandler, Context context) {
        return new CommandParamsFactory(rilMessageDecoder, iccFileHandler, context);
    }

    public IconLoader makeIconLoader(Looper looper, IccFileHandler iccFileHandler) {
        return new IconLoader(looper, iccFileHandler);
    }
}
