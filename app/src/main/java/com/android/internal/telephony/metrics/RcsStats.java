package com.android.internal.telephony.metrics;

import android.os.Binder;
import android.telephony.SubscriptionManager;
import android.telephony.ims.FeatureTagState;
import android.telephony.ims.RcsContactPresenceTuple;
import android.telephony.ims.RcsContactUceCapability;
import android.telephony.ims.aidl.IRcsConfigCallback;
import android.util.Base64;
import com.android.ims.rcs.uce.UceStatsWriter;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.nano.PersistAtomsProto;
import com.android.internal.telephony.protobuf.nano.MessageNano;
import com.android.telephony.Rlog;
import com.pri.support.widget.BuildConfig;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;

public class RcsStats {
    private static final Map<String, Integer> FEATURE_TAGS;
    private static final Map<String, Integer> MESSAGE_TYPE;
    private static final long MIN_DURATION_MILLIS = 1000;
    /* access modifiers changed from: private */
    public static final HashSet<String> MMTEL_SERVICE_ID_SET;
    public static final int NONE = -1;
    private static final Map<String, Integer> NOTIFY_REASONS;
    /* access modifiers changed from: private */
    public static final Random RANDOM = new Random();
    /* access modifiers changed from: private */
    public static final HashSet<String> RCS_SERVICE_ID_SET;
    private static final Map<String, Integer> SERVICE_IDS;
    private static final String SIP_REQUEST_MESSAGE_TYPE_ACK = "ACK";
    private static final String SIP_REQUEST_MESSAGE_TYPE_BYE = "BYE";
    private static final String SIP_REQUEST_MESSAGE_TYPE_CANCEL = "CANCEL";
    private static final String SIP_REQUEST_MESSAGE_TYPE_INFO = "INFO";
    private static final String SIP_REQUEST_MESSAGE_TYPE_INVITE = "INVITE";
    private static final String SIP_REQUEST_MESSAGE_TYPE_MESSAGE = "MESSAGE";
    private static final String SIP_REQUEST_MESSAGE_TYPE_NOTIFY = "NOTIFY";
    private static final String SIP_REQUEST_MESSAGE_TYPE_OPTIONS = "OPTIONS";
    private static final String SIP_REQUEST_MESSAGE_TYPE_PRACK = "PRACK";
    private static final String SIP_REQUEST_MESSAGE_TYPE_PUBLISH = "PUBLISH";
    private static final String SIP_REQUEST_MESSAGE_TYPE_REFER = "REFER";
    private static final String SIP_REQUEST_MESSAGE_TYPE_REGISTER = "REGISTER";
    private static final String SIP_REQUEST_MESSAGE_TYPE_SUBSCRIBE = "SUBSCRIBE";
    private static final String SIP_REQUEST_MESSAGE_TYPE_UPDATE = "UPDATE";
    public static final int STATE_DENIED = 2;
    public static final int STATE_DEREGISTERED = 1;
    public static final int STATE_REGISTERED = 0;
    private static final int SUBSCRIBE_NOTIFY = 2;
    private static final int SUBSCRIBE_SUCCESS = 1;
    private static final String TAG = "RcsStats";
    private static RcsStats sInstance;
    /* access modifiers changed from: private */
    public static final Map<Long, Integer> sSubscribeTaskIds = new HashMap();
    /* access modifiers changed from: private */
    public final PersistAtomsStorage mAtomsStorage = PhoneFactory.getMetricsCollector().getAtomsStorage();
    private UceStatsWriterCallback mCallback = null;
    @VisibleForTesting
    protected final Map<Integer, PersistAtomsProto.ImsDedicatedBearerListenerEvent> mDedicatedBearerListenerEventMap = new HashMap();
    private final List<PersistAtomsProto.ImsRegistrationFeatureTagStats> mImsRegistrationFeatureTagStatsList = new ArrayList();
    @VisibleForTesting
    protected final List<PersistAtomsProto.ImsRegistrationServiceDescStats> mImsRegistrationServiceDescStatsList = new ArrayList();
    /* access modifiers changed from: private */
    public HashMap<Integer, SipTransportFeatureTags> mLastFeatureTagStatMap = new HashMap<>();
    private List<LastSipDelegateStat> mLastSipDelegateStatList = new ArrayList();
    @VisibleForTesting
    protected final List<PersistAtomsProto.RcsAcsProvisioningStats> mRcsAcsProvisioningStatsList = new ArrayList();
    @VisibleForTesting
    protected final HashMap<Integer, RcsProvisioningCallback> mRcsProvisioningCallbackMap = new HashMap<>();
    private SipMessageArray mSipMessage;
    private ArrayList<SipMessageArray> mSipMessageArray = new ArrayList<>();
    private SipTransportSessionArray mSipTransportSession;
    private ArrayList<SipTransportSessionArray> mSipTransportSessionArray = new ArrayList<>();

    /* access modifiers changed from: protected */
    @VisibleForTesting
    public boolean isValidCarrierId(int i) {
        return i > -1;
    }

    static {
        HashMap hashMap = new HashMap();
        FEATURE_TAGS = hashMap;
        hashMap.put("+g.3gpp.icsi-ref=\"urn%3Aurn-7%3A3gpp-service.ims.icsi.oma.cpm.msg,urn%3Aurn-7%3A3gpp-service.ims.icsi.oma.cpm.largemsg,urn%3Aurn-7%3A3gpp-service.ims.icsi.oma.cpm.deferred\";+g.gsma.rcs.cpm.pager-large".toLowerCase(), 2);
        hashMap.put("+g.3gpp.iari-ref=\"urn%3Aurn-7%3A3gpp-application.ims.iari.rcse.im\"".toLowerCase(), 3);
        hashMap.put("+g.3gpp.icsi-ref=\"urn%3Aurn-7%3A3gpp-service.ims.icsi.oma.cpm.session\"".toLowerCase(), 4);
        hashMap.put("+g.3gpp.iari-ref=\"urn%3Aurn-7%3A3gpp-application.ims.iari.rcs.fthttp\"".toLowerCase(), 5);
        hashMap.put("+g.3gpp.iari-ref=\"urn%3Aurn-7%3A3gpp-application.ims.iari.rcs.ftsms\"".toLowerCase(), 6);
        hashMap.put("+g.3gpp.icsi-ref=\"urn%3Aurn-7%3A3gpp-service.ims.icsi.gsma.callcomposer\"".toLowerCase(), 7);
        hashMap.put("+g.gsma.callcomposer".toLowerCase(), 8);
        hashMap.put("+g.3gpp.icsi-ref=\"urn%3Aurn-7%3A3gpp-service.ims.icsi.gsma.callunanswered\"".toLowerCase(), 9);
        hashMap.put("+g.3gpp.icsi-ref=\"urn%3Aurn-7%3A3gpp-service.ims.icsi.gsma.sharedmap\"".toLowerCase(), 10);
        hashMap.put("+g.3gpp.icsi-ref=\"urn%3Aurn-7%3A3gpp-service.ims.icsi.gsma.sharedsketch\"".toLowerCase(), 11);
        hashMap.put("+g.3gpp.iari-ref=\"urn%3Aurn-7%3A3gpp-application.ims.iari.rcs.geopush\"".toLowerCase(), 12);
        hashMap.put("+g.3gpp.iari-ref=\"urn%3Aurn-7%3A3gpp-application.ims.iari.rcs.geosms\"".toLowerCase(), 13);
        hashMap.put("+g.3gpp.iari-ref=\"urn%3Aurn-7%3A3gpp-application.ims.iari.rcs.chatbot\"".toLowerCase(), 14);
        hashMap.put("+g.3gpp.iari-ref=\"urn%3Aurn-7%3A3gpp-application.ims.iari.rcs.chatbot.sa\"".toLowerCase(), 15);
        hashMap.put("+g.gsma.rcs.botversion=\"#=1\"".toLowerCase(), 16);
        hashMap.put("+g.gsma.rcs.isbot".toLowerCase(), 17);
        hashMap.put("+g.3gpp.icsi-ref=\"urn%3Aurn-7%3A3gpp-service.ims.icsi.mmtel\"".toLowerCase(), 18);
        hashMap.put("video".toLowerCase(), 19);
        hashMap.put("+g.3gpp.iari-ref=\"urn%3Aurn-7%3A3gpp-application.ims.iari.rcse.dp\"".toLowerCase(), 20);
        HashMap hashMap2 = new HashMap();
        SERVICE_IDS = hashMap2;
        hashMap2.put("org.3gpp.urn:urn-7:3gpp-service.ims.icsi.mmtel".toLowerCase(), 2);
        hashMap2.put("org.openmobilealliance:IM-session".toLowerCase(), 3);
        hashMap2.put("org.openmobilealliance:ChatSession".toLowerCase(), 4);
        hashMap2.put("org.openmobilealliance:File-Transfer-HTTP".toLowerCase(), 5);
        hashMap2.put("org.3gpp.urn:urn-7:3gpp-application.ims.iari.rcs.ftsms".toLowerCase(), 6);
        hashMap2.put("org.3gpp.urn:urn-7:3gpp-application.ims.iari.rcs.geopush".toLowerCase(), 7);
        hashMap2.put("org.3gpp.urn:urn-7:3gpp-application.ims.iari.rcs.geosms".toLowerCase(), 8);
        hashMap2.put("org.3gpp.urn:urn-7:3gpp-service.ims.icsi.gsma.callcomposer".toLowerCase(), 9);
        hashMap2.put("org.3gpp.urn:urn-7:3gpp-service.ims.icsi.gsma.callunanswered".toLowerCase(), 10);
        hashMap2.put("org.3gpp.urn:urn-7:3gpp-service.ims.icsi.gsma.sharedmap".toLowerCase(), 11);
        hashMap2.put("org.3gpp.urn:urn-7:3gpp-service.ims.icsi.gsma.sharedsketch".toLowerCase(), 12);
        hashMap2.put("org.3gpp.urn:urn-7:3gpp-application.ims.iari.rcs.chatbot".toLowerCase(), 13);
        hashMap2.put("org.3gpp.urn:urn-7:3gpp-application.ims.iari.rcs.chatbot.sa".toLowerCase(), 14);
        hashMap2.put("org.gsma.rcs.isbot".toLowerCase(), 15);
        HashMap hashMap3 = new HashMap();
        MESSAGE_TYPE = hashMap3;
        hashMap3.put(SIP_REQUEST_MESSAGE_TYPE_INVITE.toLowerCase(), 2);
        hashMap3.put(SIP_REQUEST_MESSAGE_TYPE_ACK.toLowerCase(), 3);
        hashMap3.put(SIP_REQUEST_MESSAGE_TYPE_OPTIONS.toLowerCase(), 4);
        hashMap3.put(SIP_REQUEST_MESSAGE_TYPE_BYE.toLowerCase(), 5);
        hashMap3.put(SIP_REQUEST_MESSAGE_TYPE_CANCEL.toLowerCase(), 6);
        hashMap3.put(SIP_REQUEST_MESSAGE_TYPE_REGISTER.toLowerCase(), 7);
        hashMap3.put(SIP_REQUEST_MESSAGE_TYPE_PRACK.toLowerCase(), 8);
        hashMap3.put(SIP_REQUEST_MESSAGE_TYPE_SUBSCRIBE.toLowerCase(), 9);
        hashMap3.put(SIP_REQUEST_MESSAGE_TYPE_NOTIFY.toLowerCase(), 10);
        hashMap3.put(SIP_REQUEST_MESSAGE_TYPE_PUBLISH.toLowerCase(), 11);
        hashMap3.put(SIP_REQUEST_MESSAGE_TYPE_INFO.toLowerCase(), 12);
        hashMap3.put(SIP_REQUEST_MESSAGE_TYPE_REFER.toLowerCase(), 13);
        hashMap3.put(SIP_REQUEST_MESSAGE_TYPE_MESSAGE.toLowerCase(), 14);
        hashMap3.put(SIP_REQUEST_MESSAGE_TYPE_UPDATE.toLowerCase(), 15);
        HashMap hashMap4 = new HashMap();
        NOTIFY_REASONS = hashMap4;
        hashMap4.put("deactivated", 2);
        hashMap4.put("probation", 3);
        hashMap4.put("rejected", 4);
        hashMap4.put("timeout", 5);
        hashMap4.put("giveup", 6);
        hashMap4.put("noresource", 7);
        HashSet<String> hashSet = new HashSet<>();
        RCS_SERVICE_ID_SET = hashSet;
        hashSet.add("org.openmobilealliance:IM-session");
        hashSet.add("org.openmobilealliance:ChatSession");
        hashSet.add("org.openmobilealliance:File-Transfer-HTTP");
        hashSet.add("org.3gpp.urn:urn-7:3gpp-application.ims.iari.rcs.ftsms");
        hashSet.add("org.3gpp.urn:urn-7:3gpp-application.ims.iari.rcs.geopush");
        hashSet.add("org.3gpp.urn:urn-7:3gpp-application.ims.iari.rcs.geosms");
        hashSet.add("org.3gpp.urn:urn-7:3gpp-service.ims.icsi.gsma.sharedmap");
        hashSet.add("org.3gpp.urn:urn-7:3gpp-service.ims.icsi.gsma.sharedsketch");
        hashSet.add("org.3gpp.urn:urn-7:3gpp-application.ims.iari.rcs.chatbot");
        hashSet.add(" org.3gpp.urn:urn-7:3gpp-application.ims.iari.rcs.chatbot.sa");
        hashSet.add("org.gsma.rcs.isbot");
        HashSet<String> hashSet2 = new HashSet<>();
        MMTEL_SERVICE_ID_SET = hashSet2;
        hashSet2.add("org.3gpp.urn:urn-7:3gpp-service.ims.icsi.mmtel");
        hashSet2.add("org.3gpp.urn:urn-7:3gpp-service.ims.icsi.gsma.callcomposer");
        hashSet2.add("org.3gpp.urn:urn-7:3gpp-service.ims.icsi.gsma.callunanswered");
    }

