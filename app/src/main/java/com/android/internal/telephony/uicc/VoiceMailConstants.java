package com.android.internal.telephony.uicc;

import android.compat.annotation.UnsupportedAppUsage;
import android.os.Environment;
import android.util.Xml;
import com.android.internal.telephony.util.XmlUtils;
import com.android.telephony.Rlog;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;

public class VoiceMailConstants {
    static final String LOG_TAG = "VoiceMailConstants";
    static final int NAME = 0;
    static final int NUMBER = 1;
    static final String PARTNER_VOICEMAIL_PATH = "etc/voicemail-conf.xml";
    static final int SIZE = 3;
    static final int TAG = 2;
    private HashMap<String, String[]> CarrierVmMap = new HashMap<>();

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    VoiceMailConstants() {
        loadVoiceMail();
    }

    public boolean containsCarrier(String str) {
        return this.CarrierVmMap.containsKey(str);
    }

    /* access modifiers changed from: package-private */
    public String getCarrierName(String str) {
        return this.CarrierVmMap.get(str)[0];
    }

    /* access modifiers changed from: package-private */
    public String getVoiceMailNumber(String str) {
        return this.CarrierVmMap.get(str)[1];
    }

    /* access modifiers changed from: package-private */
    public String getVoiceMailTag(String str) {
        return this.CarrierVmMap.get(str)[2];
    }

    private void loadVoiceMail() {
        try {
            FileReader fileReader = new FileReader(new File(Environment.getRootDirectory(), PARTNER_VOICEMAIL_PATH));
            try {
                XmlPullParser newPullParser = Xml.newPullParser();
                newPullParser.setInput(fileReader);
                XmlUtils.beginDocument(newPullParser, "voicemail");
                while (true) {
                    XmlUtils.nextElement(newPullParser);
                    if ("voicemail".equals(newPullParser.getName())) {
                        this.CarrierVmMap.put(newPullParser.getAttributeValue((String) null, "numeric"), new String[]{newPullParser.getAttributeValue((String) null, "carrier"), newPullParser.getAttributeValue((String) null, "vmnumber"), newPullParser.getAttributeValue((String) null, "vmtag")});
                    }
                    try {
                        break;
                    } catch (IOException unused) {
                        return;
                    }
                }
            } catch (XmlPullParserException e) {
                Rlog.w(LOG_TAG, "Exception in Voicemail parser " + e);
            } catch (IOException e2) {
                Rlog.w(LOG_TAG, "Exception in Voicemail parser " + e2);
            } catch (Throwable th) {
                try {
                    fileReader.close();
                } catch (IOException unused2) {
                }
                throw th;
            }
            fileReader.close();
        } catch (FileNotFoundException unused3) {
            Rlog.w(LOG_TAG, "Can't open " + Environment.getRootDirectory() + "/" + PARTNER_VOICEMAIL_PATH);
        }
    }
}
