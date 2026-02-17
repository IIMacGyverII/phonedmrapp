package com.android.internal.telephony.euicc;

import android.app.PendingIntent;
import android.content.Intent;
import android.os.Binder;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import android.telephony.euicc.DownloadableSubscription;
import android.text.TextUtils;
import android.util.Log;
import com.android.internal.annotations.VisibleForTesting;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

@VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
public class EuiccOperation implements Parcelable {
    @VisibleForTesting
    @Deprecated
    static final int ACTION_DOWNLOAD_CONFIRMATION_CODE = 8;
    @VisibleForTesting
    static final int ACTION_DOWNLOAD_DEACTIVATE_SIM = 2;
    @VisibleForTesting
    static final int ACTION_DOWNLOAD_NO_PRIVILEGES = 3;
    @VisibleForTesting
    static final int ACTION_DOWNLOAD_NO_PRIVILEGES_OR_DEACTIVATE_SIM_CHECK_METADATA = 9;
    @VisibleForTesting
    static final int ACTION_DOWNLOAD_RESOLVABLE_ERRORS = 7;
    @VisibleForTesting
    static final int ACTION_GET_DEFAULT_LIST_DEACTIVATE_SIM = 4;
    @VisibleForTesting
    static final int ACTION_GET_METADATA_DEACTIVATE_SIM = 1;
    @VisibleForTesting
    static final int ACTION_SWITCH_DEACTIVATE_SIM = 5;
    @VisibleForTesting
    static final int ACTION_SWITCH_NO_PRIVILEGES = 6;
    public static final Parcelable.Creator<EuiccOperation> CREATOR = new Parcelable.Creator<EuiccOperation>() {
        public EuiccOperation createFromParcel(Parcel parcel) {
            return new EuiccOperation(parcel);
        }

        public EuiccOperation[] newArray(int i) {
            return new EuiccOperation[i];
        }
    };
    private static final String TAG = "EuiccOperation";
    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public final int mAction;
    private final String mCallingPackage;
    private final long mCallingToken;
    private final DownloadableSubscription mDownloadableSubscription;
    private final int mResolvableErrors;
    private final int mSubscriptionId;
    private final boolean mSwitchAfterDownload;

    @VisibleForTesting
    @Retention(RetentionPolicy.SOURCE)
    @interface Action {
    }

    public int describeContents() {
        return 0;
    }

    static EuiccOperation forGetMetadataDeactivateSim(long j, DownloadableSubscription downloadableSubscription, String str) {
        return new EuiccOperation(1, j, downloadableSubscription, 0, false, str);
    }

    static EuiccOperation forDownloadDeactivateSim(long j, DownloadableSubscription downloadableSubscription, boolean z, String str) {
        return new EuiccOperation(2, j, downloadableSubscription, 0, z, str);
    }

    static EuiccOperation forDownloadNoPrivileges(long j, DownloadableSubscription downloadableSubscription, boolean z, String str) {
        return new EuiccOperation(3, j, downloadableSubscription, 0, z, str);
    }

    static EuiccOperation forDownloadNoPrivilegesOrDeactivateSimCheckMetadata(long j, DownloadableSubscription downloadableSubscription, boolean z, String str) {
        return new EuiccOperation(9, j, downloadableSubscription, 0, z, str);
    }

    @Deprecated
    public static EuiccOperation forDownloadConfirmationCode(long j, DownloadableSubscription downloadableSubscription, boolean z, String str) {
        return new EuiccOperation(8, j, downloadableSubscription, 0, z, str);
    }

    static EuiccOperation forDownloadResolvableErrors(long j, DownloadableSubscription downloadableSubscription, boolean z, String str, int i) {
        return new EuiccOperation(7, j, downloadableSubscription, 0, z, str, i);
    }

    static EuiccOperation forGetDefaultListDeactivateSim(long j, String str) {
        return new EuiccOperation(4, j, (DownloadableSubscription) null, 0, false, str);
    }

    static EuiccOperation forSwitchDeactivateSim(long j, int i, String str) {
        return new EuiccOperation(5, j, (DownloadableSubscription) null, i, false, str);
    }

    static EuiccOperation forSwitchNoPrivileges(long j, int i, String str) {
        return new EuiccOperation(6, j, (DownloadableSubscription) null, i, false, str);
    }