    private class LastSipDelegateStat {
        public PersistAtomsProto.SipDelegateStats mLastStat;
        public int mSubId;
        private Set<String> mSupportedTags;

        LastSipDelegateStat(int i, Set<String> set) {
            this.mSubId = i;
            this.mSupportedTags = set;
        }

        public void createSipDelegateStat(int i) {
            PersistAtomsProto.SipDelegateStats defaultSipDelegateStat = getDefaultSipDelegateStat(i);
            this.mLastStat = defaultSipDelegateStat;
            defaultSipDelegateStat.uptimeMillis = RcsStats.this.getWallTimeMillis();
            this.mLastStat.destroyReason = -1;
        }

        public void setSipDelegateDestroyReason(int i) {
            this.mLastStat.destroyReason = i;
        }

        public boolean isDestroyed() {
            return this.mLastStat.destroyReason > -1;
        }

        public void conclude(long j) {
            PersistAtomsProto.SipDelegateStats sipDelegateStats = this.mLastStat;
            long j2 = j - sipDelegateStats.uptimeMillis;
            if (j2 < 1000) {
                RcsStats rcsStats = RcsStats.this;
                rcsStats.logd("concludeSipDelegateStat: discarding transient stats, duration= " + j2);
            } else {
                sipDelegateStats.uptimeMillis = j2;
                RcsStats.this.mAtomsStorage.addSipDelegateStats(RcsStats.copyOf(this.mLastStat));
            }
            this.mLastStat.uptimeMillis = j;
        }

        public boolean compare(int i, Set<String> set) {
            if (i != this.mSubId || set == null || set.isEmpty()) {
                return false;
            }
            for (String contains : set) {
                if (!this.mSupportedTags.contains(contains)) {
                    return false;
                }
            }
            return true;
        }

        private PersistAtomsProto.SipDelegateStats getDefaultSipDelegateStat(int i) {
            PersistAtomsProto.SipDelegateStats sipDelegateStats = new PersistAtomsProto.SipDelegateStats();
            sipDelegateStats.dimension = RcsStats.RANDOM.nextInt();
            sipDelegateStats.carrierId = RcsStats.this.getCarrierId(i);
            sipDelegateStats.slotId = RcsStats.this.getSlotId(i);
            return sipDelegateStats;
        }
    }

    /* access modifiers changed from: private */
    public static PersistAtomsProto.SipDelegateStats copyOf(PersistAtomsProto.SipDelegateStats sipDelegateStats) {
        PersistAtomsProto.SipDelegateStats sipDelegateStats2 = new PersistAtomsProto.SipDelegateStats();
        sipDelegateStats2.dimension = sipDelegateStats.dimension;
        sipDelegateStats2.slotId = sipDelegateStats.slotId;
        sipDelegateStats2.carrierId = sipDelegateStats.carrierId;
        sipDelegateStats2.destroyReason = sipDelegateStats.destroyReason;
        sipDelegateStats2.uptimeMillis = sipDelegateStats.uptimeMillis;
        return sipDelegateStats2;
    }

    private class SipTransportFeatureTags {
        private HashMap<String, LastFeatureTagState> mFeatureTagMap = new HashMap<>();
        private int mSubId;

        private class LastFeatureTagState {
            public int carrierId;
            public int reason;
            public int slotId;
            public int state;
            public long timeStamp;

            LastFeatureTagState(int i, int i2, int i3, int i4, long j) {
                this.carrierId = i;
                this.slotId = i2;
                this.state = i3;
                this.reason = i4;
                this.timeStamp = j;
            }

            public void update(int i, int i2, long j) {
                this.state = i;
                this.reason = i2;
                this.timeStamp = j;
            }

            public void update(long j) {
                this.timeStamp = j;
            }
        }

        SipTransportFeatureTags(int i) {
            this.mSubId = i;
        }

        public HashMap<String, LastFeatureTagState> getLastTagStates() {
            return this.mFeatureTagMap;
        }

        public synchronized void updateLastFeatureTagState(String str, int i, int i2, long j) {
            int carrierId = RcsStats.this.getCarrierId(this.mSubId);
            int slotId = RcsStats.this.getSlotId(this.mSubId);
            if (this.mFeatureTagMap.containsKey(str)) {
                LastFeatureTagState lastFeatureTagState = this.mFeatureTagMap.get(str);
                if (lastFeatureTagState != null) {
                    addFeatureTagStat(str, lastFeatureTagState, j);
                    lastFeatureTagState.update(i, i2, j);
                } else {
                    create(str, carrierId, slotId, i, i2, j);
                }
            } else {
                create(str, carrierId, slotId, i, i2, j);
            }
        }

        public synchronized void conclude(long j) {
            HashMap hashMap = new HashMap();
            hashMap.putAll(this.mFeatureTagMap);
            for (Map.Entry entry : hashMap.entrySet()) {
                String str = (String) entry.getKey();
                addFeatureTagStat(str, (LastFeatureTagState) entry.getValue(), j);
                updateTimeStamp(this.mSubId, str, j);
            }
        }

        private synchronized boolean addFeatureTagStat(String str, LastFeatureTagState lastFeatureTagState, long j) {
            long j2 = j - lastFeatureTagState.timeStamp;
            if (j2 >= 1000) {
                if (RcsStats.this.isValidCarrierId(lastFeatureTagState.carrierId)) {
                    PersistAtomsProto.SipTransportFeatureTagStats sipTransportFeatureTagStats = new PersistAtomsProto.SipTransportFeatureTagStats();
                    int i = lastFeatureTagState.state;
                    if (i == 1) {
                        sipTransportFeatureTagStats.sipTransportDeniedReason = -1;
                        sipTransportFeatureTagStats.sipTransportDeregisteredReason = lastFeatureTagState.reason;
                    } else if (i != 2) {
                        sipTransportFeatureTagStats.sipTransportDeniedReason = -1;
                        sipTransportFeatureTagStats.sipTransportDeregisteredReason = -1;
                    } else {
                        sipTransportFeatureTagStats.sipTransportDeniedReason = lastFeatureTagState.reason;
                        sipTransportFeatureTagStats.sipTransportDeregisteredReason = -1;
                    }
                    sipTransportFeatureTagStats.carrierId = lastFeatureTagState.carrierId;
                    sipTransportFeatureTagStats.slotId = lastFeatureTagState.slotId;
                    sipTransportFeatureTagStats.associatedMillis = j2;
                    sipTransportFeatureTagStats.featureTagName = RcsStats.this.convertTagNameToValue(str);
                    RcsStats.this.mAtomsStorage.addSipTransportFeatureTagStats(sipTransportFeatureTagStats);
                    return true;
                }
            }
            RcsStats rcsStats = RcsStats.this;
            rcsStats.logd("conclude: discarding transient stats, duration= " + j2 + ", carrierId = " + lastFeatureTagState.carrierId);
            return false;
        }

        private void updateTimeStamp(int i, String str, long j) {
            HashMap<String, LastFeatureTagState> lastTagStates;
            LastFeatureTagState lastFeatureTagState;
            SipTransportFeatureTags sipTransportFeatureTags = (SipTransportFeatureTags) RcsStats.this.mLastFeatureTagStatMap.get(Integer.valueOf(i));
            if (sipTransportFeatureTags != null && (lastTagStates = sipTransportFeatureTags.getLastTagStates()) != null && lastTagStates.containsKey(str) && (lastFeatureTagState = lastTagStates.get(str)) != null) {
                lastFeatureTagState.update(j);
            }
        }

        private LastFeatureTagState create(String str, int i, int i2, int i3, int i4, long j) {
            LastFeatureTagState lastFeatureTagState = new LastFeatureTagState(i, i2, i3, i4, j);
            String str2 = str;
            this.mFeatureTagMap.put(str, lastFeatureTagState);
            return lastFeatureTagState;
        }
    }

    class UceStatsWriterCallback implements UceStatsWriter.UceStatsCallback {
        private RcsStats mRcsStats;

        UceStatsWriterCallback(RcsStats rcsStats) {
            RcsStats.this.logd("created Callback");
            this.mRcsStats = rcsStats;
        }

        public void onImsRegistrationFeatureTagStats(int i, List<String> list, int i2) {
            this.mRcsStats.onImsRegistrationFeatureTagStats(i, list, i2);
        }

        public void onStoreCompleteImsRegistrationFeatureTagStats(int i) {
            this.mRcsStats.onStoreCompleteImsRegistrationFeatureTagStats(i);
        }

        public void onImsRegistrationServiceDescStats(int i, List<String> list, List<String> list2, int i2) {
            this.mRcsStats.onImsRegistrationServiceDescStats(i, list, list2, i2);
        }

        public void onSubscribeResponse(int i, long j, int i2) {
            if (i2 >= 200 && i2 <= 299 && !RcsStats.sSubscribeTaskIds.containsKey(Long.valueOf(j))) {
                RcsStats.sSubscribeTaskIds.put(Long.valueOf(j), 1);
            }
            this.mRcsStats.onUceEventStats(i, 2, true, 0, i2);
        }

        public void onUceEvent(int i, int i2, boolean z, int i3, int i4) {
            int i5;
            int i6 = 3;
            if (i2 == 0) {
                i5 = 1;
            } else if (i2 != 1) {
                if (i2 != 2) {
                    if (i2 == 3) {
                        i6 = 4;
                    } else {
                        return;
                    }
                }
                i5 = i6;
            } else {
                i5 = 2;
            }
            this.mRcsStats.onUceEventStats(i, i5, z, i3, i4);
        }

        public void onSubscribeTerminated(int i, long j, String str) {
            if (RcsStats.sSubscribeTaskIds.containsKey(Long.valueOf(j))) {
                int intValue = ((Integer) RcsStats.sSubscribeTaskIds.get(Long.valueOf(j))).intValue();
                RcsStats.sSubscribeTaskIds.remove(Long.valueOf(j));
                if (intValue == 1) {
                    this.mRcsStats.onPresenceNotifyEvent(i, str, false, false, false, false);
                }
            }
        }

        public void onPresenceNotifyEvent(int i, long j, List<RcsContactUceCapability> list) {
            if (list != null && !list.isEmpty()) {
                if (RcsStats.sSubscribeTaskIds.containsKey(Long.valueOf(j))) {
                    RcsStats.sSubscribeTaskIds.replace(Long.valueOf(j), 2);
                }
                for (RcsContactUceCapability capabilityTuples : list) {
                    List<RcsContactPresenceTuple> capabilityTuples2 = capabilityTuples.getCapabilityTuples();
                    if (capabilityTuples2.isEmpty()) {
                        this.mRcsStats.onPresenceNotifyEvent(i, "", true, false, false, true);
                    } else {
                        boolean z = true;
                        boolean z2 = false;
                        boolean z3 = false;
                        for (RcsContactPresenceTuple rcsContactPresenceTuple : capabilityTuples2) {
                            String serviceId = rcsContactPresenceTuple.getServiceId();
                            if (!RcsStats.RCS_SERVICE_ID_SET.contains(serviceId)) {
                                if (RcsStats.MMTEL_SERVICE_ID_SET.contains(serviceId)) {
                                    if (!serviceId.equals("org.3gpp.urn:urn-7:3gpp-service.ims.icsi.gsma.callcomposer") || !BuildConfig.VERSION_NAME.equals(rcsContactPresenceTuple.getServiceVersion())) {
                                        z = false;
                                        z3 = true;
                                    }
                                }
                            }
                            z = false;
                            z2 = true;
                        }
                        this.mRcsStats.onPresenceNotifyEvent(i, "", true, z2, z3, z);
                    }
                }
            }
        }

