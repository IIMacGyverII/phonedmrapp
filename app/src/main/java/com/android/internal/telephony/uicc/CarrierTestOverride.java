package com.android.internal.telephony.uicc;

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

public class CarrierTestOverride {
    static final String CARRIER_TEST_XML_HEADER = "carrierTestOverrides";
    static final String CARRIER_TEST_XML_ITEM_KEY = "key";
    static final String CARRIER_TEST_XML_ITEM_KEY_STRING_GID1 = "gid1";
    static final String CARRIER_TEST_XML_ITEM_KEY_STRING_GID2 = "gid2";
    static final String CARRIER_TEST_XML_ITEM_KEY_STRING_ICCID = "iccid";
    static final String CARRIER_TEST_XML_ITEM_KEY_STRING_IMSI = "imsi";
    static final String CARRIER_TEST_XML_ITEM_KEY_STRING_ISINTESTMODE = "isInTestMode";
    static final String CARRIER_TEST_XML_ITEM_KEY_STRING_MCCMNC = "mccmnc";
    static final String CARRIER_TEST_XML_ITEM_KEY_STRING_PNN = "pnn";
    static final String CARRIER_TEST_XML_ITEM_KEY_STRING_SPN = "spn";
    static final String CARRIER_TEST_XML_ITEM_VALUE = "value";
    static final String CARRIER_TEST_XML_SUBHEADER = "carrierTestOverride";
    static final String DATA_CARRIER_TEST_OVERRIDE_PATH = "/user_de/0/com.android.phone/files/carrier_test_conf_sim";
    static final String LOG_TAG = "CarrierTestOverride";
    private HashMap<String, String> mCarrierTestParamMap = new HashMap<>();

    CarrierTestOverride(int i) {
        loadCarrierTestOverrides(i);
    }

    /* access modifiers changed from: package-private */
    public boolean isInTestMode() {
        return this.mCarrierTestParamMap.containsKey(CARRIER_TEST_XML_ITEM_KEY_STRING_ISINTESTMODE) && this.mCarrierTestParamMap.get(CARRIER_TEST_XML_ITEM_KEY_STRING_ISINTESTMODE).equals("true");
    }

    /* access modifiers changed from: package-private */
    public String getFakeSpn() {
        try {
            String str = this.mCarrierTestParamMap.get(CARRIER_TEST_XML_ITEM_KEY_STRING_SPN);
            Rlog.d(LOG_TAG, "reading spn from CarrierTestConfig file: " + str);
            return str;
        } catch (NullPointerException unused) {
            Rlog.w(LOG_TAG, "No spn in CarrierTestConfig file ");
            return null;
        }
    }

    /* access modifiers changed from: package-private */
    public String getFakeIMSI() {
        try {
            String str = this.mCarrierTestParamMap.get(CARRIER_TEST_XML_ITEM_KEY_STRING_IMSI);
            Rlog.d(LOG_TAG, "reading imsi from CarrierTestConfig file: " + str);
            return str;
        } catch (NullPointerException unused) {
            Rlog.w(LOG_TAG, "No imsi in CarrierTestConfig file ");
            return null;
        }
    }

    /* access modifiers changed from: package-private */
    public String getFakeGid1() {
        try {
            String str = this.mCarrierTestParamMap.get(CARRIER_TEST_XML_ITEM_KEY_STRING_GID1);
            Rlog.d(LOG_TAG, "reading gid1 from CarrierTestConfig file: " + str);
            return str;
        } catch (NullPointerException unused) {
            Rlog.w(LOG_TAG, "No gid1 in CarrierTestConfig file ");
            return null;
        }
    }

    /* access modifiers changed from: package-private */
    public String getFakeGid2() {
        try {
            String str = this.mCarrierTestParamMap.get(CARRIER_TEST_XML_ITEM_KEY_STRING_GID2);
            Rlog.d(LOG_TAG, "reading gid2 from CarrierTestConfig file: " + str);
            return str;
        } catch (NullPointerException unused) {
            Rlog.w(LOG_TAG, "No gid2 in CarrierTestConfig file ");
            return null;
        }
    }

