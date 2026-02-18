package com.pri.prizeinterphone.manager;

import com.pri.prizeinterphone.serial.data.ContactData;
/* loaded from: classes4.dex */
public interface ContactLisenter {
    void onContactAdded(ContactData contactData);

    void onContactRemoved(ContactData contactData);

    void onContactUpdated(ContactData contactData);
}