        public void onStoreCompleteImsRegistrationServiceDescStats(int i) {
            this.mRcsStats.onStoreCompleteImsRegistrationServiceDescStats(i);
        }
    }

    public class RcsProvisioningCallback extends IRcsConfigCallback.Stub {
        private boolean mEnableSingleRegistration;
        private RcsStats mRcsStats;
        private boolean mRegistered = false;
        private int mSubId;

        public void onConfigurationChanged(byte[] bArr) {
        }

        public void onConfigurationReset() {
        }

        RcsProvisioningCallback(RcsStats rcsStats, int i, boolean z) {
            RcsStats.this.logd("created RcsProvisioningCallback");
            this.mRcsStats = rcsStats;
            this.mSubId = i;
            this.mEnableSingleRegistration = z;
        }

        public synchronized void setEnableSingleRegistration(boolean z) {
            this.mEnableSingleRegistration = z;
        }

        public boolean getRegistered() {
            return this.mRegistered;
        }

        public void setRegistered(boolean z) {
            this.mRegistered = z;
        }

        public void onAutoConfigurationErrorReceived(int i, String str) {
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                this.mRcsStats.onRcsAcsProvisioningStats(this.mSubId, i, 1, this.mEnableSingleRegistration);
            } finally {
                IRcsConfigCallback.Stub.restoreCallingIdentity(clearCallingIdentity);
            }
        }