    EuiccOperation(int i, long j, DownloadableSubscription downloadableSubscription, int i2, boolean z, String str, int i3) {
        this.mAction = i;
        this.mCallingToken = j;
        this.mDownloadableSubscription = downloadableSubscription;
        this.mSubscriptionId = i2;
        this.mSwitchAfterDownload = z;
        this.mCallingPackage = str;
        this.mResolvableErrors = i3;
    }

    EuiccOperation(int i, long j, DownloadableSubscription downloadableSubscription, int i2, boolean z, String str) {
        this.mAction = i;
        this.mCallingToken = j;
        this.mDownloadableSubscription = downloadableSubscription;
        this.mSubscriptionId = i2;
        this.mSwitchAfterDownload = z;
        this.mCallingPackage = str;
        this.mResolvableErrors = 0;
    }

    EuiccOperation(Parcel parcel) {
        this.mAction = parcel.readInt();
        this.mCallingToken = parcel.readLong();
        this.mDownloadableSubscription = (DownloadableSubscription) parcel.readTypedObject(DownloadableSubscription.CREATOR);
        this.mSubscriptionId = parcel.readInt();
        this.mSwitchAfterDownload = parcel.readBoolean();
        this.mCallingPackage = parcel.readString();
        this.mResolvableErrors = parcel.readInt();
    }

    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeInt(this.mAction);
        parcel.writeLong(this.mCallingToken);
        parcel.writeTypedObject(this.mDownloadableSubscription, i);
        parcel.writeInt(this.mSubscriptionId);
        parcel.writeBoolean(this.mSwitchAfterDownload);
        parcel.writeString(this.mCallingPackage);
        parcel.writeInt(this.mResolvableErrors);
    }

    public void continueOperation(int i, Bundle bundle, PendingIntent pendingIntent) {
        Binder.restoreCallingIdentity(this.mCallingToken);
        switch (this.mAction) {
            case 1:
                resolvedGetMetadataDeactivateSim(i, bundle.getBoolean("android.service.euicc.extra.RESOLUTION_CONSENT"), pendingIntent);
                return;
            case 2:
                resolvedDownloadDeactivateSim(i, bundle.getInt("android.service.euicc.extra.RESOLUTION_PORT_INDEX", 0), bundle.getBoolean("android.service.euicc.extra.RESOLUTION_CONSENT"), pendingIntent);
                return;
            case 3:
                resolvedDownloadNoPrivileges(i, bundle.getBoolean("android.service.euicc.extra.RESOLUTION_CONSENT"), pendingIntent);
                return;
            case 4:
                resolvedGetDefaultListDeactivateSim(i, bundle.getBoolean("android.service.euicc.extra.RESOLUTION_CONSENT"), pendingIntent);
                return;
            case 5:
                int i2 = i;
                resolvedSwitchDeactivateSim(i2, bundle.getInt("android.service.euicc.extra.RESOLUTION_PORT_INDEX", 0), bundle.getBoolean("android.service.euicc.extra.RESOLUTION_CONSENT"), pendingIntent, bundle.getBoolean("android.service.euicc.extra.RESOLUTION_USE_PORT_INDEX", false));
                return;
            case 6:
                int i3 = i;
                resolvedSwitchNoPrivileges(i3, bundle.getInt("android.service.euicc.extra.RESOLUTION_PORT_INDEX", 0), bundle.getBoolean("android.service.euicc.extra.RESOLUTION_CONSENT"), pendingIntent, bundle.getBoolean("android.service.euicc.extra.RESOLUTION_USE_PORT_INDEX", false));
                return;
            case 7:
                resolvedDownloadResolvableErrors(i, bundle, pendingIntent);
                return;
            case 8:
                resolvedDownloadConfirmationCode(i, bundle.getString("android.service.euicc.extra.RESOLUTION_CONFIRMATION_CODE"), pendingIntent);
                return;
            case 9:
                resolvedDownloadNoPrivilegesOrDeactivateSimCheckMetadata(i, bundle.getInt("android.service.euicc.extra.RESOLUTION_PORT_INDEX", 0), bundle.getBoolean("android.service.euicc.extra.RESOLUTION_CONSENT"), pendingIntent);
                return;
            default:
                Log.wtf(TAG, "Unknown action: " + this.mAction);
                return;
        }
    }

    private void resolvedGetMetadataDeactivateSim(int i, boolean z, PendingIntent pendingIntent) {
        if (z) {
            EuiccController.get().getDownloadableSubscriptionMetadata(i, this.mDownloadableSubscription, true, this.mCallingPackage, pendingIntent);
            return;
        }
        fail(pendingIntent);
    }

    private void resolvedDownloadDeactivateSim(int i, int i2, boolean z, PendingIntent pendingIntent) {
        if (z) {
            EuiccController.get().downloadSubscription(i, i2, this.mDownloadableSubscription, this.mSwitchAfterDownload, this.mCallingPackage, true, (Bundle) null, pendingIntent);
            return;
        }
        fail(pendingIntent);
    }

    private void resolvedDownloadNoPrivileges(int i, boolean z, PendingIntent pendingIntent) {
        if (z) {
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                EuiccController.get().downloadSubscriptionPrivileged(i, 0, clearCallingIdentity, this.mDownloadableSubscription, this.mSwitchAfterDownload, true, this.mCallingPackage, (Bundle) null, pendingIntent);
            } finally {
                Binder.restoreCallingIdentity(clearCallingIdentity);
            }
        } else {
            fail(pendingIntent);
        }
    }

    private void resolvedDownloadNoPrivilegesOrDeactivateSimCheckMetadata(int i, int i2, boolean z, PendingIntent pendingIntent) {
        if (z) {
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                EuiccController.get().downloadSubscriptionPrivilegedCheckMetadata(i, i2, clearCallingIdentity, this.mDownloadableSubscription, this.mSwitchAfterDownload, true, this.mCallingPackage, (Bundle) null, pendingIntent);
            } finally {
                Binder.restoreCallingIdentity(clearCallingIdentity);
            }
        } else {
            fail(pendingIntent);
        }
    }

    @Deprecated
    private void resolvedDownloadConfirmationCode(int i, String str, PendingIntent pendingIntent) {
        if (TextUtils.isEmpty(str)) {
            fail(pendingIntent);
            return;
        }
        this.mDownloadableSubscription.setConfirmationCode(str);
        EuiccController.get().downloadSubscription(i, 0, this.mDownloadableSubscription, this.mSwitchAfterDownload, this.mCallingPackage, true, (Bundle) null, pendingIntent);
    }

    private void resolvedDownloadResolvableErrors(int i, Bundle bundle, PendingIntent pendingIntent) {
        String str;
        boolean z = (this.mResolvableErrors & 2) == 0 || bundle.getBoolean("android.service.euicc.extra.RESOLUTION_ALLOW_POLICY_RULES");
        if ((1 & this.mResolvableErrors) != 0) {
            str = bundle.getString("android.service.euicc.extra.RESOLUTION_CONFIRMATION_CODE");
            if (TextUtils.isEmpty(str)) {
                z = false;
            }
        } else {
            str = null;
        }
        if (!z) {
            fail(pendingIntent);
            return;
        }
        this.mDownloadableSubscription.setConfirmationCode(str);
        EuiccController.get().downloadSubscription(i, bundle.getInt("android.service.euicc.extra.RESOLUTION_PORT_INDEX", 0), this.mDownloadableSubscription, this.mSwitchAfterDownload, this.mCallingPackage, true, bundle, pendingIntent);
    }

    private void resolvedGetDefaultListDeactivateSim(int i, boolean z, PendingIntent pendingIntent) {
        if (z) {
            EuiccController.get().getDefaultDownloadableSubscriptionList(i, true, this.mCallingPackage, pendingIntent);
        } else {
            fail(pendingIntent);
        }
    }

    private void resolvedSwitchDeactivateSim(int i, int i2, boolean z, PendingIntent pendingIntent, boolean z2) {
        if (z) {
            EuiccController.get().switchToSubscription(i, this.mSubscriptionId, i2, true, this.mCallingPackage, pendingIntent, z2);
            return;
        }
        fail(pendingIntent);
    }

    private void resolvedSwitchNoPrivileges(int i, int i2, boolean z, PendingIntent pendingIntent, boolean z2) {
        if (z) {
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                EuiccController.get().switchToSubscriptionPrivileged(i, i2, clearCallingIdentity, this.mSubscriptionId, true, this.mCallingPackage, pendingIntent, z2);
            } finally {
                Binder.restoreCallingIdentity(clearCallingIdentity);
            }
        } else {
            fail(pendingIntent);
        }
    }

    private static void fail(PendingIntent pendingIntent) {
        EuiccController.get().lambda$refreshSubscriptionsAndSendResult$0(pendingIntent, 2, (Intent) null);
    }
}
