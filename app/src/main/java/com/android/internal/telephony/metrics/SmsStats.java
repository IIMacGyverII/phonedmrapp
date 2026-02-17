package com.android.internal.telephony.metrics;

import android.telephony.ServiceState;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.ServiceStateTracker;
import com.android.internal.telephony.nano.PersistAtomsProto;
import com.android.telephony.Rlog;
import java.util.Random;

public class SmsStats {
    private static final int NO_NETWORK_ERROR_3GPP = 331;
    private static final int NO_NETWORK_ERROR_3GPP2 = 66;
    private static final Random RANDOM = new Random();
    private static final String TAG = "SmsStats";
    private final PersistAtomsStorage mAtomsStorage = PhoneFactory.getMetricsCollector().getAtomsStorage();
    private final Phone mPhone;

    private static int getIncomingSmsError(int i) {
        if (i == -1 || i == 1) {
            return 0;
        }
        if (i != 3) {
            return i != 4 ? 1 : 3;
        }
        return 2;
    }

    private static int getIncomingSmsError(boolean z) {
        return z ? 0 : 1;
    }

    private static int getOutgoingSmsError(int i) {
        int i2 = 1;
        if (i != 1) {
            i2 = 2;
            if (i != 2) {
                i2 = 3;
                if (i != 3) {
                    i2 = 4;
                    if (i != 4) {
                        return 0;
                    }
                }
            }
        }
        return i2;
    }

    private static int getSmsFormat(boolean z) {
        return z ? 2 : 1;
    }

    private int getSmsTech(boolean z, boolean z2) {
        if (z) {
            return 3;
        }
        return z2 ? 2 : 1;
    }

    public SmsStats(Phone phone) {
        this.mPhone = phone;
    }

    public void onDroppedIncomingMultipartSms(boolean z, int i, int i2) {
        PersistAtomsProto.IncomingSms incomingDefaultProto = getIncomingDefaultProto(z, 0);
        incomingDefaultProto.smsTech = 0;
        incomingDefaultProto.rat = 0;
        incomingDefaultProto.error = 1;
        incomingDefaultProto.totalParts = i2;
        incomingDefaultProto.receivedParts = i;
        this.mAtomsStorage.addIncomingSms(incomingDefaultProto);
    }

    public void onIncomingSmsVoicemail(boolean z, int i) {
        PersistAtomsProto.IncomingSms incomingDefaultProto = getIncomingDefaultProto(z, i);
        incomingDefaultProto.smsType = 2;
        this.mAtomsStorage.addIncomingSms(incomingDefaultProto);
    }

    public void onIncomingSmsTypeZero(int i) {
        PersistAtomsProto.IncomingSms incomingDefaultProto = getIncomingDefaultProto(false, i);
        incomingDefaultProto.smsType = 3;
        this.mAtomsStorage.addIncomingSms(incomingDefaultProto);
    }

    public void onIncomingSmsPP(int i, boolean z) {
        PersistAtomsProto.IncomingSms incomingDefaultProto = getIncomingDefaultProto(false, i);
        incomingDefaultProto.smsType = 1;
        incomingDefaultProto.error = getIncomingSmsError(z);
        this.mAtomsStorage.addIncomingSms(incomingDefaultProto);
    }

    public void onIncomingSmsSuccess(boolean z, int i, int i2, boolean z2, long j) {
        PersistAtomsProto.IncomingSms incomingDefaultProto = getIncomingDefaultProto(z, i);
        incomingDefaultProto.totalParts = i2;
        incomingDefaultProto.receivedParts = i2;
        incomingDefaultProto.blocked = z2;
        incomingDefaultProto.messageId = j;
        this.mAtomsStorage.addIncomingSms(incomingDefaultProto);
    }

    public void onIncomingSmsError(boolean z, int i, int i2) {
        PersistAtomsProto.IncomingSms incomingDefaultProto = getIncomingDefaultProto(z, i);
        incomingDefaultProto.error = getIncomingSmsError(i2);
        this.mAtomsStorage.addIncomingSms(incomingDefaultProto);
    }

    public void onIncomingSmsWapPush(int i, int i2, int i3, long j) {
        PersistAtomsProto.IncomingSms incomingDefaultProto = getIncomingDefaultProto(false, i);
        incomingDefaultProto.smsType = 4;
        incomingDefaultProto.totalParts = i2;
        incomingDefaultProto.receivedParts = i2;
        incomingDefaultProto.error = getIncomingSmsError(i3);
        incomingDefaultProto.messageId = j;
        this.mAtomsStorage.addIncomingSms(incomingDefaultProto);
    }

    public void onOutgoingSms(boolean z, boolean z2, boolean z3, int i, long j, boolean z4, long j2) {
        onOutgoingSms(z, z2, z3, i, -1, j, z4, j2);
    }

