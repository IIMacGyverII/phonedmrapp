package com.android.internal.telephony.data;

import android.net.LinkAddress;
import android.net.NetworkAgent;
import android.net.QosFilter;
import android.os.Handler;
import android.telephony.data.EpsBearerQosSessionAttributes;
import android.telephony.data.EpsQos;
import android.telephony.data.NrQos;
import android.telephony.data.NrQosSessionAttributes;
import android.telephony.data.QosBearerFilter;
import android.telephony.data.QosBearerSession;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.data.TelephonyNetworkAgent;
import com.android.internal.telephony.metrics.RcsStats;
import com.android.telephony.Rlog;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class QosCallbackTracker extends Handler {
    private static final int DEDICATED_BEARER_EVENT_STATE_ADDED = 1;
    private static final int DEDICATED_BEARER_EVENT_STATE_DELETED = 3;
    private static final int DEDICATED_BEARER_EVENT_STATE_MODIFIED = 2;
    private static final int DEDICATED_BEARER_EVENT_STATE_NONE = 0;
    private final Map<Integer, IFilter> mCallbacksToFilter = new HashMap();
    private final String mLogTag;
    private final NotifyQosSessionInterface mNetworkAgent;
    private final int mPhoneId;
    private final Map<Integer, QosBearerSession> mQosBearerSessions = new HashMap();
    private final RcsStats mRcsStats;

    public interface IFilter {
        boolean matchesLocalAddress(InetAddress inetAddress, int i, int i2);

        boolean matchesRemoteAddress(InetAddress inetAddress, int i, int i2);
    }

    public QosCallbackTracker(NotifyQosSessionInterface notifyQosSessionInterface, Phone phone) {
        this.mNetworkAgent = notifyQosSessionInterface;
        this.mPhoneId = phone.getPhoneId();
        this.mRcsStats = RcsStats.getInstance();
        this.mLogTag = "QOSCT-" + ((NetworkAgent) notifyQosSessionInterface).getNetwork().getNetId();
        if (phone.isUsingNewDataStack()) {
            ((TelephonyNetworkAgent) notifyQosSessionInterface).registerCallback(new TelephonyNetworkAgent.TelephonyNetworkAgentCallback(new QosCallbackTracker$$ExternalSyntheticLambda3(this)) {
                public void onQosCallbackUnregistered(int i) {
                }

                public void onQosCallbackRegistered(int i, final QosFilter qosFilter) {
                    QosCallbackTracker.this.addFilter(i, new IFilter() {
                        public boolean matchesLocalAddress(InetAddress inetAddress, int i, int i2) {
                            return qosFilter.matchesLocalAddress(inetAddress, i, i2);
                        }

                        public boolean matchesRemoteAddress(InetAddress inetAddress, int i, int i2) {
                            return qosFilter.matchesRemoteAddress(inetAddress, i, i2);
                        }
                    });
                }
            });
        }
    }

    public void addFilter(int i, IFilter iFilter) {
        post(new QosCallbackTracker$$ExternalSyntheticLambda1(this, i, iFilter));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$addFilter$0(int i, IFilter iFilter) {
        log("addFilter: callbackId=" + i);
        this.mCallbacksToFilter.put(Integer.valueOf(i), iFilter);
        for (QosBearerSession next : this.mQosBearerSessions.values()) {
            if (doFiltersMatch(next, iFilter)) {
                sendSessionAvailable(i, next, iFilter);
                notifyMetricDedicatedBearerListenerAdded(i, next);
            }
        }
    }

    public void removeFilter(int i) {
        post(new QosCallbackTracker$$ExternalSyntheticLambda2(this, i));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$removeFilter$1(int i) {
        log("removeFilter: callbackId=" + i);
        this.mCallbacksToFilter.remove(Integer.valueOf(i));
        notifyMetricDedicatedBearerListenerRemoved(i);
    }

    public void updateSessions(List<QosBearerSession> list) {
        post(new QosCallbackTracker$$ExternalSyntheticLambda0(this, list));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$updateSessions$2(List list) {
        log("updateSessions: sessions size=" + list.size());
        ArrayList<QosBearerSession> arrayList = new ArrayList<>();
        HashMap hashMap = new HashMap();
        HashSet hashSet = new HashSet();
        Iterator it = list.iterator();
        int i = 0;
        while (it.hasNext()) {
            QosBearerSession qosBearerSession = (QosBearerSession) it.next();
            int qosBearerSessionId = qosBearerSession.getQosBearerSessionId();
            hashMap.put(Integer.valueOf(qosBearerSessionId), qosBearerSession);
            QosBearerSession qosBearerSession2 = this.mQosBearerSessions.get(Integer.valueOf(qosBearerSessionId));
            for (Integer intValue : this.mCallbacksToFilter.keySet()) {
                int intValue2 = intValue.intValue();
                IFilter iFilter = this.mCallbacksToFilter.get(Integer.valueOf(intValue2));
                boolean doFiltersMatch = doFiltersMatch(qosBearerSession, iFilter);
                boolean z = qosBearerSession2 != null && doFiltersMatch(qosBearerSession2, iFilter);
                if (!z && doFiltersMatch) {
                    sendSessionAvailable(intValue2, qosBearerSession, iFilter);
                    i = 1;
                }
                if (z && doFiltersMatch && !qosBearerSession.getQos().equals(qosBearerSession2.getQos())) {
                    sendSessionAvailable(intValue2, qosBearerSession, iFilter);
                    i = 2;
                }
                if (!hashSet.contains(Integer.valueOf(qosBearerSessionId)) && doFiltersMatch) {
                    notifyMetricDedicatedBearerEvent(qosBearerSession, i, true);
                    hashSet.add(Integer.valueOf(qosBearerSessionId));
                }
            }
            if (!hashSet.contains(Integer.valueOf(qosBearerSessionId))) {
                notifyMetricDedicatedBearerEvent(qosBearerSession, 1, false);
                hashSet.add(Integer.valueOf(qosBearerSessionId));
                i = 1;
            }
            arrayList.add(qosBearerSession);
        }
        ArrayList<Integer> arrayList2 = new ArrayList<>();
        hashSet.clear();
        for (QosBearerSession next : this.mQosBearerSessions.values()) {
            int qosBearerSessionId2 = next.getQosBearerSessionId();
            if (!hashMap.containsKey(Integer.valueOf(qosBearerSessionId2))) {
                for (Integer intValue3 : this.mCallbacksToFilter.keySet()) {
                    int intValue4 = intValue3.intValue();
                    if (doFiltersMatch(next, this.mCallbacksToFilter.get(Integer.valueOf(intValue4)))) {
                        sendSessionLost(intValue4, next);
                        notifyMetricDedicatedBearerEvent(next, 3, true);
                        hashSet.add(Integer.valueOf(qosBearerSessionId2));
                    }
                }
                arrayList2.add(Integer.valueOf(qosBearerSessionId2));
                if (!hashSet.contains(Integer.valueOf(qosBearerSessionId2))) {
                    notifyMetricDedicatedBearerEvent(next, 3, false);
                    hashSet.add(Integer.valueOf(qosBearerSessionId2));
                }
            }
        }
        for (QosBearerSession qosBearerSession3 : arrayList) {
            this.mQosBearerSessions.put(Integer.valueOf(qosBearerSession3.getQosBearerSessionId()), qosBearerSession3);
        }
        for (Integer intValue5 : arrayList2) {
            this.mQosBearerSessions.remove(Integer.valueOf(intValue5.intValue()));
        }
    }

    private boolean doFiltersMatch(QosBearerSession qosBearerSession, IFilter iFilter) {
        return getMatchingQosBearerFilter(qosBearerSession, iFilter) != null;
    }

    private boolean matchesByLocalAddress(QosBearerFilter qosBearerFilter, IFilter iFilter) {
        if (qosBearerFilter.getLocalPortRange() == null) {
            return false;
        }
        Iterator it = qosBearerFilter.getLocalAddresses().iterator();
        if (it.hasNext()) {
            return iFilter.matchesLocalAddress(((LinkAddress) it.next()).getAddress(), qosBearerFilter.getLocalPortRange().getStart(), qosBearerFilter.getLocalPortRange().getEnd());
        }
        return false;
    }

    private boolean matchesByRemoteAddress(QosBearerFilter qosBearerFilter, IFilter iFilter) {
        if (qosBearerFilter.getRemotePortRange() == null) {
            return false;
        }
        Iterator it = qosBearerFilter.getRemoteAddresses().iterator();
        if (it.hasNext()) {
            return iFilter.matchesRemoteAddress(((LinkAddress) it.next()).getAddress(), qosBearerFilter.getRemotePortRange().getStart(), qosBearerFilter.getRemotePortRange().getEnd());
        }
        return false;
    }

    private boolean matchesByRemoteAndLocalAddress(QosBearerFilter qosBearerFilter, IFilter iFilter) {
        if (qosBearerFilter.getLocalPortRange() == null || qosBearerFilter.getRemotePortRange() == null) {
            return false;
        }
        for (LinkAddress linkAddress : qosBearerFilter.getRemoteAddresses()) {
            Iterator it = qosBearerFilter.getLocalAddresses().iterator();
            if (it.hasNext()) {
                LinkAddress linkAddress2 = (LinkAddress) it.next();
                if (!iFilter.matchesRemoteAddress(linkAddress.getAddress(), qosBearerFilter.getRemotePortRange().getStart(), qosBearerFilter.getRemotePortRange().getEnd()) || !iFilter.matchesLocalAddress(linkAddress2.getAddress(), qosBearerFilter.getLocalPortRange().getStart(), qosBearerFilter.getLocalPortRange().getEnd())) {
                    return false;
                }
                return true;
            }
        }
        return false;
    }

    private QosBearerFilter getFilterByPrecedence(QosBearerFilter qosBearerFilter, QosBearerFilter qosBearerFilter2) {
        return (qosBearerFilter == null || qosBearerFilter2.getPrecedence() < qosBearerFilter.getPrecedence()) ? qosBearerFilter2 : qosBearerFilter;
    }

    private QosBearerFilter getMatchingQosBearerFilter(QosBearerSession qosBearerSession, IFilter iFilter) {
        QosBearerFilter qosBearerFilter = null;
        for (QosBearerFilter qosBearerFilter2 : qosBearerSession.getQosBearerFilterList()) {
            if (qosBearerFilter2.getLocalAddresses().isEmpty() || qosBearerFilter2.getRemoteAddresses().isEmpty() || qosBearerFilter2.getLocalPortRange() == null || !qosBearerFilter2.getLocalPortRange().isValid() || qosBearerFilter2.getRemotePortRange() == null || !qosBearerFilter2.getRemotePortRange().isValid()) {
                if (qosBearerFilter2.getRemoteAddresses().isEmpty() || qosBearerFilter2.getRemotePortRange() == null || !qosBearerFilter2.getRemotePortRange().isValid()) {
                    if (!qosBearerFilter2.getLocalAddresses().isEmpty() && qosBearerFilter2.getLocalPortRange() != null && qosBearerFilter2.getLocalPortRange().isValid() && matchesByLocalAddress(qosBearerFilter2, iFilter)) {
                        qosBearerFilter = getFilterByPrecedence(qosBearerFilter, qosBearerFilter2);
                    }
                } else if (matchesByRemoteAddress(qosBearerFilter2, iFilter)) {
                    qosBearerFilter = getFilterByPrecedence(qosBearerFilter, qosBearerFilter2);
                }
            } else if (matchesByRemoteAndLocalAddress(qosBearerFilter2, iFilter)) {
                qosBearerFilter = getFilterByPrecedence(qosBearerFilter, qosBearerFilter2);
            }
        }
        return qosBearerFilter;
    }

    private void sendSessionAvailable(int i, QosBearerSession qosBearerSession, IFilter iFilter) {
        int i2 = i;
        QosBearerFilter matchingQosBearerFilter = getMatchingQosBearerFilter(qosBearerSession, iFilter);
        ArrayList arrayList = new ArrayList();
        if (matchingQosBearerFilter.getRemoteAddresses().size() > 0 && matchingQosBearerFilter.getRemotePortRange() != null) {
            arrayList.add(new InetSocketAddress(((LinkAddress) matchingQosBearerFilter.getRemoteAddresses().get(0)).getAddress(), matchingQosBearerFilter.getRemotePortRange().getStart()));
        }
        if (qosBearerSession.getQos() instanceof EpsQos) {
            EpsQos qos = qosBearerSession.getQos();
            long guaranteedBitrateKbps = (long) qos.getUplinkBandwidth().getGuaranteedBitrateKbps();
            EpsBearerQosSessionAttributes epsBearerQosSessionAttributes = r4;
            EpsBearerQosSessionAttributes epsBearerQosSessionAttributes2 = new EpsBearerQosSessionAttributes(qos.getQci(), (long) qos.getUplinkBandwidth().getMaxBitrateKbps(), (long) qos.getDownlinkBandwidth().getMaxBitrateKbps(), (long) qos.getDownlinkBandwidth().getGuaranteedBitrateKbps(), guaranteedBitrateKbps, arrayList);
            this.mNetworkAgent.notifyQosSessionAvailable(i2, qosBearerSession.getQosBearerSessionId(), epsBearerQosSessionAttributes);
        } else {
            NrQos qos2 = qosBearerSession.getQos();
            long averagingWindow = (long) qos2.getAveragingWindow();
            NrQosSessionAttributes nrQosSessionAttributes = r4;
            NrQosSessionAttributes nrQosSessionAttributes2 = new NrQosSessionAttributes(qos2.get5Qi(), qos2.getQfi(), (long) qos2.getUplinkBandwidth().getMaxBitrateKbps(), (long) qos2.getDownlinkBandwidth().getMaxBitrateKbps(), (long) qos2.getDownlinkBandwidth().getGuaranteedBitrateKbps(), (long) qos2.getUplinkBandwidth().getGuaranteedBitrateKbps(), averagingWindow, arrayList);
            this.mNetworkAgent.notifyQosSessionAvailable(i2, qosBearerSession.getQosBearerSessionId(), nrQosSessionAttributes);
        }
        notifyMetricDedicatedBearerListenerBearerUpdateSession(i, qosBearerSession);
        log("sendSessionAvailable, callbackId=" + i2);
    }

    private void sendSessionLost(int i, QosBearerSession qosBearerSession) {
        this.mNetworkAgent.notifyQosSessionLost(i, qosBearerSession.getQosBearerSessionId(), qosBearerSession.getQos() instanceof EpsQos ? 1 : 2);
        log("sendSessionLost, callbackId=" + i);
    }

    private void notifyMetricDedicatedBearerListenerAdded(int i, QosBearerSession qosBearerSession) {
        this.mRcsStats.onImsDedicatedBearerListenerAdded(i, this.mPhoneId, getRatInfoFromSessionInfo(qosBearerSession), getQCIFromSessionInfo(qosBearerSession));
    }

    private void notifyMetricDedicatedBearerListenerBearerUpdateSession(int i, QosBearerSession qosBearerSession) {
        this.mRcsStats.onImsDedicatedBearerListenerUpdateSession(i, this.mPhoneId, getRatInfoFromSessionInfo(qosBearerSession), getQCIFromSessionInfo(qosBearerSession), true);
    }

    private void notifyMetricDedicatedBearerListenerRemoved(int i) {
        this.mRcsStats.onImsDedicatedBearerListenerRemoved(i);
    }

    private int getQCIFromSessionInfo(QosBearerSession qosBearerSession) {
        if (qosBearerSession.getQos() instanceof EpsQos) {
            return qosBearerSession.getQos().getQci();
        }
        if (qosBearerSession.getQos() instanceof NrQos) {
            return qosBearerSession.getQos().get5Qi();
        }
        return 0;
    }

    private int getRatInfoFromSessionInfo(QosBearerSession qosBearerSession) {
        if (qosBearerSession.getQos() instanceof EpsQos) {
            return 13;
        }
        return qosBearerSession.getQos() instanceof NrQos ? 20 : 0;
    }

    private boolean doesLocalConnectionInfoExist(QosBearerSession qosBearerSession) {
        for (QosBearerFilter qosBearerFilter : qosBearerSession.getQosBearerFilterList()) {
            if (!qosBearerFilter.getLocalAddresses().isEmpty() && qosBearerFilter.getLocalPortRange() != null && qosBearerFilter.getLocalPortRange().isValid()) {
                return true;
            }
        }
        return false;
    }

    private boolean doesRemoteConnectionInfoExist(QosBearerSession qosBearerSession) {
        for (QosBearerFilter qosBearerFilter : qosBearerSession.getQosBearerFilterList()) {
            if (!qosBearerFilter.getRemoteAddresses().isEmpty() && qosBearerFilter.getRemotePortRange() != null && qosBearerFilter.getRemotePortRange().isValid()) {
                return true;
            }
        }
        return false;
    }

    private void notifyMetricDedicatedBearerEvent(QosBearerSession qosBearerSession, int i, boolean z) {
        this.mRcsStats.onImsDedicatedBearerEvent(this.mPhoneId, getRatInfoFromSessionInfo(qosBearerSession), getQCIFromSessionInfo(qosBearerSession), i, doesLocalConnectionInfoExist(qosBearerSession), doesRemoteConnectionInfoExist(qosBearerSession), z);
    }

    private void log(String str) {
        Rlog.d(this.mLogTag, str);
    }
}