        public void onRemoved() {
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                this.mRcsStats.onStoreCompleteRcsAcsProvisioningStats(this.mSubId);
                this.mRcsStats.removeRcsProvisioningCallback(this.mSubId);
            } finally {
                IRcsConfigCallback.Stub.restoreCallingIdentity(clearCallingIdentity);
            }
        }

        public void onPreProvisioningReceived(byte[] bArr) {
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                this.mRcsStats.onRcsAcsProvisioningStats(this.mSubId, 200, 3, this.mEnableSingleRegistration);
            } finally {
                IRcsConfigCallback.Stub.restoreCallingIdentity(clearCallingIdentity);
            }
        }
    }

    private class SipMessageArray {
        /* access modifiers changed from: private */
        public String mCallId;
        /* access modifiers changed from: private */
        public int mDirection;
        /* access modifiers changed from: private */
        public String mMethod;

        SipMessageArray(String str, int i, String str2) {
            this.mMethod = str;
            this.mCallId = str2;
            this.mDirection = i;
        }

        /* access modifiers changed from: private */
        public synchronized void addSipMessageStat(int i, String str, int i2, int i3, int i4) {
            int carrierId = RcsStats.this.getCarrierId(i);
            if (RcsStats.this.isValidCarrierId(carrierId)) {
                PersistAtomsProto.SipMessageResponse sipMessageResponse = new PersistAtomsProto.SipMessageResponse();
                sipMessageResponse.carrierId = carrierId;
                sipMessageResponse.slotId = RcsStats.this.getSlotId(i);
                sipMessageResponse.sipMessageMethod = RcsStats.this.convertMessageTypeToValue(str);
                sipMessageResponse.sipMessageResponse = i2;
                sipMessageResponse.sipMessageDirection = i3;
                sipMessageResponse.messageError = i4;
                sipMessageResponse.count = 1;
                RcsStats.this.mAtomsStorage.addSipMessageResponse(sipMessageResponse);
            }
        }
    }

    private class SipTransportSessionArray {
        /* access modifiers changed from: private */
        public String mCallId;
        /* access modifiers changed from: private */
        public int mDirection;
        /* access modifiers changed from: private */
        public String mMethod;
        /* access modifiers changed from: private */
        public int mSipResponse = 0;

        SipTransportSessionArray(String str, int i, String str2) {
            this.mMethod = str;
            this.mCallId = str2;
            this.mDirection = i;
        }

        /* access modifiers changed from: private */
        public synchronized void addSipTransportSessionStat(int i, String str, int i2, int i3, boolean z) {
            int carrierId = RcsStats.this.getCarrierId(i);
            if (RcsStats.this.isValidCarrierId(carrierId)) {
                PersistAtomsProto.SipTransportSession sipTransportSession = new PersistAtomsProto.SipTransportSession();
                sipTransportSession.carrierId = carrierId;
                sipTransportSession.slotId = RcsStats.this.getSlotId(i);
                sipTransportSession.sessionMethod = RcsStats.this.convertMessageTypeToValue(str);
                sipTransportSession.sipMessageDirection = i2;
                sipTransportSession.sipResponse = i3;
                sipTransportSession.sessionCount = 1;
                sipTransportSession.endedGracefullyCount = 1;
                sipTransportSession.isEndedGracefully = z;
                RcsStats.this.mAtomsStorage.addCompleteSipTransportSession(sipTransportSession);
            }
        }
    }

    @VisibleForTesting
    protected RcsStats() {
    }

    public static RcsStats getInstance() {
        RcsStats rcsStats;
        synchronized (RcsStats.class) {
            if (sInstance == null) {
                Rlog.d(TAG, "RcsStats created.");
                sInstance = new RcsStats();
            }
            rcsStats = sInstance;
        }
        return rcsStats;
    }

    public void registerUceCallback() {
        if (this.mCallback == null) {
            this.mCallback = new UceStatsWriterCallback(sInstance);
            Rlog.d(TAG, "UceStatsWriterCallback created.");
            UceStatsWriter.init(this.mCallback);
        }
    }

    public void onImsRegistrationFeatureTagStats(int i, List<String> list, int i2) {
        synchronized (this.mImsRegistrationFeatureTagStatsList) {
            int carrierId = getCarrierId(i);
            if (!isValidCarrierId(carrierId)) {
                flushImsRegistrationFeatureTagStatsInvalid();
                return;
            }
            onStoreCompleteImsRegistrationFeatureTagStats(i);
            if (list == null) {
                Rlog.d(TAG, "featureTagNames is null or empty");
                return;
            }
            for (String convertTagNameToValue : list) {
                PersistAtomsProto.ImsRegistrationFeatureTagStats imsRegistrationFeatureTagStats = new PersistAtomsProto.ImsRegistrationFeatureTagStats();
                imsRegistrationFeatureTagStats.carrierId = carrierId;
                imsRegistrationFeatureTagStats.slotId = getSlotId(i);
                imsRegistrationFeatureTagStats.featureTagName = convertTagNameToValue(convertTagNameToValue);
                imsRegistrationFeatureTagStats.registrationTech = i2;
                imsRegistrationFeatureTagStats.registeredMillis = getWallTimeMillis();
                this.mImsRegistrationFeatureTagStatsList.add(imsRegistrationFeatureTagStats);
            }
        }
    }

    public void onStoreCompleteImsRegistrationFeatureTagStats(int i) {
        synchronized (this.mImsRegistrationFeatureTagStatsList) {
            int carrierId = getCarrierId(i);
            ArrayList<PersistAtomsProto.ImsRegistrationFeatureTagStats> arrayList = new ArrayList<>();
            long wallTimeMillis = getWallTimeMillis();
            for (PersistAtomsProto.ImsRegistrationFeatureTagStats next : this.mImsRegistrationFeatureTagStatsList) {
                if (next.carrierId == carrierId) {
                    next.registeredMillis = wallTimeMillis - next.registeredMillis;
                    this.mAtomsStorage.addImsRegistrationFeatureTagStats(next);
                    arrayList.add(next);
                }
            }
            for (PersistAtomsProto.ImsRegistrationFeatureTagStats remove : arrayList) {
                this.mImsRegistrationFeatureTagStatsList.remove(remove);
            }
        }
    }

    public void onFlushIncompleteImsRegistrationFeatureTagStats() {
        synchronized (this.mImsRegistrationFeatureTagStatsList) {
            long wallTimeMillis = getWallTimeMillis();
            for (PersistAtomsProto.ImsRegistrationFeatureTagStats next : this.mImsRegistrationFeatureTagStatsList) {
                PersistAtomsProto.ImsRegistrationFeatureTagStats copyImsRegistrationFeatureTagStats = copyImsRegistrationFeatureTagStats(next);
                copyImsRegistrationFeatureTagStats.registeredMillis = wallTimeMillis - next.registeredMillis;
                this.mAtomsStorage.addImsRegistrationFeatureTagStats(copyImsRegistrationFeatureTagStats);
                next.registeredMillis = wallTimeMillis;
            }
        }
    }

    public synchronized void onRcsClientProvisioningStats(int i, int i2) {
        int carrierId = getCarrierId(i);
        if (isValidCarrierId(carrierId)) {
            PersistAtomsProto.RcsClientProvisioningStats rcsClientProvisioningStats = new PersistAtomsProto.RcsClientProvisioningStats();
            rcsClientProvisioningStats.carrierId = carrierId;
            rcsClientProvisioningStats.slotId = getSlotId(i);
            rcsClientProvisioningStats.event = i2;
            rcsClientProvisioningStats.count = 1;
            this.mAtomsStorage.addRcsClientProvisioningStats(rcsClientProvisioningStats);
        }
    }

    public void onRcsAcsProvisioningStats(int i, int i2, int i3, boolean z) {
        synchronized (this.mRcsAcsProvisioningStatsList) {
            int carrierId = getCarrierId(i);
            if (!isValidCarrierId(carrierId)) {
                flushRcsAcsProvisioningStatsInvalid();
                return;
            }
            onStoreCompleteRcsAcsProvisioningStats(i);
            PersistAtomsProto.RcsAcsProvisioningStats rcsAcsProvisioningStats = new PersistAtomsProto.RcsAcsProvisioningStats();
            rcsAcsProvisioningStats.carrierId = carrierId;
            rcsAcsProvisioningStats.slotId = getSlotId(i);
            rcsAcsProvisioningStats.responseCode = i2;
            rcsAcsProvisioningStats.responseType = i3;
            rcsAcsProvisioningStats.isSingleRegistrationEnabled = z;
            rcsAcsProvisioningStats.count = 1;
            rcsAcsProvisioningStats.stateTimerMillis = getWallTimeMillis();
            this.mRcsAcsProvisioningStatsList.add(rcsAcsProvisioningStats);
        }
    }

    public void onStoreCompleteRcsAcsProvisioningStats(int i) {
        synchronized (this.mRcsAcsProvisioningStatsList) {
            PersistAtomsProto.RcsAcsProvisioningStats rcsAcsProvisioningStats = getRcsAcsProvisioningStats(i);
            if (rcsAcsProvisioningStats != null) {
                rcsAcsProvisioningStats.stateTimerMillis = getWallTimeMillis() - rcsAcsProvisioningStats.stateTimerMillis;
                this.mAtomsStorage.addRcsAcsProvisioningStats(rcsAcsProvisioningStats);
                this.mRcsAcsProvisioningStatsList.remove(rcsAcsProvisioningStats);
            }
        }
    }

    public void onFlushIncompleteRcsAcsProvisioningStats() {
        synchronized (this.mRcsAcsProvisioningStatsList) {
            long wallTimeMillis = getWallTimeMillis();
            for (PersistAtomsProto.RcsAcsProvisioningStats next : this.mRcsAcsProvisioningStatsList) {
                PersistAtomsProto.RcsAcsProvisioningStats copyRcsAcsProvisioningStats = copyRcsAcsProvisioningStats(next);
                copyRcsAcsProvisioningStats.stateTimerMillis = wallTimeMillis - copyRcsAcsProvisioningStats.stateTimerMillis;
                this.mAtomsStorage.addRcsAcsProvisioningStats(copyRcsAcsProvisioningStats);
                next.stateTimerMillis = wallTimeMillis;
            }
        }
    }

    public synchronized void createSipDelegateStats(int i, Set<String> set) {
        if (set != null) {
            if (!set.isEmpty()) {
                getLastSipDelegateStat(i, set).createSipDelegateStat(i);
            }
        }
    }

    public synchronized void onSipDelegateStats(int i, Set<String> set, int i2) {
        if (set != null) {
            if (!set.isEmpty()) {
                getLastSipDelegateStat(i, set).setSipDelegateDestroyReason(i2);
                concludeSipDelegateStat();
            }
        }
    }

    public synchronized void onSipTransportFeatureTagStats(int i, Set<FeatureTagState> set, Set<FeatureTagState> set2, Set<String> set3) {
        long wallTimeMillis = getWallTimeMillis();
        SipTransportFeatureTags lastFeatureTags = getLastFeatureTags(i);
        if (set3 != null && !set3.isEmpty()) {
            for (String updateLastFeatureTagState : set3) {
                lastFeatureTags.updateLastFeatureTagState(updateLastFeatureTagState, 0, -1, wallTimeMillis);
            }
        }
        if (set != null && !set.isEmpty()) {
            for (FeatureTagState next : set) {
                lastFeatureTags.updateLastFeatureTagState(next.getFeatureTag(), 2, next.getState(), wallTimeMillis);
            }
        }
        if (set2 != null && !set2.isEmpty()) {
            for (FeatureTagState next2 : set2) {
                lastFeatureTags.updateLastFeatureTagState(next2.getFeatureTag(), 1, next2.getState(), wallTimeMillis);
            }
        }
    }

    public synchronized void concludeSipTransportFeatureTagsStat() {
        if (!this.mLastFeatureTagStatMap.isEmpty()) {
            long wallTimeMillis = getWallTimeMillis();
            HashMap hashMap = new HashMap();
            hashMap.putAll(this.mLastFeatureTagStatMap);
            for (SipTransportFeatureTags sipTransportFeatureTags : hashMap.values()) {
                if (sipTransportFeatureTags != null) {
                    sipTransportFeatureTags.conclude(wallTimeMillis);
                }
            }
        }
    }

    public synchronized void onSipMessageRequest(String str, String str2, int i) {
        SipMessageArray sipMessageArray = new SipMessageArray(str2, i, str);
        this.mSipMessage = sipMessageArray;
        this.mSipMessageArray.add(sipMessageArray);
    }

    public synchronized void invalidatedMessageResult(int i, String str, int i2, int i3) {
        this.mSipMessage.addSipMessageStat(i, str, 0, i2, i3);
    }

    public synchronized void onSipMessageResponse(int i, String str, int i2, int i3) {
        SipMessageArray sipMessageArray = (SipMessageArray) this.mSipMessageArray.stream().filter(new RcsStats$$ExternalSyntheticLambda0(str)).findFirst().orElse((Object) null);
        if (sipMessageArray != null) {
            this.mSipMessage.addSipMessageStat(i, sipMessageArray.mMethod, i2, sipMessageArray.mDirection, i3);
            this.mSipMessageArray.removeIf(new RcsStats$$ExternalSyntheticLambda1(str));
        }
    }

    public synchronized void earlySipTransportSession(String str, String str2, int i) {
        SipTransportSessionArray sipTransportSessionArray = new SipTransportSessionArray(str, i, str2);
        this.mSipTransportSession = sipTransportSessionArray;
        this.mSipTransportSessionArray.add(sipTransportSessionArray);
    }

    public synchronized void confirmedSipTransportSession(String str, int i) {
        SipTransportSessionArray sipTransportSessionArray = (SipTransportSessionArray) this.mSipTransportSessionArray.stream().filter(new RcsStats$$ExternalSyntheticLambda4(str)).findFirst().orElse((Object) null);
        if (sipTransportSessionArray != null) {
            sipTransportSessionArray.mSipResponse = i;
        }
    }

    public synchronized void onSipTransportSessionClosed(int i, String str, int i2, boolean z) {
        SipTransportSessionArray sipTransportSessionArray = (SipTransportSessionArray) this.mSipTransportSessionArray.stream().filter(new RcsStats$$ExternalSyntheticLambda2(str)).findFirst().orElse((Object) null);
        if (sipTransportSessionArray != null) {
            if (i2 != 0) {
                sipTransportSessionArray.mSipResponse = i2;
            }
            this.mSipTransportSession.addSipTransportSessionStat(i, sipTransportSessionArray.mMethod, sipTransportSessionArray.mDirection, i2, z);
            this.mSipTransportSessionArray.removeIf(new RcsStats$$ExternalSyntheticLambda3(str));
        }
    }

    /* JADX WARNING: Code restructure failed: missing block: B:16:0x0040, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void onImsDedicatedBearerListenerAdded(int r4, int r5, int r6, int r7) {
        /*
            r3 = this;
            monitor-enter(r3)
            int r0 = r3.getSubId(r5)     // Catch:{ all -> 0x0041 }
            int r1 = r3.getCarrierId(r0)     // Catch:{ all -> 0x0041 }
            r2 = -1
            if (r0 == r2) goto L_0x003f
            boolean r0 = r3.isValidCarrierId(r1)     // Catch:{ all -> 0x0041 }
            if (r0 != 0) goto L_0x0013
            goto L_0x003f
        L_0x0013:
            java.util.Map<java.lang.Integer, com.android.internal.telephony.nano.PersistAtomsProto$ImsDedicatedBearerListenerEvent> r0 = r3.mDedicatedBearerListenerEventMap     // Catch:{ all -> 0x0041 }
            java.lang.Integer r2 = java.lang.Integer.valueOf(r4)     // Catch:{ all -> 0x0041 }
            boolean r0 = r0.containsKey(r2)     // Catch:{ all -> 0x0041 }
            if (r0 == 0) goto L_0x0021
            monitor-exit(r3)
            return
        L_0x0021:
            com.android.internal.telephony.nano.PersistAtomsProto$ImsDedicatedBearerListenerEvent r0 = new com.android.internal.telephony.nano.PersistAtomsProto$ImsDedicatedBearerListenerEvent     // Catch:{ all -> 0x0041 }
            r0.<init>()     // Catch:{ all -> 0x0041 }
            r0.carrierId = r1     // Catch:{ all -> 0x0041 }
            r0.slotId = r5     // Catch:{ all -> 0x0041 }
            r0.ratAtEnd = r6     // Catch:{ all -> 0x0041 }
            r0.qci = r7     // Catch:{ all -> 0x0041 }
            r5 = 0
            r0.dedicatedBearerEstablished = r5     // Catch:{ all -> 0x0041 }
            r5 = 1
            r0.eventCount = r5     // Catch:{ all -> 0x0041 }
            java.util.Map<java.lang.Integer, com.android.internal.telephony.nano.PersistAtomsProto$ImsDedicatedBearerListenerEvent> r5 = r3.mDedicatedBearerListenerEventMap     // Catch:{ all -> 0x0041 }
            java.lang.Integer r4 = java.lang.Integer.valueOf(r4)     // Catch:{ all -> 0x0041 }
            r5.put(r4, r0)     // Catch:{ all -> 0x0041 }
            monitor-exit(r3)
            return
        L_0x003f:
            monitor-exit(r3)
            return
        L_0x0041:
            r4 = move-exception
            monitor-exit(r3)
            throw r4
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.metrics.RcsStats.onImsDedicatedBearerListenerAdded(int, int, int, int):void");
    }

    /* JADX WARNING: Code restructure failed: missing block: B:12:0x0057, code lost:
        return;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:14:0x0059, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void onImsDedicatedBearerListenerUpdateSession(int r4, int r5, int r6, int r7, boolean r8) {
        /*
            r3 = this;
            monitor-enter(r3)
            int r0 = r3.getSubId(r5)     // Catch:{ all -> 0x005a }
            int r1 = r3.getCarrierId(r0)     // Catch:{ all -> 0x005a }
            r2 = -1
            if (r0 == r2) goto L_0x0058
            boolean r0 = r3.isValidCarrierId(r1)     // Catch:{ all -> 0x005a }
            if (r0 != 0) goto L_0x0013
            goto L_0x0058
        L_0x0013:
            java.util.Map<java.lang.Integer, com.android.internal.telephony.nano.PersistAtomsProto$ImsDedicatedBearerListenerEvent> r0 = r3.mDedicatedBearerListenerEventMap     // Catch:{ all -> 0x005a }
            java.lang.Integer r2 = java.lang.Integer.valueOf(r4)     // Catch:{ all -> 0x005a }
            boolean r0 = r0.containsKey(r2)     // Catch:{ all -> 0x005a }
            if (r0 == 0) goto L_0x003b
            java.util.Map<java.lang.Integer, com.android.internal.telephony.nano.PersistAtomsProto$ImsDedicatedBearerListenerEvent> r5 = r3.mDedicatedBearerListenerEventMap     // Catch:{ all -> 0x005a }
            java.lang.Integer r0 = java.lang.Integer.valueOf(r4)     // Catch:{ all -> 0x005a }
            java.lang.Object r5 = r5.get(r0)     // Catch:{ all -> 0x005a }
            com.android.internal.telephony.nano.PersistAtomsProto$ImsDedicatedBearerListenerEvent r5 = (com.android.internal.telephony.nano.PersistAtomsProto.ImsDedicatedBearerListenerEvent) r5     // Catch:{ all -> 0x005a }
            r5.ratAtEnd = r6     // Catch:{ all -> 0x005a }
            r5.qci = r7     // Catch:{ all -> 0x005a }
            r5.dedicatedBearerEstablished = r8     // Catch:{ all -> 0x005a }
            java.util.Map<java.lang.Integer, com.android.internal.telephony.nano.PersistAtomsProto$ImsDedicatedBearerListenerEvent> r6 = r3.mDedicatedBearerListenerEventMap     // Catch:{ all -> 0x005a }
            java.lang.Integer r4 = java.lang.Integer.valueOf(r4)     // Catch:{ all -> 0x005a }
            r6.replace(r4, r5)     // Catch:{ all -> 0x005a }
            goto L_0x0056
        L_0x003b:
            com.android.internal.telephony.nano.PersistAtomsProto$ImsDedicatedBearerListenerEvent r0 = new com.android.internal.telephony.nano.PersistAtomsProto$ImsDedicatedBearerListenerEvent     // Catch:{ all -> 0x005a }
            r0.<init>()     // Catch:{ all -> 0x005a }
            r0.carrierId = r1     // Catch:{ all -> 0x005a }
            r0.slotId = r5     // Catch:{ all -> 0x005a }
            r0.ratAtEnd = r6     // Catch:{ all -> 0x005a }
            r0.qci = r7     // Catch:{ all -> 0x005a }
            r0.dedicatedBearerEstablished = r8     // Catch:{ all -> 0x005a }
            r5 = 1
            r0.eventCount = r5     // Catch:{ all -> 0x005a }
            java.util.Map<java.lang.Integer, com.android.internal.telephony.nano.PersistAtomsProto$ImsDedicatedBearerListenerEvent> r5 = r3.mDedicatedBearerListenerEventMap     // Catch:{ all -> 0x005a }
            java.lang.Integer r4 = java.lang.Integer.valueOf(r4)     // Catch:{ all -> 0x005a }
            r5.put(r4, r0)     // Catch:{ all -> 0x005a }
        L_0x0056:
            monitor-exit(r3)
            return
        L_0x0058:
            monitor-exit(r3)
            return
        L_0x005a:
            r4 = move-exception
            monitor-exit(r3)
            throw r4
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.metrics.RcsStats.onImsDedicatedBearerListenerUpdateSession(int, int, int, int, boolean):void");
    }

    public synchronized void onImsDedicatedBearerListenerRemoved(int i) {
        if (this.mDedicatedBearerListenerEventMap.containsKey(Integer.valueOf(i))) {
            this.mAtomsStorage.addImsDedicatedBearerListenerEvent(this.mDedicatedBearerListenerEventMap.get(Integer.valueOf(i)));
            this.mDedicatedBearerListenerEventMap.remove(Integer.valueOf(i));
        }
    }

    public synchronized void onImsDedicatedBearerEvent(int i, int i2, int i3, int i4, boolean z, boolean z2, boolean z3) {
        int subId = getSubId(i);
        if (subId != -1) {
            PersistAtomsProto.ImsDedicatedBearerEvent imsDedicatedBearerEvent = new PersistAtomsProto.ImsDedicatedBearerEvent();
            imsDedicatedBearerEvent.carrierId = getCarrierId(subId);
            imsDedicatedBearerEvent.slotId = getSlotId(subId);
            imsDedicatedBearerEvent.ratAtEnd = i2;
            imsDedicatedBearerEvent.qci = i3;
            imsDedicatedBearerEvent.bearerState = i4;
            imsDedicatedBearerEvent.localConnectionInfoReceived = z;
            imsDedicatedBearerEvent.remoteConnectionInfoReceived = z2;
            imsDedicatedBearerEvent.hasListeners = z3;
            imsDedicatedBearerEvent.count = 1;
            this.mAtomsStorage.addImsDedicatedBearerEvent(imsDedicatedBearerEvent);
        }
    }

    public void onImsRegistrationServiceDescStats(int i, List<String> list, List<String> list2, int i2) {
        synchronized (this.mImsRegistrationServiceDescStatsList) {
            int carrierId = getCarrierId(i);
            if (!isValidCarrierId(carrierId)) {
                handleImsRegistrationServiceDescStats();
                return;
            }
            onStoreCompleteImsRegistrationServiceDescStats(i);
            if (list == null) {
                Rlog.d(TAG, "serviceIds is null or empty");
                return;
            }
            int i3 = 0;
            for (String convertServiceIdToValue : list) {
                PersistAtomsProto.ImsRegistrationServiceDescStats imsRegistrationServiceDescStats = new PersistAtomsProto.ImsRegistrationServiceDescStats();
                imsRegistrationServiceDescStats.carrierId = carrierId;
                imsRegistrationServiceDescStats.slotId = getSlotId(i);
                imsRegistrationServiceDescStats.serviceIdName = convertServiceIdToValue(convertServiceIdToValue);
                imsRegistrationServiceDescStats.serviceIdVersion = Float.parseFloat(list2.get(i3));
                imsRegistrationServiceDescStats.registrationTech = i2;
                this.mImsRegistrationServiceDescStatsList.add(imsRegistrationServiceDescStats);
                i3++;
            }
        }
    }

    public void onFlushIncompleteImsRegistrationServiceDescStats() {
        synchronized (this.mImsRegistrationServiceDescStatsList) {
            for (PersistAtomsProto.ImsRegistrationServiceDescStats next : this.mImsRegistrationServiceDescStatsList) {
                PersistAtomsProto.ImsRegistrationServiceDescStats copyImsRegistrationServiceDescStats = copyImsRegistrationServiceDescStats(next);
                long wallTimeMillis = getWallTimeMillis();
                copyImsRegistrationServiceDescStats.publishedMillis = wallTimeMillis - next.publishedMillis;
                this.mAtomsStorage.addImsRegistrationServiceDescStats(copyImsRegistrationServiceDescStats);
                next.publishedMillis = wallTimeMillis;
            }
        }
    }

    /* JADX WARNING: Code restructure failed: missing block: B:14:0x003d, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void onUceEventStats(int r4, int r5, boolean r6, int r7, int r8) {
        /*
            r3 = this;
            monitor-enter(r3)
            com.android.internal.telephony.nano.PersistAtomsProto$UceEventStats r0 = new com.android.internal.telephony.nano.PersistAtomsProto$UceEventStats     // Catch:{ all -> 0x003e }
            r0.<init>()     // Catch:{ all -> 0x003e }
            int r1 = r3.getCarrierId(r4)     // Catch:{ all -> 0x003e }
            boolean r2 = r3.isValidCarrierId(r1)     // Catch:{ all -> 0x003e }
            if (r2 != 0) goto L_0x0015
            r3.handleImsRegistrationServiceDescStats()     // Catch:{ all -> 0x003e }
            monitor-exit(r3)
            return
        L_0x0015:
            r0.carrierId = r1     // Catch:{ all -> 0x003e }
            int r4 = r3.getSlotId(r4)     // Catch:{ all -> 0x003e }
            r0.slotId = r4     // Catch:{ all -> 0x003e }
            r0.type = r5     // Catch:{ all -> 0x003e }
            r0.successful = r6     // Catch:{ all -> 0x003e }
            r0.commandCode = r7     // Catch:{ all -> 0x003e }
            r0.networkResponse = r8     // Catch:{ all -> 0x003e }
            r4 = 1
            r0.count = r4     // Catch:{ all -> 0x003e }
            com.android.internal.telephony.metrics.PersistAtomsStorage r7 = r3.mAtomsStorage     // Catch:{ all -> 0x003e }
            r7.addUceEventStats(r0)     // Catch:{ all -> 0x003e }
            if (r5 != r4) goto L_0x003c
            if (r6 == 0) goto L_0x0037
            int r4 = r0.carrierId     // Catch:{ all -> 0x003e }
            r3.setImsRegistrationServiceDescStatsTime(r4)     // Catch:{ all -> 0x003e }
            goto L_0x003c
        L_0x0037:
            int r4 = r0.carrierId     // Catch:{ all -> 0x003e }
            r3.deleteImsRegistrationServiceDescStats(r4)     // Catch:{ all -> 0x003e }
        L_0x003c:
            monitor-exit(r3)
            return
        L_0x003e:
            r4 = move-exception
            monitor-exit(r3)
            throw r4
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.metrics.RcsStats.onUceEventStats(int, int, boolean, int, int):void");
    }

    public synchronized void onPresenceNotifyEvent(int i, String str, boolean z, boolean z2, boolean z3, boolean z4) {
        PersistAtomsProto.PresenceNotifyEvent presenceNotifyEvent = new PersistAtomsProto.PresenceNotifyEvent();
        int carrierId = getCarrierId(i);
        if (!isValidCarrierId(carrierId)) {
            handleImsRegistrationServiceDescStats();
            return;
        }
        presenceNotifyEvent.carrierId = carrierId;
        presenceNotifyEvent.slotId = getSlotId(i);
        presenceNotifyEvent.reason = convertPresenceNotifyReason(str);
        presenceNotifyEvent.contentBodyReceived = z;
        int i2 = 0;
        presenceNotifyEvent.rcsCapsCount = z2 ? 1 : 0;
        presenceNotifyEvent.mmtelCapsCount = z3 ? 1 : 0;
        if (z4) {
            i2 = 1;
        }
        presenceNotifyEvent.noCapsCount = i2;
        presenceNotifyEvent.count = 1;
        this.mAtomsStorage.addPresenceNotifyEvent(presenceNotifyEvent);
    }

    public void onStoreCompleteImsRegistrationServiceDescStats(int i) {
        synchronized (this.mImsRegistrationServiceDescStatsList) {
            int carrierId = getCarrierId(i);
            ArrayList<PersistAtomsProto.ImsRegistrationServiceDescStats> arrayList = new ArrayList<>();
            for (PersistAtomsProto.ImsRegistrationServiceDescStats next : this.mImsRegistrationServiceDescStatsList) {
                if (next.carrierId == carrierId) {
                    next.publishedMillis = getWallTimeMillis() - next.publishedMillis;
                    this.mAtomsStorage.addImsRegistrationServiceDescStats(next);
                    arrayList.add(next);
                }
            }
            for (PersistAtomsProto.ImsRegistrationServiceDescStats remove : arrayList) {
                this.mImsRegistrationServiceDescStatsList.remove(remove);
            }
        }
    }

    public synchronized void onGbaSuccessEvent(int i) {
        int carrierId = getCarrierId(i);
        if (isValidCarrierId(carrierId)) {
            PersistAtomsProto.GbaEvent gbaEvent = new PersistAtomsProto.GbaEvent();
            gbaEvent.carrierId = carrierId;
            gbaEvent.slotId = getSlotId(i);
            gbaEvent.successful = true;
            gbaEvent.failedReason = -1;
            gbaEvent.count = 1;
            this.mAtomsStorage.addGbaEvent(gbaEvent);
        }
    }

    public synchronized void onGbaFailureEvent(int i, int i2) {
        int carrierId = getCarrierId(i);
        if (isValidCarrierId(carrierId)) {
            PersistAtomsProto.GbaEvent gbaEvent = new PersistAtomsProto.GbaEvent();
            gbaEvent.carrierId = carrierId;
            gbaEvent.slotId = getSlotId(i);
            gbaEvent.successful = false;
            gbaEvent.failedReason = i2;
            gbaEvent.count = 1;
            this.mAtomsStorage.addGbaEvent(gbaEvent);
        }
    }

    public synchronized RcsProvisioningCallback getRcsProvisioningCallback(int i, boolean z) {
        RcsProvisioningCallback rcsProvisioningCallback = this.mRcsProvisioningCallbackMap.get(Integer.valueOf(i));
        if (rcsProvisioningCallback != null) {
            return rcsProvisioningCallback;
        }
        RcsProvisioningCallback rcsProvisioningCallback2 = new RcsProvisioningCallback(this, i, z);
        this.mRcsProvisioningCallbackMap.put(Integer.valueOf(i), rcsProvisioningCallback2);
        return rcsProvisioningCallback2;
    }

    public synchronized void setEnableSingleRegistration(int i, boolean z) {
        RcsProvisioningCallback rcsProvisioningCallback = this.mRcsProvisioningCallbackMap.get(Integer.valueOf(i));
        if (rcsProvisioningCallback != null) {
            rcsProvisioningCallback.setEnableSingleRegistration(z);
        }
    }

    /* access modifiers changed from: private */
    public synchronized void removeRcsProvisioningCallback(int i) {
        this.mRcsProvisioningCallbackMap.remove(Integer.valueOf(i));
    }

    private PersistAtomsProto.ImsRegistrationFeatureTagStats copyImsRegistrationFeatureTagStats(PersistAtomsProto.ImsRegistrationFeatureTagStats imsRegistrationFeatureTagStats) {
        PersistAtomsProto.ImsRegistrationFeatureTagStats imsRegistrationFeatureTagStats2 = new PersistAtomsProto.ImsRegistrationFeatureTagStats();
        imsRegistrationFeatureTagStats2.carrierId = imsRegistrationFeatureTagStats.carrierId;
        imsRegistrationFeatureTagStats2.slotId = imsRegistrationFeatureTagStats.slotId;
        imsRegistrationFeatureTagStats2.featureTagName = imsRegistrationFeatureTagStats.featureTagName;
        imsRegistrationFeatureTagStats2.registrationTech = imsRegistrationFeatureTagStats.registrationTech;
        imsRegistrationFeatureTagStats2.registeredMillis = imsRegistrationFeatureTagStats.registeredMillis;
        return imsRegistrationFeatureTagStats2;
    }

    private PersistAtomsProto.RcsAcsProvisioningStats copyRcsAcsProvisioningStats(PersistAtomsProto.RcsAcsProvisioningStats rcsAcsProvisioningStats) {
        PersistAtomsProto.RcsAcsProvisioningStats rcsAcsProvisioningStats2 = new PersistAtomsProto.RcsAcsProvisioningStats();
        rcsAcsProvisioningStats2.carrierId = rcsAcsProvisioningStats.carrierId;
        rcsAcsProvisioningStats2.slotId = rcsAcsProvisioningStats.slotId;
        rcsAcsProvisioningStats2.responseCode = rcsAcsProvisioningStats.responseCode;
        rcsAcsProvisioningStats2.responseType = rcsAcsProvisioningStats.responseType;
        rcsAcsProvisioningStats2.isSingleRegistrationEnabled = rcsAcsProvisioningStats.isSingleRegistrationEnabled;
        rcsAcsProvisioningStats2.count = rcsAcsProvisioningStats.count;
        rcsAcsProvisioningStats2.stateTimerMillis = rcsAcsProvisioningStats.stateTimerMillis;
        return rcsAcsProvisioningStats2;
    }

    private PersistAtomsProto.ImsRegistrationServiceDescStats copyImsRegistrationServiceDescStats(PersistAtomsProto.ImsRegistrationServiceDescStats imsRegistrationServiceDescStats) {
        PersistAtomsProto.ImsRegistrationServiceDescStats imsRegistrationServiceDescStats2 = new PersistAtomsProto.ImsRegistrationServiceDescStats();
        imsRegistrationServiceDescStats2.carrierId = imsRegistrationServiceDescStats.carrierId;
        imsRegistrationServiceDescStats2.slotId = imsRegistrationServiceDescStats.slotId;
        imsRegistrationServiceDescStats2.serviceIdName = imsRegistrationServiceDescStats.serviceIdName;
        imsRegistrationServiceDescStats2.serviceIdVersion = imsRegistrationServiceDescStats.serviceIdVersion;
        imsRegistrationServiceDescStats2.registrationTech = imsRegistrationServiceDescStats.registrationTech;
        return imsRegistrationServiceDescStats2;
    }

    private void setImsRegistrationServiceDescStatsTime(int i) {
        synchronized (this.mImsRegistrationServiceDescStatsList) {
            for (PersistAtomsProto.ImsRegistrationServiceDescStats next : this.mImsRegistrationServiceDescStatsList) {
                if (next.carrierId == i) {
                    next.publishedMillis = getWallTimeMillis();
                }
            }
        }
    }

    private void deleteImsRegistrationServiceDescStats(int i) {
        synchronized (this.mImsRegistrationServiceDescStatsList) {
            ArrayList<PersistAtomsProto.ImsRegistrationServiceDescStats> arrayList = new ArrayList<>();
            for (PersistAtomsProto.ImsRegistrationServiceDescStats next : this.mImsRegistrationServiceDescStatsList) {
                if (next.carrierId == i) {
                    arrayList.add(next);
                }
            }
            for (PersistAtomsProto.ImsRegistrationServiceDescStats remove : arrayList) {
                this.mImsRegistrationServiceDescStatsList.remove(remove);
            }
        }
    }

    private void handleImsRegistrationServiceDescStats() {
        synchronized (this.mImsRegistrationServiceDescStatsList) {
            ArrayList<PersistAtomsProto.ImsRegistrationServiceDescStats> arrayList = new ArrayList<>();
            for (PersistAtomsProto.ImsRegistrationServiceDescStats next : this.mImsRegistrationServiceDescStatsList) {
                if (next.carrierId != getCarrierId(getSubId(next.slotId))) {
                    arrayList.add(next);
                    if (next.publishedMillis != 0) {
                        next.publishedMillis = getWallTimeMillis() - next.publishedMillis;
                        this.mAtomsStorage.addImsRegistrationServiceDescStats(next);
                    }
                }
            }
            for (PersistAtomsProto.ImsRegistrationServiceDescStats remove : arrayList) {
                this.mImsRegistrationServiceDescStatsList.remove(remove);
            }
        }
    }

    private PersistAtomsProto.RcsAcsProvisioningStats getRcsAcsProvisioningStats(int i) {
        int carrierId = getCarrierId(i);
        int slotId = getSlotId(i);
        for (PersistAtomsProto.RcsAcsProvisioningStats next : this.mRcsAcsProvisioningStatsList) {
            if (next != null && next.carrierId == carrierId && next.slotId == slotId) {
                return next;
            }
        }
        return null;
    }

    private void flushRcsAcsProvisioningStatsInvalid() {
        ArrayList<PersistAtomsProto.RcsAcsProvisioningStats> arrayList = new ArrayList<>();
        for (PersistAtomsProto.RcsAcsProvisioningStats next : this.mRcsAcsProvisioningStatsList) {
            if (next.carrierId != getCarrierId(getSubId(next.slotId))) {
                arrayList.add(next);
            }
        }
        for (PersistAtomsProto.RcsAcsProvisioningStats rcsAcsProvisioningStats : arrayList) {
            rcsAcsProvisioningStats.stateTimerMillis = getWallTimeMillis() - rcsAcsProvisioningStats.stateTimerMillis;
            this.mAtomsStorage.addRcsAcsProvisioningStats(rcsAcsProvisioningStats);
            this.mRcsAcsProvisioningStatsList.remove(rcsAcsProvisioningStats);
        }
        arrayList.clear();
    }

    private void flushImsRegistrationFeatureTagStatsInvalid() {
        ArrayList<PersistAtomsProto.ImsRegistrationFeatureTagStats> arrayList = new ArrayList<>();
        for (PersistAtomsProto.ImsRegistrationFeatureTagStats next : this.mImsRegistrationFeatureTagStatsList) {
            if (next.carrierId != getCarrierId(getSubId(next.slotId))) {
                arrayList.add(next);
            }
        }
        for (PersistAtomsProto.ImsRegistrationFeatureTagStats imsRegistrationFeatureTagStats : arrayList) {
            imsRegistrationFeatureTagStats.registeredMillis = getWallTimeMillis() - imsRegistrationFeatureTagStats.registeredMillis;
            this.mAtomsStorage.addImsRegistrationFeatureTagStats(imsRegistrationFeatureTagStats);
            this.mImsRegistrationFeatureTagStatsList.remove(imsRegistrationFeatureTagStats);
        }
        arrayList.clear();
    }

    private LastSipDelegateStat getLastSipDelegateStat(int i, Set<String> set) {
        LastSipDelegateStat lastSipDelegateStat;
        Iterator<LastSipDelegateStat> it = this.mLastSipDelegateStatList.iterator();
        while (true) {
            if (!it.hasNext()) {
                lastSipDelegateStat = null;
                break;
            }
            lastSipDelegateStat = it.next();
            if (lastSipDelegateStat.compare(i, set)) {
                break;
            }
        }
        if (lastSipDelegateStat != null) {
            return lastSipDelegateStat;
        }
        LastSipDelegateStat lastSipDelegateStat2 = new LastSipDelegateStat(i, set);
        this.mLastSipDelegateStatList.add(lastSipDelegateStat2);
        return lastSipDelegateStat2;
    }

    private void concludeSipDelegateStat() {
        if (!this.mLastSipDelegateStatList.isEmpty()) {
            long wallTimeMillis = getWallTimeMillis();
            for (LastSipDelegateStat lastSipDelegateStat : new ArrayList(this.mLastSipDelegateStatList)) {
                if (lastSipDelegateStat.isDestroyed()) {
                    lastSipDelegateStat.conclude(wallTimeMillis);
                    this.mLastSipDelegateStatList.remove(lastSipDelegateStat);
                }
            }
        }
    }

    private SipTransportFeatureTags getLastFeatureTags(int i) {
        if (this.mLastFeatureTagStatMap.containsKey(Integer.valueOf(i))) {
            return this.mLastFeatureTagStatMap.get(Integer.valueOf(i));
        }
        SipTransportFeatureTags sipTransportFeatureTags = new SipTransportFeatureTags(i);
        this.mLastFeatureTagStatMap.put(Integer.valueOf(i), sipTransportFeatureTags);
        return sipTransportFeatureTags;
    }

    /* access modifiers changed from: protected */
    @VisibleForTesting
    public int getSlotId(int i) {
        return SubscriptionManager.getPhoneId(i);
    }

    /* access modifiers changed from: protected */
    @VisibleForTesting
    public int getCarrierId(int i) {
        Phone phone = PhoneFactory.getPhone(SubscriptionManager.getPhoneId(i));
        if (phone != null) {
            return phone.getCarrierId();
        }
        return -1;
    }

    /* access modifiers changed from: protected */
    @VisibleForTesting
    public long getWallTimeMillis() {
        return System.currentTimeMillis();
    }

    /* access modifiers changed from: protected */
    @VisibleForTesting
    public void logd(String str) {
        Rlog.d(TAG, str);
    }

    /* access modifiers changed from: protected */
    @VisibleForTesting
    public int getSubId(int i) {
        int[] subId = SubscriptionManager.getSubId(i);
        if (subId == null || subId.length < 1) {
            return -1;
        }
        return subId[0];
    }

    @VisibleForTesting
    public int convertTagNameToValue(String str) {
        return FEATURE_TAGS.getOrDefault(str.trim().toLowerCase(), 1).intValue();
    }

    @VisibleForTesting
    public int convertServiceIdToValue(String str) {
        return SERVICE_IDS.getOrDefault(str.trim().toLowerCase(), 1).intValue();
    }

    @VisibleForTesting
    public int convertMessageTypeToValue(String str) {
        return MESSAGE_TYPE.getOrDefault(str.trim().toLowerCase(), 1).intValue();
    }

    @VisibleForTesting
    public int convertPresenceNotifyReason(String str) {
        return NOTIFY_REASONS.getOrDefault(str.trim().toLowerCase(), 1).intValue();
    }

    /* JADX WARNING: Code restructure failed: missing block: B:50:0x0511, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void printAllMetrics(java.io.PrintWriter r10) {
        /*
            r9 = this;
            monitor-enter(r9)
            com.android.internal.telephony.metrics.PersistAtomsStorage r0 = r9.mAtomsStorage     // Catch:{ all -> 0x0512 }
            if (r0 == 0) goto L_0x0510
            com.android.internal.telephony.nano.PersistAtomsProto$PersistAtoms r0 = r0.mAtoms     // Catch:{ all -> 0x0512 }
            if (r0 != 0) goto L_0x000b
            goto L_0x0510
        L_0x000b:
            com.android.internal.telephony.AndroidUtilIndentingPrintWriter r0 = new com.android.internal.telephony.AndroidUtilIndentingPrintWriter     // Catch:{ all -> 0x0512 }
            java.lang.String r1 = "  "
            r0.<init>(r10, r1)     // Catch:{ all -> 0x0512 }
            com.android.internal.telephony.metrics.PersistAtomsStorage r10 = r9.mAtomsStorage     // Catch:{ all -> 0x0512 }
            com.android.internal.telephony.nano.PersistAtomsProto$PersistAtoms r10 = r10.mAtoms     // Catch:{ all -> 0x0512 }
            java.lang.String r1 = "RcsStats Metrics Proto: "
            r0.println(r1)     // Catch:{ all -> 0x0512 }
            java.lang.String r1 = "------------------------------------------"
            r0.println(r1)     // Catch:{ all -> 0x0512 }
            java.lang.String r1 = "ImsRegistrationFeatureTagStats:"
            r0.println(r1)     // Catch:{ all -> 0x0512 }
            r0.increaseIndent()     // Catch:{ all -> 0x0512 }
            com.android.internal.telephony.nano.PersistAtomsProto$ImsRegistrationFeatureTagStats[] r1 = r10.imsRegistrationFeatureTagStats     // Catch:{ all -> 0x0512 }
            int r2 = r1.length     // Catch:{ all -> 0x0512 }
            r3 = 0
            r4 = r3
        L_0x002d:
            if (r4 >= r2) goto L_0x0072
            r5 = r1[r4]     // Catch:{ all -> 0x0512 }
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x0512 }
            r6.<init>()     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.carrierId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] ["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.slotId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] Feature Tag Name = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.featureTagName     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Registration Tech = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.registrationTech     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Registered Duration (ms) = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            long r7 = r5.registeredMillis     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r5 = r6.toString()     // Catch:{ all -> 0x0512 }
            r0.println(r5)     // Catch:{ all -> 0x0512 }
            int r4 = r4 + 1
            goto L_0x002d
        L_0x0072:
            r0.decreaseIndent()     // Catch:{ all -> 0x0512 }
            java.lang.String r1 = "RcsClientProvisioningStats:"
            r0.println(r1)     // Catch:{ all -> 0x0512 }
            r0.increaseIndent()     // Catch:{ all -> 0x0512 }
            com.android.internal.telephony.nano.PersistAtomsProto$RcsClientProvisioningStats[] r1 = r10.rcsClientProvisioningStats     // Catch:{ all -> 0x0512 }
            int r2 = r1.length     // Catch:{ all -> 0x0512 }
            r4 = r3
        L_0x0081:
            if (r4 >= r2) goto L_0x00bc
            r5 = r1[r4]     // Catch:{ all -> 0x0512 }
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x0512 }
            r6.<init>()     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.carrierId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] ["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.slotId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] Event = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.event     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Count = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r5 = r5.count     // Catch:{ all -> 0x0512 }
            r6.append(r5)     // Catch:{ all -> 0x0512 }
            java.lang.String r5 = r6.toString()     // Catch:{ all -> 0x0512 }
            r0.println(r5)     // Catch:{ all -> 0x0512 }
            int r4 = r4 + 1
            goto L_0x0081
        L_0x00bc:
            r0.decreaseIndent()     // Catch:{ all -> 0x0512 }
            java.lang.String r1 = "RcsAcsProvisioningStats:"
            r0.println(r1)     // Catch:{ all -> 0x0512 }
            r0.increaseIndent()     // Catch:{ all -> 0x0512 }
            com.android.internal.telephony.nano.PersistAtomsProto$RcsAcsProvisioningStats[] r1 = r10.rcsAcsProvisioningStats     // Catch:{ all -> 0x0512 }
            int r2 = r1.length     // Catch:{ all -> 0x0512 }
            r4 = r3
        L_0x00cb:
            if (r4 >= r2) goto L_0x0124
            r5 = r1[r4]     // Catch:{ all -> 0x0512 }
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x0512 }
            r6.<init>()     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.carrierId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] ["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.slotId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] Response Code = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.responseCode     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Response Type = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.responseType     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Single Registration Enabled = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            boolean r7 = r5.isSingleRegistrationEnabled     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Count = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.count     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", State Timer (ms) = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            long r7 = r5.stateTimerMillis     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r5 = r6.toString()     // Catch:{ all -> 0x0512 }
            r0.println(r5)     // Catch:{ all -> 0x0512 }
            int r4 = r4 + 1
            goto L_0x00cb
        L_0x0124:
            r0.decreaseIndent()     // Catch:{ all -> 0x0512 }
            java.lang.String r1 = "SipDelegateStats:"
            r0.println(r1)     // Catch:{ all -> 0x0512 }
            r0.increaseIndent()     // Catch:{ all -> 0x0512 }
            com.android.internal.telephony.nano.PersistAtomsProto$SipDelegateStats[] r1 = r10.sipDelegateStats     // Catch:{ all -> 0x0512 }
            int r2 = r1.length     // Catch:{ all -> 0x0512 }
            r4 = r3
        L_0x0133:
            if (r4 >= r2) goto L_0x0178
            r5 = r1[r4]     // Catch:{ all -> 0x0512 }
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x0512 }
            r6.<init>()     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.carrierId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] ["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.slotId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] ["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.dimension     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] Destroy Reason = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.destroyReason     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Uptime (ms) = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            long r7 = r5.uptimeMillis     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r5 = r6.toString()     // Catch:{ all -> 0x0512 }
            r0.println(r5)     // Catch:{ all -> 0x0512 }
            int r4 = r4 + 1
            goto L_0x0133
        L_0x0178:
            r0.decreaseIndent()     // Catch:{ all -> 0x0512 }
            java.lang.String r1 = "SipTransportFeatureTagStats:"
            r0.println(r1)     // Catch:{ all -> 0x0512 }
            r0.increaseIndent()     // Catch:{ all -> 0x0512 }
            com.android.internal.telephony.nano.PersistAtomsProto$SipTransportFeatureTagStats[] r1 = r10.sipTransportFeatureTagStats     // Catch:{ all -> 0x0512 }
            int r2 = r1.length     // Catch:{ all -> 0x0512 }
            r4 = r3
        L_0x0187:
            if (r4 >= r2) goto L_0x01d6
            r5 = r1[r4]     // Catch:{ all -> 0x0512 }
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x0512 }
            r6.<init>()     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.carrierId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] ["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.slotId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] Feature Tag Name = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.featureTagName     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Denied Reason = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.sipTransportDeniedReason     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Deregistered Reason = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.sipTransportDeregisteredReason     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Associated Time (ms) = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            long r7 = r5.associatedMillis     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r5 = r6.toString()     // Catch:{ all -> 0x0512 }
            r0.println(r5)     // Catch:{ all -> 0x0512 }
            int r4 = r4 + 1
            goto L_0x0187
        L_0x01d6:
            r0.decreaseIndent()     // Catch:{ all -> 0x0512 }
            java.lang.String r1 = "SipMessageResponse:"
            r0.println(r1)     // Catch:{ all -> 0x0512 }
            r0.increaseIndent()     // Catch:{ all -> 0x0512 }
            com.android.internal.telephony.nano.PersistAtomsProto$SipMessageResponse[] r1 = r10.sipMessageResponse     // Catch:{ all -> 0x0512 }
            int r2 = r1.length     // Catch:{ all -> 0x0512 }
            r4 = r3
        L_0x01e5:
            if (r4 >= r2) goto L_0x023e
            r5 = r1[r4]     // Catch:{ all -> 0x0512 }
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x0512 }
            r6.<init>()     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.carrierId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] ["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.slotId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] Message Method = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.sipMessageMethod     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Response = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.sipMessageResponse     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Direction = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.sipMessageDirection     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Error = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.messageError     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Count = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r5 = r5.count     // Catch:{ all -> 0x0512 }
            r6.append(r5)     // Catch:{ all -> 0x0512 }
            java.lang.String r5 = r6.toString()     // Catch:{ all -> 0x0512 }
            r0.println(r5)     // Catch:{ all -> 0x0512 }
            int r4 = r4 + 1
            goto L_0x01e5
        L_0x023e:
            r0.decreaseIndent()     // Catch:{ all -> 0x0512 }
            java.lang.String r1 = "SipTransportSession:"
            r0.println(r1)     // Catch:{ all -> 0x0512 }
            r0.increaseIndent()     // Catch:{ all -> 0x0512 }
            com.android.internal.telephony.nano.PersistAtomsProto$SipTransportSession[] r1 = r10.sipTransportSession     // Catch:{ all -> 0x0512 }
            int r2 = r1.length     // Catch:{ all -> 0x0512 }
            r4 = r3
        L_0x024d:
            if (r4 >= r2) goto L_0x02a6
            r5 = r1[r4]     // Catch:{ all -> 0x0512 }
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x0512 }
            r6.<init>()     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.carrierId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] ["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.slotId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] Session Method = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.sessionMethod     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Direction = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.sipMessageDirection     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Response = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.sipResponse     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Count = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.sessionCount     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", GraceFully Count = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r5 = r5.endedGracefullyCount     // Catch:{ all -> 0x0512 }
            r6.append(r5)     // Catch:{ all -> 0x0512 }
            java.lang.String r5 = r6.toString()     // Catch:{ all -> 0x0512 }
            r0.println(r5)     // Catch:{ all -> 0x0512 }
            int r4 = r4 + 1
            goto L_0x024d
        L_0x02a6:
            r0.decreaseIndent()     // Catch:{ all -> 0x0512 }
            java.lang.String r1 = "ImsDedicatedBearerListenerEvent:"
            r0.println(r1)     // Catch:{ all -> 0x0512 }
            r0.increaseIndent()     // Catch:{ all -> 0x0512 }
            com.android.internal.telephony.nano.PersistAtomsProto$ImsDedicatedBearerListenerEvent[] r1 = r10.imsDedicatedBearerListenerEvent     // Catch:{ all -> 0x0512 }
            int r2 = r1.length     // Catch:{ all -> 0x0512 }
            r4 = r3
        L_0x02b5:
            if (r4 >= r2) goto L_0x0304
            r5 = r1[r4]     // Catch:{ all -> 0x0512 }
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x0512 }
            r6.<init>()     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.carrierId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] ["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.slotId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] RAT = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.ratAtEnd     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", QCI = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.qci     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Dedicated Bearer Established = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            boolean r7 = r5.dedicatedBearerEstablished     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Count = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r5 = r5.eventCount     // Catch:{ all -> 0x0512 }
            r6.append(r5)     // Catch:{ all -> 0x0512 }
            java.lang.String r5 = r6.toString()     // Catch:{ all -> 0x0512 }
            r0.println(r5)     // Catch:{ all -> 0x0512 }
            int r4 = r4 + 1
            goto L_0x02b5
        L_0x0304:
            r0.decreaseIndent()     // Catch:{ all -> 0x0512 }
            java.lang.String r1 = "ImsDedicatedBearerEvent:"
            r0.println(r1)     // Catch:{ all -> 0x0512 }
            r0.increaseIndent()     // Catch:{ all -> 0x0512 }
            com.android.internal.telephony.nano.PersistAtomsProto$ImsDedicatedBearerEvent[] r1 = r10.imsDedicatedBearerEvent     // Catch:{ all -> 0x0512 }
            int r2 = r1.length     // Catch:{ all -> 0x0512 }
            r4 = r3
        L_0x0313:
            if (r4 >= r2) goto L_0x0380
            r5 = r1[r4]     // Catch:{ all -> 0x0512 }
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x0512 }
            r6.<init>()     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.carrierId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] ["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.slotId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] RAT = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.ratAtEnd     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", QCI = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.qci     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Bearer State = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.bearerState     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Local Connection Info = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            boolean r7 = r5.localConnectionInfoReceived     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Remote Connection Info = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            boolean r7 = r5.remoteConnectionInfoReceived     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Listener Existence = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            boolean r7 = r5.hasListeners     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Count = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r5 = r5.count     // Catch:{ all -> 0x0512 }
            r6.append(r5)     // Catch:{ all -> 0x0512 }
            java.lang.String r5 = r6.toString()     // Catch:{ all -> 0x0512 }
            r0.println(r5)     // Catch:{ all -> 0x0512 }
            int r4 = r4 + 1
            goto L_0x0313
        L_0x0380:
            r0.decreaseIndent()     // Catch:{ all -> 0x0512 }
            java.lang.String r1 = "ImsRegistrationServiceDescStats:"
            r0.println(r1)     // Catch:{ all -> 0x0512 }
            r0.increaseIndent()     // Catch:{ all -> 0x0512 }
            com.android.internal.telephony.nano.PersistAtomsProto$ImsRegistrationServiceDescStats[] r1 = r10.imsRegistrationServiceDescStats     // Catch:{ all -> 0x0512 }
            int r2 = r1.length     // Catch:{ all -> 0x0512 }
            r4 = r3
        L_0x038f:
            if (r4 >= r2) goto L_0x03de
            r5 = r1[r4]     // Catch:{ all -> 0x0512 }
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x0512 }
            r6.<init>()     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.carrierId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] ["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.slotId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] Name = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.serviceIdName     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Version = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            float r7 = r5.serviceIdVersion     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Registration Tech = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.registrationTech     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Published Time (ms) = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            long r7 = r5.publishedMillis     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r5 = r6.toString()     // Catch:{ all -> 0x0512 }
            r0.println(r5)     // Catch:{ all -> 0x0512 }
            int r4 = r4 + 1
            goto L_0x038f
        L_0x03de:
            r0.decreaseIndent()     // Catch:{ all -> 0x0512 }
            java.lang.String r1 = "UceEventStats:"
            r0.println(r1)     // Catch:{ all -> 0x0512 }
            r0.increaseIndent()     // Catch:{ all -> 0x0512 }
            com.android.internal.telephony.nano.PersistAtomsProto$UceEventStats[] r1 = r10.uceEventStats     // Catch:{ all -> 0x0512 }
            int r2 = r1.length     // Catch:{ all -> 0x0512 }
            r4 = r3
        L_0x03ed:
            if (r4 >= r2) goto L_0x0446
            r5 = r1[r4]     // Catch:{ all -> 0x0512 }
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x0512 }
            r6.<init>()     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.carrierId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] ["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.slotId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] Type = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.type     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Successful = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            boolean r7 = r5.successful     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Code = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.commandCode     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Response = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.networkResponse     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Count = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r5 = r5.count     // Catch:{ all -> 0x0512 }
            r6.append(r5)     // Catch:{ all -> 0x0512 }
            java.lang.String r5 = r6.toString()     // Catch:{ all -> 0x0512 }
            r0.println(r5)     // Catch:{ all -> 0x0512 }
            int r4 = r4 + 1
            goto L_0x03ed
        L_0x0446:
            r0.decreaseIndent()     // Catch:{ all -> 0x0512 }
            java.lang.String r1 = "PresenceNotifyEvent:"
            r0.println(r1)     // Catch:{ all -> 0x0512 }
            r0.increaseIndent()     // Catch:{ all -> 0x0512 }
            com.android.internal.telephony.nano.PersistAtomsProto$PresenceNotifyEvent[] r1 = r10.presenceNotifyEvent     // Catch:{ all -> 0x0512 }
            int r2 = r1.length     // Catch:{ all -> 0x0512 }
            r4 = r3
        L_0x0455:
            if (r4 >= r2) goto L_0x04b8
            r5 = r1[r4]     // Catch:{ all -> 0x0512 }
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x0512 }
            r6.<init>()     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.carrierId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] ["
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.slotId     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = "] Reason = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.reason     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Body = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            boolean r7 = r5.contentBodyReceived     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", RCS Count = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.rcsCapsCount     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", MMTEL Count = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.mmtelCapsCount     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", NoCaps Count = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r7 = r5.noCapsCount     // Catch:{ all -> 0x0512 }
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            java.lang.String r7 = ", Count = "
            r6.append(r7)     // Catch:{ all -> 0x0512 }
            int r5 = r5.count     // Catch:{ all -> 0x0512 }
            r6.append(r5)     // Catch:{ all -> 0x0512 }
            java.lang.String r5 = r6.toString()     // Catch:{ all -> 0x0512 }
            r0.println(r5)     // Catch:{ all -> 0x0512 }
            int r4 = r4 + 1
            goto L_0x0455
        L_0x04b8:
            r0.decreaseIndent()     // Catch:{ all -> 0x0512 }
            java.lang.String r1 = "GbaEvent:"
            r0.println(r1)     // Catch:{ all -> 0x0512 }
            r0.increaseIndent()     // Catch:{ all -> 0x0512 }
            com.android.internal.telephony.nano.PersistAtomsProto$GbaEvent[] r10 = r10.gbaEvent     // Catch:{ all -> 0x0512 }
            int r1 = r10.length     // Catch:{ all -> 0x0512 }
        L_0x04c6:
            if (r3 >= r1) goto L_0x050b
            r2 = r10[r3]     // Catch:{ all -> 0x0512 }
            java.lang.StringBuilder r4 = new java.lang.StringBuilder     // Catch:{ all -> 0x0512 }
            r4.<init>()     // Catch:{ all -> 0x0512 }
            java.lang.String r5 = "["
            r4.append(r5)     // Catch:{ all -> 0x0512 }
            int r5 = r2.carrierId     // Catch:{ all -> 0x0512 }
            r4.append(r5)     // Catch:{ all -> 0x0512 }
            java.lang.String r5 = "] ["
            r4.append(r5)     // Catch:{ all -> 0x0512 }
            int r5 = r2.slotId     // Catch:{ all -> 0x0512 }
            r4.append(r5)     // Catch:{ all -> 0x0512 }
            java.lang.String r5 = "] Successful = "
            r4.append(r5)     // Catch:{ all -> 0x0512 }
            boolean r5 = r2.successful     // Catch:{ all -> 0x0512 }
            r4.append(r5)     // Catch:{ all -> 0x0512 }
            java.lang.String r5 = ", Fail Reason = "
            r4.append(r5)     // Catch:{ all -> 0x0512 }
            int r5 = r2.failedReason     // Catch:{ all -> 0x0512 }
            r4.append(r5)     // Catch:{ all -> 0x0512 }
            java.lang.String r5 = ", Count = "
            r4.append(r5)     // Catch:{ all -> 0x0512 }
            int r2 = r2.count     // Catch:{ all -> 0x0512 }
            r4.append(r2)     // Catch:{ all -> 0x0512 }
            java.lang.String r2 = r4.toString()     // Catch:{ all -> 0x0512 }
            r0.println(r2)     // Catch:{ all -> 0x0512 }
            int r3 = r3 + 1
            goto L_0x04c6
        L_0x050b:
            r0.decreaseIndent()     // Catch:{ all -> 0x0512 }
            monitor-exit(r9)
            return
        L_0x0510:
            monitor-exit(r9)
            return
        L_0x0512:
            r10 = move-exception
            monitor-exit(r9)
            throw r10
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.metrics.RcsStats.printAllMetrics(java.io.PrintWriter):void");
    }

    /* JADX WARNING: Code restructure failed: missing block: B:11:0x005b, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void reset() {
        /*
            r2 = this;
            monitor-enter(r2)
            com.android.internal.telephony.metrics.PersistAtomsStorage r0 = r2.mAtomsStorage     // Catch:{ all -> 0x005c }
            if (r0 == 0) goto L_0x005a
            com.android.internal.telephony.nano.PersistAtomsProto$PersistAtoms r0 = r0.mAtoms     // Catch:{ all -> 0x005c }
            if (r0 != 0) goto L_0x000a
            goto L_0x005a
        L_0x000a:
            com.android.internal.telephony.nano.PersistAtomsProto$ImsRegistrationFeatureTagStats[] r1 = com.android.internal.telephony.nano.PersistAtomsProto.ImsRegistrationFeatureTagStats.emptyArray()     // Catch:{ all -> 0x005c }
            r0.imsRegistrationFeatureTagStats = r1     // Catch:{ all -> 0x005c }
            com.android.internal.telephony.nano.PersistAtomsProto$RcsClientProvisioningStats[] r1 = com.android.internal.telephony.nano.PersistAtomsProto.RcsClientProvisioningStats.emptyArray()     // Catch:{ all -> 0x005c }
            r0.rcsClientProvisioningStats = r1     // Catch:{ all -> 0x005c }
            com.android.internal.telephony.nano.PersistAtomsProto$RcsAcsProvisioningStats[] r1 = com.android.internal.telephony.nano.PersistAtomsProto.RcsAcsProvisioningStats.emptyArray()     // Catch:{ all -> 0x005c }
            r0.rcsAcsProvisioningStats = r1     // Catch:{ all -> 0x005c }
            com.android.internal.telephony.nano.PersistAtomsProto$SipDelegateStats[] r1 = com.android.internal.telephony.nano.PersistAtomsProto.SipDelegateStats.emptyArray()     // Catch:{ all -> 0x005c }
            r0.sipDelegateStats = r1     // Catch:{ all -> 0x005c }
            com.android.internal.telephony.nano.PersistAtomsProto$SipTransportFeatureTagStats[] r1 = com.android.internal.telephony.nano.PersistAtomsProto.SipTransportFeatureTagStats.emptyArray()     // Catch:{ all -> 0x005c }
            r0.sipTransportFeatureTagStats = r1     // Catch:{ all -> 0x005c }
            com.android.internal.telephony.nano.PersistAtomsProto$SipMessageResponse[] r1 = com.android.internal.telephony.nano.PersistAtomsProto.SipMessageResponse.emptyArray()     // Catch:{ all -> 0x005c }
            r0.sipMessageResponse = r1     // Catch:{ all -> 0x005c }
            com.android.internal.telephony.nano.PersistAtomsProto$SipTransportSession[] r1 = com.android.internal.telephony.nano.PersistAtomsProto.SipTransportSession.emptyArray()     // Catch:{ all -> 0x005c }
            r0.sipTransportSession = r1     // Catch:{ all -> 0x005c }
            com.android.internal.telephony.nano.PersistAtomsProto$ImsDedicatedBearerListenerEvent[] r1 = com.android.internal.telephony.nano.PersistAtomsProto.ImsDedicatedBearerListenerEvent.emptyArray()     // Catch:{ all -> 0x005c }
            r0.imsDedicatedBearerListenerEvent = r1     // Catch:{ all -> 0x005c }
            com.android.internal.telephony.nano.PersistAtomsProto$ImsDedicatedBearerEvent[] r1 = com.android.internal.telephony.nano.PersistAtomsProto.ImsDedicatedBearerEvent.emptyArray()     // Catch:{ all -> 0x005c }
            r0.imsDedicatedBearerEvent = r1     // Catch:{ all -> 0x005c }
            com.android.internal.telephony.nano.PersistAtomsProto$ImsRegistrationServiceDescStats[] r1 = com.android.internal.telephony.nano.PersistAtomsProto.ImsRegistrationServiceDescStats.emptyArray()     // Catch:{ all -> 0x005c }
            r0.imsRegistrationServiceDescStats = r1     // Catch:{ all -> 0x005c }
            com.android.internal.telephony.nano.PersistAtomsProto$UceEventStats[] r1 = com.android.internal.telephony.nano.PersistAtomsProto.UceEventStats.emptyArray()     // Catch:{ all -> 0x005c }
            r0.uceEventStats = r1     // Catch:{ all -> 0x005c }
            com.android.internal.telephony.nano.PersistAtomsProto$PresenceNotifyEvent[] r1 = com.android.internal.telephony.nano.PersistAtomsProto.PresenceNotifyEvent.emptyArray()     // Catch:{ all -> 0x005c }
            r0.presenceNotifyEvent = r1     // Catch:{ all -> 0x005c }
            com.android.internal.telephony.nano.PersistAtomsProto$GbaEvent[] r1 = com.android.internal.telephony.nano.PersistAtomsProto.GbaEvent.emptyArray()     // Catch:{ all -> 0x005c }
            r0.gbaEvent = r1     // Catch:{ all -> 0x005c }
            monitor-exit(r2)
            return
        L_0x005a:
            monitor-exit(r2)
            return
        L_0x005c:
            r0 = move-exception
            monitor-exit(r2)
            throw r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.metrics.RcsStats.reset():void");
    }

    public String buildLog() {
        return Base64.encodeToString(MessageNano.toByteArray(buildProto()), 0);
    }

    public PersistAtomsProto.PersistAtoms buildProto() {
        PersistAtomsProto.PersistAtoms persistAtoms = new PersistAtomsProto.PersistAtoms();
        PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtomsStorage.mAtoms;
        PersistAtomsProto.ImsRegistrationFeatureTagStats[] imsRegistrationFeatureTagStatsArr = persistAtoms2.imsRegistrationFeatureTagStats;
        persistAtoms.imsRegistrationFeatureTagStats = (PersistAtomsProto.ImsRegistrationFeatureTagStats[]) Arrays.copyOf(imsRegistrationFeatureTagStatsArr, imsRegistrationFeatureTagStatsArr.length);
        PersistAtomsProto.RcsClientProvisioningStats[] rcsClientProvisioningStatsArr = persistAtoms2.rcsClientProvisioningStats;
        persistAtoms.rcsClientProvisioningStats = (PersistAtomsProto.RcsClientProvisioningStats[]) Arrays.copyOf(rcsClientProvisioningStatsArr, rcsClientProvisioningStatsArr.length);
        PersistAtomsProto.RcsAcsProvisioningStats[] rcsAcsProvisioningStatsArr = persistAtoms2.rcsAcsProvisioningStats;
        persistAtoms.rcsAcsProvisioningStats = (PersistAtomsProto.RcsAcsProvisioningStats[]) Arrays.copyOf(rcsAcsProvisioningStatsArr, rcsAcsProvisioningStatsArr.length);
        PersistAtomsProto.SipDelegateStats[] sipDelegateStatsArr = persistAtoms2.sipDelegateStats;
        persistAtoms.sipDelegateStats = (PersistAtomsProto.SipDelegateStats[]) Arrays.copyOf(sipDelegateStatsArr, sipDelegateStatsArr.length);
        PersistAtomsProto.SipTransportFeatureTagStats[] sipTransportFeatureTagStatsArr = persistAtoms2.sipTransportFeatureTagStats;
        persistAtoms.sipTransportFeatureTagStats = (PersistAtomsProto.SipTransportFeatureTagStats[]) Arrays.copyOf(sipTransportFeatureTagStatsArr, sipTransportFeatureTagStatsArr.length);
        PersistAtomsProto.SipMessageResponse[] sipMessageResponseArr = persistAtoms2.sipMessageResponse;
        persistAtoms.sipMessageResponse = (PersistAtomsProto.SipMessageResponse[]) Arrays.copyOf(sipMessageResponseArr, sipMessageResponseArr.length);
        PersistAtomsProto.SipTransportSession[] sipTransportSessionArr = persistAtoms2.sipTransportSession;
        persistAtoms.sipTransportSession = (PersistAtomsProto.SipTransportSession[]) Arrays.copyOf(sipTransportSessionArr, sipTransportSessionArr.length);
        PersistAtomsProto.ImsDedicatedBearerListenerEvent[] imsDedicatedBearerListenerEventArr = persistAtoms2.imsDedicatedBearerListenerEvent;
        persistAtoms.imsDedicatedBearerListenerEvent = (PersistAtomsProto.ImsDedicatedBearerListenerEvent[]) Arrays.copyOf(imsDedicatedBearerListenerEventArr, imsDedicatedBearerListenerEventArr.length);
        PersistAtomsProto.ImsDedicatedBearerEvent[] imsDedicatedBearerEventArr = persistAtoms2.imsDedicatedBearerEvent;
        persistAtoms.imsDedicatedBearerEvent = (PersistAtomsProto.ImsDedicatedBearerEvent[]) Arrays.copyOf(imsDedicatedBearerEventArr, imsDedicatedBearerEventArr.length);
        PersistAtomsProto.ImsRegistrationServiceDescStats[] imsRegistrationServiceDescStatsArr = persistAtoms2.imsRegistrationServiceDescStats;
        persistAtoms.imsRegistrationServiceDescStats = (PersistAtomsProto.ImsRegistrationServiceDescStats[]) Arrays.copyOf(imsRegistrationServiceDescStatsArr, imsRegistrationServiceDescStatsArr.length);
        PersistAtomsProto.UceEventStats[] uceEventStatsArr = persistAtoms2.uceEventStats;
        persistAtoms.uceEventStats = (PersistAtomsProto.UceEventStats[]) Arrays.copyOf(uceEventStatsArr, uceEventStatsArr.length);
        PersistAtomsProto.PresenceNotifyEvent[] presenceNotifyEventArr = persistAtoms2.presenceNotifyEvent;
        persistAtoms.presenceNotifyEvent = (PersistAtomsProto.PresenceNotifyEvent[]) Arrays.copyOf(presenceNotifyEventArr, presenceNotifyEventArr.length);
        PersistAtomsProto.GbaEvent[] gbaEventArr = persistAtoms2.gbaEvent;
        persistAtoms.gbaEvent = (PersistAtomsProto.GbaEvent[]) Arrays.copyOf(gbaEventArr, gbaEventArr.length);
        return persistAtoms;
    }
}
