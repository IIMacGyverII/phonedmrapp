package com.pri.prizeinterphone.config;

import android.content.Context;
import android.os.Environment;
import android.util.Log;
import android.util.Xml;
import com.pri.prizeinterphone.PrizeInterPhoneApp;
import com.pri.prizeinterphone.config.data.InValidException;
import com.pri.prizeinterphone.config.data.InsertChannel;
import com.pri.prizeinterphone.config.data.InsertChannels;
import com.pri.prizeinterphone.config.data.InsertConfig;
import com.pri.prizeinterphone.config.data.ParseConfig;
import com.pri.prizeinterphone.config.tag.XmlTagManager;
import com.pri.prizeinterphone.config.tag.XmlTagValid;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;

public class ConfigXmlPullParser {
    public static final String CONFIG_PATH = (Environment.getExternalStorageDirectory() + "/intercom/intercom_config.xml");
    private static final String TAG = "XmlTagParser";
    private Context mContext;
    private XmlTagManager xmlTagManager;

    private ConfigXmlPullParser(Context context) {
        this.mContext = context;
        this.xmlTagManager = XmlTagManager.getInstance();
    }

    private static class SingletonHolder {
        /* access modifiers changed from: private */
        public static final ConfigXmlPullParser INSTANCE = new ConfigXmlPullParser(PrizeInterPhoneApp.getContext());

        private SingletonHolder() {
        }
    }

    public static ConfigXmlPullParser getInstance() {
        return SingletonHolder.INSTANCE;
    }

    public ParseConfig parse() {
        ParseConfig.Builder builder = new ParseConfig.Builder();
        try {
            XmlPullParser newPullParser = Xml.newPullParser();
            FileInputStream fileInputStream = new FileInputStream(CONFIG_PATH);
            newPullParser.setInput(fileInputStream, StandardCharsets.UTF_8.name());
            InsertConfig insertConfig = new InsertConfig();
            for (int eventType = newPullParser.getEventType(); eventType != 1; eventType = newPullParser.next()) {
                String name = newPullParser.getName();
                if (eventType != 2) {
                    if (eventType == 3) {
                        if (this.xmlTagManager.getConfigTag().isAvailable(name)) {
                            Log.d(TAG, "config=" + insertConfig);
                            builder.withInsertConfig(insertConfig);
                        }
                    }
                } else if (this.xmlTagManager.getLocalNumberTag().isAvailable(name)) {
                    String nextText = newPullParser.nextText();
                    Log.d(TAG, "Local Number: " + nextText);
                    insertConfig.setLocalNumber(Integer.parseInt(nextText));
                } else if (this.xmlTagManager.getChannelsTag().isAvailable(name)) {
                    String str = "";
                    if (this.xmlTagManager.getChannelsIdTag().isAvailable(newPullParser.getAttributeName(0))) {
                        str = newPullParser.getAttributeValue((String) null, this.xmlTagManager.getChannelsIdTag().getTag());
                    }
                    Log.d(TAG, "Channels id: " + str);
                    XmlTagValid.checkInvalid(this.xmlTagManager.getChannelsIdTag().getTag(), str);
                    InsertChannels insertChannels = new InsertChannels();
                    insertConfig.getInsertChannels().put(Integer.parseInt(str), insertChannels);
                    parseChannel(newPullParser, insertChannels);
                }
            }
            fileInputStream.close();
            builder.withIsError(false);
        } catch (Exception e) {
            Log.d(TAG, "parse error", e);
            builder.withIsError(true);
        }
        return builder.build();
    }

