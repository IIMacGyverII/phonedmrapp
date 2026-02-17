package com.android.internal.telephony.metrics;

import android.content.ContentResolver;
import android.database.Cursor;
import android.net.Uri;
import android.provider.Telephony;
import android.telephony.PhoneNumberUtils;
import android.telephony.data.ApnSetting;
import android.telephony.ims.ImsManager;
import android.telephony.ims.ImsMmTelManager;
import android.text.TextUtils;
import com.android.internal.telephony.IccCard;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.SubscriptionController;
import com.android.internal.telephony.uicc.UiccController;
import com.android.internal.telephony.uicc.UiccSlot;
import java.util.Optional;

public class PerSimStatus {
    private static final long BITMASK_2G = 32843;
    public final boolean advancedCallingSettingEnabled;
    public final int carrierId;
    public final boolean dataRoamingEnabled;
    public final boolean disabled2g;
    public final int minimumVoltageClass;
    public final int phoneNumberSourceCarrier;
    public final int phoneNumberSourceIms;
    public final int phoneNumberSourceUicc;
    public final boolean pin1Enabled;
    public final long preferredNetworkType;
    public final int userModifiedApnTypes;
    public final int voWiFiModeSetting;
    public final int voWiFiRoamingModeSetting;
    public final boolean voWiFiSettingEnabled;
    public final boolean vtSettingEnabled;

    private static int wifiCallingModeToProtoEnum(int i) {
        if (i == 0) {
            return 1;
        }
        if (i != 1) {
            return i != 2 ? 0 : 3;
        }
        return 2;
    }

    public static PerSimStatus getCurrentState(Phone phone) {
        boolean z;
        boolean z2;
        int i;
        int i2;
        boolean z3;
        boolean z4;
        int[] numberIds = getNumberIds(phone);
        if (numberIds == null) {
            return null;
        }
        ImsMmTelManager imsMmTelManager = getImsMmTelManager(phone);
        IccCard iccCard = phone.getIccCard();
        int carrierId2 = phone.getCarrierId();
        int i3 = numberIds[0];
        int i4 = numberIds[1];
        int i5 = numberIds[2];
        if (imsMmTelManager == null) {
            z = false;
        } else {
            z = imsMmTelManager.isAdvancedCallingSettingEnabled();
        }
        if (imsMmTelManager == null) {
            z2 = false;
        } else {
            z2 = imsMmTelManager.isVoWiFiSettingEnabled();
        }
        if (imsMmTelManager == null) {
            i = 0;
        } else {
            i = wifiCallingModeToProtoEnum(imsMmTelManager.getVoWiFiModeSetting());
        }
        if (imsMmTelManager == null) {
            i2 = 0;
        } else {
            i2 = wifiCallingModeToProtoEnum(imsMmTelManager.getVoWiFiRoamingModeSetting());
        }
        if (imsMmTelManager == null) {
            z3 = false;
        } else {
            z3 = imsMmTelManager.isVtSettingEnabled();
        }
        boolean dataRoamingEnabled2 = phone.getDataRoamingEnabled();
        long allowedNetworkTypes = phone.getAllowedNetworkTypes(0);
        boolean is2gDisabled = is2gDisabled(phone);
        if (iccCard == null) {
            z4 = false;
        } else {
            z4 = iccCard.getIccLockEnabled();
        }
        return new PerSimStatus(carrierId2, i3, i4, i5, z, z2, i, i2, z3, dataRoamingEnabled2, allowedNetworkTypes, is2gDisabled, z4, getMinimumVoltageClass(phone), getUserModifiedApnTypes(phone));
    }

    private PerSimStatus(int i, int i2, int i3, int i4, boolean z, boolean z2, int i5, int i6, boolean z3, boolean z4, long j, boolean z5, boolean z6, int i7, int i8) {
        this.carrierId = i;
        this.phoneNumberSourceUicc = i2;
        this.phoneNumberSourceCarrier = i3;
        this.phoneNumberSourceIms = i4;
        this.advancedCallingSettingEnabled = z;
        this.voWiFiSettingEnabled = z2;
        this.voWiFiModeSetting = i5;
        this.voWiFiRoamingModeSetting = i6;
        this.vtSettingEnabled = z3;
        this.dataRoamingEnabled = z4;
        this.preferredNetworkType = j;
        this.disabled2g = z5;
        this.pin1Enabled = z6;
        this.minimumVoltageClass = i7;
        this.userModifiedApnTypes = i8;
    }

    private static ImsMmTelManager getImsMmTelManager(Phone phone) {
        ImsManager imsManager = (ImsManager) phone.getContext().getSystemService(ImsManager.class);
        if (imsManager == null) {
            return null;
        }
        try {
            return imsManager.getImsMmTelManager(phone.getSubId());
        } catch (IllegalArgumentException unused) {
            return null;
        }
    }

    private static int[] getNumberIds(Phone phone) {
        SubscriptionController instance = SubscriptionController.getInstance();
        if (instance == null) {
            return null;
        }
        int subId = phone.getSubId();
        String str = (String) Optional.ofNullable(instance.getSubscriptionInfo(subId)).map(new PerSimStatus$$ExternalSyntheticLambda0()).orElse("");
        int i = 1;
        String[] strArr = {instance.getPhoneNumber(subId, 1, (String) null, (String) null), instance.getPhoneNumber(subId, 2, (String) null, (String) null), instance.getPhoneNumber(subId, 3, (String) null, (String) null)};
        int[] iArr = new int[3];
        for (int i2 = 0; i2 < 3; i2++) {
            if (!TextUtils.isEmpty(strArr[i2])) {
                for (int i3 = 0; i3 < i2; i3++) {
                    if (!TextUtils.isEmpty(strArr[i3]) && PhoneNumberUtils.areSamePhoneNumber(strArr[i2], strArr[i3], str)) {
                        iArr[i2] = iArr[i3];
                    }
                }
                if (iArr[i2] == 0) {
                    iArr[i2] = i;
                    i++;
                }
            }
        }
        return iArr;
    }

    private static boolean is2gDisabled(Phone phone) {
        return (phone.getAllowedNetworkTypes(3) & BITMASK_2G) == 0;
    }

    private static int getMinimumVoltageClass(Phone phone) {
        UiccSlot uiccSlotForPhone = UiccController.getInstance().getUiccSlotForPhone(phone.getPhoneId());
        if (uiccSlotForPhone == null) {
            return 0;
        }
        int minimumVoltageClass2 = uiccSlotForPhone.getMinimumVoltageClass();
        int i = 1;
        if (minimumVoltageClass2 != 1) {
            i = 2;
            if (minimumVoltageClass2 != 2) {
                i = 3;
                if (minimumVoltageClass2 != 3) {
                    return 0;
                }
            }
        }
        return i;
    }

    private static int getUserModifiedApnTypes(Phone phone) {
        String[] strArr = {Integer.toString(1)};
        ContentResolver contentResolver = phone.getContext().getContentResolver();
        Uri uri = Telephony.Carriers.CONTENT_URI;
        Cursor query = contentResolver.query(Uri.withAppendedPath(uri, "subId/" + phone.getSubId()), new String[]{"type"}, "edited=?", strArr, (String) null);
        int i = 0;
        while (query != null) {
            try {
                if (!query.moveToNext()) {
                    break;
                }
                i |= ApnSetting.getApnTypesBitmaskFromString(query.getString(0));
            } catch (Throwable th) {
                th.addSuppressed(th);
            }
        }
        if (query != null) {
            query.close();
        }
        return i;
        throw th;
    }
}