    public void onOutgoingSms(boolean z, boolean z2, boolean z3, int i, int i2, long j, boolean z4, long j2) {
        int i3 = i;
        int i4 = i2;
        PersistAtomsProto.OutgoingSms outgoingDefaultProto = getOutgoingDefaultProto(z2, z, j, z4, j2);
        if (z) {
            outgoingDefaultProto.errorCode = i3;
            if (z3) {
                outgoingDefaultProto.sendResult = 4;
            } else if (i3 == 101) {
                outgoingDefaultProto.sendResult = 3;
            } else if (i3 != 0) {
                outgoingDefaultProto.sendResult = 2;
            }
        } else {
            if (i3 == 101) {
                outgoingDefaultProto.sendResult = 3;
            } else if (i3 != 0) {
                outgoingDefaultProto.sendResult = 2;
            }
            outgoingDefaultProto.errorCode = i4;
            if (i3 == 100 && i4 == -1) {
                outgoingDefaultProto.errorCode = z2 ? 66 : NO_NETWORK_ERROR_3GPP;
            }
        }
        this.mAtomsStorage.addOutgoingSms(outgoingDefaultProto);
    }

    private PersistAtomsProto.IncomingSms getIncomingDefaultProto(boolean z, int i) {
        PersistAtomsProto.IncomingSms incomingSms = new PersistAtomsProto.IncomingSms();
        incomingSms.smsFormat = getSmsFormat(z);
        incomingSms.smsTech = getSmsTech(i, z);
        incomingSms.rat = getRat(i);
        incomingSms.smsType = 0;
        incomingSms.totalParts = 1;
        incomingSms.receivedParts = 1;
        incomingSms.blocked = false;
        incomingSms.error = 0;
        incomingSms.isRoaming = getIsRoaming();
        incomingSms.simSlotIndex = getPhoneId();
        incomingSms.isMultiSim = SimSlotState.isMultiSim();
        incomingSms.isEsim = SimSlotState.isEsim(getPhoneId());
        incomingSms.carrierId = getCarrierId();
        incomingSms.messageId = RANDOM.nextLong();
        return incomingSms;
    }

    private PersistAtomsProto.OutgoingSms getOutgoingDefaultProto(boolean z, boolean z2, long j, boolean z3, long j2) {
        PersistAtomsProto.OutgoingSms outgoingSms = new PersistAtomsProto.OutgoingSms();
        outgoingSms.smsFormat = getSmsFormat(z);
        outgoingSms.smsTech = getSmsTech(z2, z);
        outgoingSms.rat = getRat(z2);
        outgoingSms.sendResult = 1;
        outgoingSms.errorCode = z2 ? 0 : -1;
        outgoingSms.isRoaming = getIsRoaming();
        outgoingSms.isFromDefaultApp = z3;
        outgoingSms.simSlotIndex = getPhoneId();
        outgoingSms.isMultiSim = SimSlotState.isMultiSim();
        outgoingSms.isEsim = SimSlotState.isEsim(getPhoneId());
        outgoingSms.carrierId = getCarrierId();
        if (j == 0) {
            j = RANDOM.nextLong();
        }
        outgoingSms.messageId = j;
        outgoingSms.retryId = 0;
        outgoingSms.intervalMillis = j2;
        return outgoingSms;
    }

    private int getSmsTech(int i, boolean z) {
        boolean z2 = false;
        if (i == 2) {
            return 0;
        }
        if (i == 1) {
            z2 = true;
        }
        return getSmsTech(z2, z);
    }

    private int getPhoneId() {
        Phone phone = this.mPhone;
        if (phone.getPhoneType() == 5) {
            phone = this.mPhone.getDefaultPhone();
        }
        return phone.getPhoneId();
    }

    private ServiceState getServiceState() {
        Phone phone = this.mPhone;
        if (phone.getPhoneType() == 5) {
            phone = this.mPhone.getDefaultPhone();
        }
        ServiceStateTracker serviceStateTracker = phone.getServiceStateTracker();
        if (serviceStateTracker != null) {
            return serviceStateTracker.getServiceState();
        }
        return null;
    }

    private int getRat(int i) {
        boolean z = false;
        if (i == 2) {
            return 0;
        }
        if (i == 1) {
            z = true;
        }
        return getRat(z);
    }

    private int getRat(boolean z) {
        if (z && this.mPhone.getImsRegistrationTech() == 1) {
            return 18;
        }
        ServiceState serviceState = getServiceState();
        if (serviceState != null) {
            return serviceState.getVoiceNetworkType();
        }
        return 0;
    }

    private boolean getIsRoaming() {
        ServiceState serviceState = getServiceState();
        if (serviceState != null) {
            return serviceState.getRoaming();
        }
        return false;
    }

    private int getCarrierId() {
        Phone phone = this.mPhone;
        if (phone.getPhoneType() == 5) {
            phone = this.mPhone.getDefaultPhone();
        }
        return phone.getCarrierId();
    }

    private void loge(String str, Object... objArr) {
        String str2 = TAG;
        Rlog.e(str2, "[" + this.mPhone.getPhoneId() + "]" + String.format(str, objArr));
    }
}