    private void parseChannel(XmlPullParser xmlPullParser, InsertChannels insertChannels) throws XmlPullParserException, IOException, InValidException, NumberFormatException {
        int eventType = xmlPullParser.getEventType();
        InsertChannel.Builder builder = null;
        while (eventType != 1) {
            String name = xmlPullParser.getName();
            if (eventType == 2) {
                if (this.xmlTagManager.getChannelTag().isAvailable(name)) {
                    builder = new InsertChannel.Builder();
                    Log.d(TAG, "==========START_TAG:channel==========");
                    String attributeValue = this.xmlTagManager.getChannelNameTag().isAvailable(xmlPullParser.getAttributeName(0)) ? xmlPullParser.getAttributeValue((String) null, this.xmlTagManager.getChannelNameTag().getTag()) : "";
                    Log.d(TAG, "Channel Name: " + attributeValue);
                    XmlTagValid.checkInvalid(this.xmlTagManager.getChannelTag().getTag(), attributeValue);
                    builder.withName(attributeValue);
                } else if (this.xmlTagManager.getSendfreqTag().isAvailable(name)) {
                    String nextText = xmlPullParser.nextText();
                    Log.d(TAG, "Send Frequency: " + nextText);
                    XmlTagValid.checkInvalid(this.xmlTagManager.getSendfreqTag().getTag(), nextText);
                    builder.withSendfreq(nextText);
                } else if (this.xmlTagManager.getRecfreqTag().isAvailable(name)) {
                    String nextText2 = xmlPullParser.nextText();
                    Log.d(TAG, "Receive Frequency: " + nextText2);
                    XmlTagValid.checkInvalid(this.xmlTagManager.getRecfreqTag().getTag(), nextText2);
                    builder.withRecfreq(nextText2);
                } else if (this.xmlTagManager.getChanneltypeTag().isAvailable(name)) {
                    String nextText3 = xmlPullParser.nextText();
                    Log.d(TAG, "Channel Type: " + nextText3);
                    XmlTagValid.checkInvalid(this.xmlTagManager.getChanneltypeTag().getTag(), nextText3);
                    builder.withChanneltype(nextText3);
                } else if (this.xmlTagManager.getPowerTag().isAvailable(name)) {
                    String nextText4 = xmlPullParser.nextText();
                    Log.d(TAG, "power: " + nextText4);
                    XmlTagValid.checkInvalid(this.xmlTagManager.getPowerTag().getTag(), nextText4);
                    builder.withPower(nextText4);
                } else if (this.xmlTagManager.getColorCodeTag().isAvailable(name)) {
                    String nextText5 = xmlPullParser.nextText();
                    Log.d(TAG, "Color Mode: " + nextText5);
                    XmlTagValid.checkInvalid(this.xmlTagManager.getColorCodeTag().getTag(), nextText5);
                    builder.withColorcode(nextText5);
                } else if (this.xmlTagManager.getSlotModeTag().isAvailable(name)) {
                    String nextText6 = xmlPullParser.nextText();
                    Log.d(TAG, "Slot Mode: " + nextText6);
                    XmlTagValid.checkInvalid(this.xmlTagManager.getSlotModeTag().getTag(), nextText6);
                    builder.withSlotmode(nextText6);
                } else if (this.xmlTagManager.getEncryptSwitchTag().isAvailable(name)) {
                    String nextText7 = xmlPullParser.nextText();
                    Log.d(TAG, "Encrypt Switch: " + nextText7);
                    XmlTagValid.checkInvalid(this.xmlTagManager.getEncryptSwitchTag().getTag(), nextText7);
                    builder.withEncryptSwitch(nextText7);
                } else if (this.xmlTagManager.getEncryptTextTag().isAvailable(name)) {
                    String nextText8 = xmlPullParser.nextText();
                    Log.d(TAG, "Encrypt Text: " + nextText8);
                    XmlTagValid.checkInvalid(this.xmlTagManager.getEncryptTextTag().getTag(), nextText8);
                    builder.withEncryptText(nextText8);
                } else if (this.xmlTagManager.getGroupValueTag().isAvailable(name)) {
                    String nextText9 = xmlPullParser.nextText();
                    Log.d(TAG, "Group Value: " + nextText9);
                    XmlTagValid.checkInvalid(this.xmlTagManager.getGroupValueTag().getTag(), nextText9);
                    builder.withGroupvalue(nextText9);
                } else if (this.xmlTagManager.getContacTypeTag().isAvailable(name)) {
                    int attributeCount = xmlPullParser.getAttributeCount();
                    for (int i = 0; i < attributeCount; i++) {
                        if (xmlPullParser.getAttributeName(i).equals("type")) {
                            String attributeValue2 = xmlPullParser.getAttributeValue(i);
                            Log.d(TAG, "+++ contactType +++: " + attributeValue2);
                            XmlTagValid.checkInvalid(this.xmlTagManager.getContacTypeTag().getTag(), attributeValue2);
                            builder.withContactype(attributeValue2);
                        }
                    }
                } else if (this.xmlTagManager.getNumber().isAvailable(name)) {
                    String nextText10 = xmlPullParser.nextText();
                    Log.d(TAG, "number: " + nextText10);
                    String contactype = builder.build().getContactype();
                    if (Integer.parseInt(contactype) != 2) {
                        XmlTagValid.checkDigitalTypeInvalid(contactype, this.xmlTagManager.getNumber().getTag(), nextText10);
                        builder.withNumber(nextText10);
                    }
                } else if (this.xmlTagManager.getRecGroup().isAvailable(name)) {
                    String nextText11 = xmlPullParser.nextText();
                    Log.d(TAG, "rec Group: " + nextText11);
                    XmlTagValid.checkInvalid(this.xmlTagManager.getRecGroup().getTag(), nextText11);
                    builder.withRecGroup(nextText11);
                } else if (this.xmlTagManager.getBandTag().isAvailable(name)) {
                    String nextText12 = xmlPullParser.nextText();
                    Log.d(TAG, "Band: " + nextText12);
                    XmlTagValid.checkInvalid(this.xmlTagManager.getBandTag().getTag(), nextText12);
                    builder.withBand(nextText12);
                } else if (this.xmlTagManager.getSquelchLevelTag().isAvailable(name)) {
                    String nextText13 = xmlPullParser.nextText();
                    Log.d(TAG, "Squelch Level: " + nextText13);
                    XmlTagValid.checkInvalid(this.xmlTagManager.getSquelchLevelTag().getTag(), nextText13);
                    builder.withSquelchlevel(nextText13);
                } else if (this.xmlTagManager.getRecvSubaudioTypeTag().isAvailable(name)) {
                    String nextText14 = xmlPullParser.nextText();
                    Log.d(TAG, "Receive SubAudio Type: " + nextText14);
                    XmlTagValid.checkInvalid(this.xmlTagManager.getRecvSubaudioTypeTag().getTag(), nextText14);
                    builder.withRecvsubaudiotype(nextText14);
                } else if (this.xmlTagManager.getSendSubaudioTypeTag().isAvailable(name)) {
                    String nextText15 = xmlPullParser.nextText();
                    Log.d(TAG, "Send SubAudio Type: " + nextText15);
                    XmlTagValid.checkInvalid(this.xmlTagManager.getSendSubaudioTypeTag().getTag(), nextText15);
                    builder.withSendsubaudiotype(nextText15);
                } else if (this.xmlTagManager.getRecvsubaudiofreq().isAvailable(name)) {
                    String nextText16 = xmlPullParser.nextText();
                    Log.d(TAG, "Recv Subaudio Freq: " + nextText16);
                    XmlTagValid.checkAnalogTypeInvalid(builder.build().getRecvsubaudiotype(), this.xmlTagManager.getNumber().getTag(), nextText16);
                    builder.withRecvSubaudioFreq(nextText16);
                } else if (this.xmlTagManager.getSendsubaudiofreq().isAvailable(name)) {
                    String nextText17 = xmlPullParser.nextText();
                    Log.d(TAG, "Send Subaudio Freq: " + nextText17);
                    XmlTagValid.checkAnalogTypeInvalid(builder.build().getSendsubaudiotype(), this.xmlTagManager.getNumber().getTag(), nextText17);
                    builder.withSendSubaudioFreq(nextText17);
                }
            } else if (eventType != 3) {
                continue;
            } else if (this.xmlTagManager.getChannelTag().isAvailable(name)) {
                Log.d(TAG, "==========END_TAG:channel==========");
                if (builder != null) {
                    insertChannels.getChannels().add(builder.build());
                }
            } else if (this.xmlTagManager.getChannelsTag().isAvailable(name)) {
                return;
            }
            eventType = xmlPullParser.next();
        }
    }
}