    /* access modifiers changed from: package-private */
    public String getFakePnnHomeName() {
        try {
            String str = this.mCarrierTestParamMap.get(CARRIER_TEST_XML_ITEM_KEY_STRING_PNN);
            Rlog.d(LOG_TAG, "reading pnn from CarrierTestConfig file: " + str);
            return str;
        } catch (NullPointerException unused) {
            Rlog.w(LOG_TAG, "No pnn in CarrierTestConfig file ");
            return null;
        }
    }

    /* access modifiers changed from: package-private */
    public String getFakeIccid() {
        try {
            String str = this.mCarrierTestParamMap.get(CARRIER_TEST_XML_ITEM_KEY_STRING_ICCID);
            Rlog.d(LOG_TAG, "reading iccid from CarrierTestConfig file: " + str);
            return str;
        } catch (NullPointerException unused) {
            Rlog.w(LOG_TAG, "No iccid in CarrierTestConfig file ");
            return null;
        }
    }

    /* access modifiers changed from: package-private */
    public String getFakeMccMnc() {
        try {
            String str = this.mCarrierTestParamMap.get(CARRIER_TEST_XML_ITEM_KEY_STRING_MCCMNC);
            Rlog.d(LOG_TAG, "reading mccmnc from CarrierTestConfig file: " + str);
            return str;
        } catch (NullPointerException unused) {
            Rlog.w(LOG_TAG, "No mccmnc in CarrierTestConfig file ");
            return null;
        }
    }

    /* access modifiers changed from: package-private */
    public void override(String str, String str2, String str3, String str4, String str5, String str6, String str7) {
        this.mCarrierTestParamMap.put(CARRIER_TEST_XML_ITEM_KEY_STRING_ISINTESTMODE, "true");
        this.mCarrierTestParamMap.put(CARRIER_TEST_XML_ITEM_KEY_STRING_MCCMNC, str);
        this.mCarrierTestParamMap.put(CARRIER_TEST_XML_ITEM_KEY_STRING_IMSI, str2);
        this.mCarrierTestParamMap.put(CARRIER_TEST_XML_ITEM_KEY_STRING_ICCID, str3);
        this.mCarrierTestParamMap.put(CARRIER_TEST_XML_ITEM_KEY_STRING_GID1, str4);
        this.mCarrierTestParamMap.put(CARRIER_TEST_XML_ITEM_KEY_STRING_GID2, str5);
        this.mCarrierTestParamMap.put(CARRIER_TEST_XML_ITEM_KEY_STRING_PNN, str6);
        this.mCarrierTestParamMap.put(CARRIER_TEST_XML_ITEM_KEY_STRING_SPN, str7);
    }

    private void loadCarrierTestOverrides(int i) {
        String str = DATA_CARRIER_TEST_OVERRIDE_PATH + Integer.toString(i) + ".xml";
        Rlog.d(LOG_TAG, "File path : " + str);
        File file = new File(Environment.getDataDirectory(), str);
        try {
            FileReader fileReader = new FileReader(file);
            Rlog.d(LOG_TAG, "CarrierTestConfig file Modified Timestamp: " + file.lastModified());
            try {
                XmlPullParser newPullParser = Xml.newPullParser();
                newPullParser.setInput(fileReader);
                XmlUtils.beginDocument(newPullParser, CARRIER_TEST_XML_HEADER);
                while (true) {
                    XmlUtils.nextElement(newPullParser);
                    if (!CARRIER_TEST_XML_SUBHEADER.equals(newPullParser.getName())) {
                        fileReader.close();
                        return;
                    }
                    String attributeValue = newPullParser.getAttributeValue((String) null, CARRIER_TEST_XML_ITEM_KEY);
                    String attributeValue2 = newPullParser.getAttributeValue((String) null, "value");
                    Rlog.d(LOG_TAG, "extracting key-values from CarrierTestConfig file: " + attributeValue + "|" + attributeValue2);
                    this.mCarrierTestParamMap.put(attributeValue, attributeValue2);
                }
            } catch (XmlPullParserException e) {
                Rlog.w(LOG_TAG, "Exception in carrier_test_conf parser " + e);
            } catch (IOException e2) {
                Rlog.w(LOG_TAG, "Exception in carrier_test_conf parser " + e2);
            }
        } catch (FileNotFoundException unused) {
            Rlog.w(LOG_TAG, "Can not open " + file.getAbsolutePath());
        }
    }
}
