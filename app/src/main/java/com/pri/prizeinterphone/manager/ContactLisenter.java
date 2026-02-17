package com.pri.prizeinterphone.manager;

import com.pri.prizeinterphone.serial.data.ContactData;

public interface ContactLisenter {
    void onContactAdded(ContactData contactData);

    void onContactRemoved(ContactData contactData);

    void onContactUpdated(ContactData contactData);
}
