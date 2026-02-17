package com.android.internal.telephony.test;

import android.os.Bundle;
import android.telephony.ims.ImsConferenceState;
import android.util.Log;
import android.util.Xml;
import androidx.core.app.NotificationCompat;
import com.android.internal.telephony.util.XmlUtils;
import java.io.IOException;
import java.io.InputStream;
import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;

public class TestConferenceEventPackageParser {
    private static final String LOG_TAG = "TestConferenceEventPackageParser";
    private static final String PARTICIPANT_TAG = "participant";
    private InputStream mInputStream;

    public TestConferenceEventPackageParser(InputStream inputStream) {
        this.mInputStream = inputStream;
    }

    public ImsConferenceState parse() {
        ImsConferenceState imsConferenceState = new ImsConferenceState();
        try {
            XmlPullParser newPullParser = Xml.newPullParser();
            newPullParser.setInput(this.mInputStream, (String) null);
            newPullParser.nextTag();
            int depth = newPullParser.getDepth();
            while (XmlUtils.nextElementWithin(newPullParser, depth)) {
                if (newPullParser.getName().equals(PARTICIPANT_TAG)) {
                    Log.v(LOG_TAG, "Found participant.");
                    Bundle parseParticipant = parseParticipant(newPullParser);
                    imsConferenceState.mParticipants.put(parseParticipant.getString("endpoint"), parseParticipant);
                }
            }
            try {
                this.mInputStream.close();
                return imsConferenceState;
            } catch (IOException e) {
                Log.e(LOG_TAG, "Failed to close test conference event package InputStream", e);
                return null;
            }
        } catch (IOException | XmlPullParserException e2) {
            Log.e(LOG_TAG, "Failed to read test conference event package from XML file", e2);
            try {
                this.mInputStream.close();
                return null;
            } catch (IOException e3) {
                Log.e(LOG_TAG, "Failed to close test conference event package InputStream", e3);
                return null;
            }
        } catch (Throwable th) {
            try {
                this.mInputStream.close();
                throw th;
            } catch (IOException e4) {
                Log.e(LOG_TAG, "Failed to close test conference event package InputStream", e4);
                return null;
            }
        }
    }

    private Bundle parseParticipant(XmlPullParser xmlPullParser) throws IOException, XmlPullParserException {
        Bundle bundle = new Bundle();
        int depth = xmlPullParser.getDepth();
        String str = "";
        String str2 = str;
        String str3 = str2;
        String str4 = str3;
        while (XmlUtils.nextElementWithin(xmlPullParser, depth)) {
            if (xmlPullParser.getName().equals("user")) {
                xmlPullParser.next();
                str = xmlPullParser.getText();
            } else if (xmlPullParser.getName().equals("display-text")) {
                xmlPullParser.next();
                str2 = xmlPullParser.getText();
            } else if (xmlPullParser.getName().equals("endpoint")) {
                xmlPullParser.next();
                str3 = xmlPullParser.getText();
            } else if (xmlPullParser.getName().equals(NotificationCompat.CATEGORY_STATUS)) {
                xmlPullParser.next();
                str4 = xmlPullParser.getText();
            }
        }
        Log.v(LOG_TAG, "User: " + str);
        Log.v(LOG_TAG, "DisplayText: " + str2);
        Log.v(LOG_TAG, "Endpoint: " + str3);
        Log.v(LOG_TAG, "Status: " + str4);
        bundle.putString("user", str);
        bundle.putString("display-text", str2);
        bundle.putString("endpoint", str3);
        bundle.putString(NotificationCompat.CATEGORY_STATUS, str4);
        return bundle;
    }
}
