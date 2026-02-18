package com.pri.prizeinterphone.serial.data;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;
import com.pri.prizeinterphone.R;
import com.pri.prizeinterphone.config.ConfigXmlPullParser;
import com.pri.prizeinterphone.config.data.InsertChannel;
import com.pri.prizeinterphone.config.data.InsertChannels;
import com.pri.prizeinterphone.config.data.InsertConfig;
import com.pri.prizeinterphone.config.data.ParseConfig;
import com.pri.prizeinterphone.config.tag.XmlTagValid;
import com.pri.prizeinterphone.constant.Constants;
import com.pri.prizeinterphone.manager.DmrManager;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Predicate;
/* loaded from: classes4.dex */
public class UtilInitChannelData {
    public static final String TAG = "UtilInitChannelData";
    private Context mContext;
    public String mCurrentChannelSelectIndex = Constants.KEY_DEF_AREA;
    private List<UtilChannelData> mUtilChannelDataList = new ArrayList();

    public UtilInitChannelData(Context context) {
        this.mContext = context;
        initChannelDataList();
    }

    private void initChannelDataList() {
        for (Map.Entry<String, String> entry : Constants.getSavedChannelAreas(this.mContext).entrySet()) {
            this.mUtilChannelDataList.add(new UtilChannelData(this.mContext, entry.getKey()));
        }
    }

    public void addChannelDataList(String str, LinkedHashMap<String, String> linkedHashMap) {
        this.mUtilChannelDataList.add(new UtilChannelData(this.mContext, str));
        Constants.saveChannelAreas(this.mContext, linkedHashMap);
    }

    public void removeChannelDataList(String str) {
        int i = 0;
        while (true) {
            if (i >= this.mUtilChannelDataList.size()) {
                break;
            }
            if (this.mUtilChannelDataList.get(i).mDBName.equals("database_" + str)) {
                this.mUtilChannelDataList.get(i).deleteAll();
                this.mUtilChannelDataList.get(i).close();
                this.mContext.deleteDatabase(this.mUtilChannelDataList.get(i).mDBName + ".db");
                this.mUtilChannelDataList.remove(i);
                break;
            }
            i++;
        }
        String str2 = "";
        String[] split = PersonSharePrefData.getStringData(this.mContext, PersonSharePrefData.PREF_PERSON_DEVICE_AREA_LIST, "").split(",");
        ArrayList arrayList = new ArrayList();
        for (String str3 : split) {
            arrayList.add(str3);
        }
        int i2 = 0;
        while (true) {
            if (i2 >= arrayList.size()) {
                break;
            } else if (((String) arrayList.get(i2)).equals(str)) {
                arrayList.remove(i2);
                break;
            } else {
                i2++;
            }
        }
        for (int i3 = 0; i3 < arrayList.size(); i3++) {
            str2 = i3 == 0 ? str2 + ((String) arrayList.get(i3)) : str2 + "," + ((String) arrayList.get(i3));
        }
        PersonSharePrefData.putStringData(this.mContext, PersonSharePrefData.PREF_PERSON_DEVICE_AREA_LIST, str2);
    }

    public void resetChannelDataList(String str) {
        Log.d(TAG, "resetChannelDataList,name=" + str);
        int i = 0;
        while (true) {
            if (i >= this.mUtilChannelDataList.size()) {
                break;
            }
            if (this.mUtilChannelDataList.get(i).mDBName.equals("database_" + str)) {
                Log.i("caoshaowei", "resetChannelDataList(" + i + ") - dbname : " + this.mUtilChannelDataList.get(i).mDBName);
                this.mUtilChannelDataList.get(i).deleteAll();
                this.mUtilChannelDataList.get(i).close();
                this.mContext.deleteDatabase(this.mUtilChannelDataList.get(i).mDBName + ".db");
                break;
            }
            i++;
        }
        str.hashCode();
        char c = 65535;
        switch (str.hashCode()) {
            case -2041432780:
                if (str.equals(Constants.KEY_CHANNEL_AREA_NORWAY)) {
                    c = 0;
                    break;
                }
                break;
            case -1954016311:
                if (str.equals(Constants.KEY_CHANNEL_AREA_AUS)) {
                    c = 1;
                    break;
                }
                break;
            case -1953999974:
                if (str.equals(Constants.KEY_CHANNEL_AREA_RUS)) {
                    c = 2;
                    break;
                }
                break;
            case -1953997171:
                if (str.equals(Constants.KEY_CHANNEL_AREA_USA)) {
                    c = 3;
                    break;
                }
                break;
            case -901250416:
                if (str.equals(Constants.KEY_CHANNEL_AREA_JAPAN)) {
                    c = 4;
                    break;
                }
                break;
            case -491187087:
                if (str.equals(Constants.KEY_CHANNEL_AREA_MALAYSIA)) {
                    c = 5;
                    break;
                }
                break;
            case -444728500:
                if (str.equals(Constants.KEY_CHANNEL_AREA_IRAN)) {
                    c = 6;
                    break;
                }
                break;
            case 556980811:
                if (str.equals(Constants.KEY_CHANNEL_AREA_DEFAULT)) {
                    c = 7;
                    break;
                }
                break;
            case 1015263295:
                if (str.equals(Constants.KEY_CHANNEL_AREA_DEFAULT_UHF)) {
                    c = '\b';
                    break;
                }
                break;
            case 1015264256:
                if (str.equals(Constants.KEY_CHANNEL_AREA_DEFAULT_VHF)) {
                    c = '\t';
                    break;
                }
                break;
            case 1190573325:
                if (str.equals(Constants.KEY_CHANNEL_AREA_SOUTH_AF)) {
                    c = '\n';
                    break;
                }
                break;
            case 2015177249:
                if (str.equals(Constants.KEY_CHANNEL_AREA_CHINA)) {
                    c = 11;
                    break;
                }
                break;
            case 2015177318:
                if (str.equals(Constants.KEY_CHANNEL_AREA_EU)) {
                    c = '\f';
                    break;
                }
                break;
            case 2015177498:
                if (str.equals(Constants.KEY_CHANNEL_AREA_KOREA)) {
                    c = '\r';
                    break;
                }
                break;
            case 2015177785:
                if (str.equals(Constants.KEY_CHANNEL_AREA_CHINA_TW)) {
                    c = 14;
                    break;
                }
                break;
        }
        switch (c) {
            case 0:
                initChanneldb(R.array.channel_tx_Analog_norway, str);
                return;
            case 1:
                initChanneldb(R.array.channel_tx_Analog_aus, str);
                return;
            case 2:
                initChanneldb(R.array.channel_tx_Analog_russia, str);
                return;
            case 3:
                initChanneldb(R.array.channel_tx_Analog_usa, str);
                return;
            case 4:
                initChanneldb(R.array.channel_tx_Analog_japan, str);
                return;
            case 5:
                initChanneldb(R.array.channel_tx_Analog_malaysia, str);
                return;
            case 6:
                initChanneldb(R.array.channel_tx_Analog_iran, str);
                return;
            case 7:
                initDefaultChannelDb();
                initChanneldb(R.array.channel_tx_Analog_default, str);
                return;
            case '\b':
                initDefaultUHFChannelDb(false);
                initChanneldb(R.array.channel_tx_Analog_default_uhf, str);
                return;
            case '\t':
                initChanneldb(R.array.channel_tx_Analog_default_vhf, str);
                return;
            case '\n':
                initChanneldb(R.array.channel_tx_Analog_southaf, str);
                return;
            case 11:
                initChanneldb(R.array.channel_tx_Analog_china, str);
                return;
            case '\f':
                initChanneldb(R.array.channel_tx_Analog_eu, str);
                return;
            case '\r':
                initChanneldb(R.array.channel_tx_Analog_korea, str);
                return;
            case 14:
                initChanneldb(R.array.channel_tx_Analog_china_taiwan, str);
                return;
            default:
                return;
        }
    }

    public void initChannelDb() {
        initChannelDb(false);
    }

    public void initChannelDb(boolean z) {
        initDefaultRelatedDb(z);
        initChinaChannelDb();
        initChinaTaiwanChannelDb();
        initEUChannelDb();
        initUSAChannelDb();
        initAUSChannelDb();
        initRUSSIAChannelDb();
        initIRANChannelDb();
        initKOREAChannelDb();
        initMALAYSIAChannelDb();
        initJAPANChannelDb();
        initNorWayChannelDb();
        initSouthAfricaChannelDb();
    }

    private void initDefaultRelatedDb(boolean z) {
        if (DmrManager.getInstance().isSupportUVFrequencyBand()) {
            initDefaultUHFChannelDb(z);
            initDefaultVHFChannelDb(z);
            return;
        }
        initDefaultChannelDb(z);
    }

    public boolean isDBEmpty() {
        return this.mUtilChannelDataList.size() == 0;
    }

    public UtilChannelData getCurrentDb(final String str) {
        if (!Constants.getSavedChannelAreas(this.mContext).containsKey(str)) {
            return new UtilChannelData(this.mContext, Constants.KEY_DEF_AREA);
        }
        return (UtilChannelData) this.mUtilChannelDataList.stream().filter(new Predicate() { // from class: com.pri.prizeinterphone.serial.data.UtilInitChannelData$$ExternalSyntheticLambda0
            @Override // java.util.function.Predicate
            public final boolean test(Object obj) {
                boolean lambda$getCurrentDb$0;
                lambda$getCurrentDb$0 = UtilInitChannelData.lambda$getCurrentDb$0(str, (UtilChannelData) obj);
                return lambda$getCurrentDb$0;
            }
        }).findFirst().orElse(null);
    }

    /* JADX INFO: Access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$getCurrentDb$0(String str, UtilChannelData utilChannelData) {
        return utilChannelData.mDataName.equals(str);
    }

    private void initDefaultChannelDb() {
        initDefaultChannelDb(false);
    }

    private void initDefaultChannelDb(boolean z) {
        if (z) {
            initDefaultChannelDbFromSdcard();
            return;
        }
        ArrayList arrayList = new ArrayList();
        String[] stringArray = this.mContext.getResources().getStringArray(R.array.channel_tx_digital_default);
        for (int i = 1; i <= stringArray.length; i++) {
            int parseInt = Integer.parseInt(stringArray[i - 1]);
            ChannelData buildDefaultDigitalChannel = buildDefaultDigitalChannel(parseInt, parseInt, i);
            if (i == 1) {
                buildDefaultDigitalChannel.active = 1;
            }
            arrayList.add(buildDefaultDigitalChannel);
        }
        String[] stringArray2 = this.mContext.getResources().getStringArray(R.array.channel_tx_Analog_default);
        for (int length = stringArray.length + 1; length <= stringArray2.length + stringArray.length; length++) {
            int parseInt2 = Integer.parseInt(stringArray2[(length - stringArray.length) - 1]);
            arrayList.add(buildDefaultAnalogChannel(parseInt2, parseInt2, length, 1, 1));
        }
        insertChannelDataToDb(getCurrentDb(Constants.KEY_CHANNEL_AREA_DEFAULT), arrayList);
    }

    private void initDefaultVHFChannelDb(boolean z) {
        ArrayList arrayList = new ArrayList();
        String[] stringArray = this.mContext.getResources().getStringArray(R.array.channel_tx_digital_default_vhf);
        for (int i = 1; i <= stringArray.length; i++) {
            int parseInt = Integer.parseInt(stringArray[i - 1]);
            ChannelData buildDefaultDigitalChannel = buildDefaultDigitalChannel(parseInt, parseInt, i);
            if (i == 1) {
                buildDefaultDigitalChannel.active = 1;
            }
            arrayList.add(buildDefaultDigitalChannel);
        }
        String[] stringArray2 = this.mContext.getResources().getStringArray(R.array.channel_tx_Analog_default_vhf);
        for (int length = stringArray.length + 1; length <= stringArray2.length + stringArray.length; length++) {
            int parseInt2 = Integer.parseInt(stringArray2[(length - stringArray.length) - 1]);
            arrayList.add(buildDefaultAnalogChannel(parseInt2, parseInt2, length, 1, 1));
        }
        insertChannelDataToDb(getCurrentDb(Constants.KEY_CHANNEL_AREA_DEFAULT_VHF), arrayList);
    }

    private void initDefaultUHFChannelDb() {
        initDefaultUHFChannelDb(false);
    }

    private void initDefaultUHFChannelDb(boolean z) {
        if (z) {
            initDefaultChannelDbFromSdcard();
            return;
        }
        ArrayList arrayList = new ArrayList();
        String[] stringArray = this.mContext.getResources().getStringArray(R.array.channel_tx_digital_default_uhf);
        for (int i = 1; i <= stringArray.length; i++) {
            int parseInt = Integer.parseInt(stringArray[i - 1]);
            ChannelData buildDefaultDigitalChannel = buildDefaultDigitalChannel(parseInt, parseInt, i);
            if (i == 1) {
                buildDefaultDigitalChannel.active = 1;
            }
            arrayList.add(buildDefaultDigitalChannel);
        }
        String[] stringArray2 = this.mContext.getResources().getStringArray(R.array.channel_tx_Analog_default_uhf);
        for (int length = stringArray.length + 1; length <= stringArray2.length + stringArray.length; length++) {
            int parseInt2 = Integer.parseInt(stringArray2[(length - stringArray.length) - 1]);
            arrayList.add(buildDefaultAnalogChannel(parseInt2, parseInt2, length, 1, 1));
        }
        insertChannelDataToDb(getCurrentDb(Constants.KEY_CHANNEL_AREA_DEFAULT_UHF), arrayList);
    }

    private void initDefaultChannelDbFromSdcard() {
        int i;
        ParseConfig parse = ConfigXmlPullParser.getInstance().parse();
        if (!parse.isError()) {
            InsertConfig insertConfig = parse.getInsertConfig();
            InsertChannels insertChannels = insertConfig.getInsertChannels().get(insertConfig.getLocalNumber());
            if (insertChannels != null) {
                ArrayList<InsertChannel> channels = insertChannels.getChannels();
                ArrayList arrayList = new ArrayList();
                int i2 = 1;
                for (int i3 = 0; i3 < channels.size(); i3 = i + 1) {
                    InsertChannel insertChannel = channels.get(i3);
                    if (XmlTagValid.checkMustNotEmpty(insertChannel)) {
                        i = i3;
                    } else {
                        ChannelData channelData = null;
                        int parseInt = Integer.parseInt(insertChannel.getChanneltype());
                        if (parseInt == 0) {
                            i = i3;
                            channelData = myBuildDefaultDigitalChannel(Integer.parseInt(insertChannel.getSendfreq()), Integer.parseInt(insertChannel.getRecfreq()), i2, insertChannel.getName(), Integer.parseInt(getValueOrDefault(insertChannel.getContactype(), "0")), Integer.parseInt(getValueOrDefault(insertChannel.getNumber(), "1")), getStrToArray(insertChannel.getRecGroup(), new int[]{1}));
                            i2++;
                        } else if (parseInt != 1) {
                            i = i3;
                        } else {
                            int i4 = i2 + 1;
                            i = i3;
                            channelData = myBuildDefaultAnalogChannel(Integer.parseInt(insertChannel.getSendfreq()), Integer.parseInt(insertChannel.getRecfreq()), i2, !"1".equals(insertChannel.getPower()) ? 1 : 0, "1".equals(insertChannel.getBand()) ? 1 : 0, insertChannel.getName(), Integer.parseInt(getValueOrDefault(insertChannel.getRecvsubaudiotype(), "0")), Integer.parseInt(getValueOrDefault(insertChannel.getRecvsubaudiofreq(), "0")), Integer.parseInt(getValueOrDefault(insertChannel.getSendsubaudiotype(), "0")), Integer.parseInt(getValueOrDefault(insertChannel.getSendsubaudiofreq(), "0")));
                            if (!TextUtils.isEmpty(insertChannel.getSquelchlevel())) {
                                channelData.sq = Integer.parseInt(insertChannel.getSquelchlevel());
                            }
                            i2 = i4;
                        }
                        if (i2 == 2 && channelData != null) {
                            channelData.active = 1;
                        }
                        if (channelData != null) {
                            arrayList.add(channelData);
                        }
                    }
                }
                if (!arrayList.isEmpty()) {
                    insertChannelDataToDb(getCurrentDb(Constants.KEY_DEF_AREA), arrayList);
                    Toast.makeText(this.mContext, (int) R.string.msg_notify_succeed_load_config, 1).show();
                    return;
                }
                if (DmrManager.getInstance().isSupportUVFrequencyBand()) {
                    initDefaultUHFChannelDb();
                } else {
                    initDefaultChannelDb();
                }
                Toast.makeText(this.mContext, (int) R.string.msg_notify_fail_load_config, 1).show();
            } else if (DmrManager.getInstance().isSupportUVFrequencyBand()) {
                initDefaultUHFChannelDb();
            } else {
                initDefaultChannelDb();
            }
        } else if (DmrManager.getInstance().isSupportUVFrequencyBand()) {
            initDefaultUHFChannelDb();
        } else {
            initDefaultChannelDb();
        }
    }

    private void initChinaChannelDb() {
        initChanneldb(R.array.channel_tx_Analog_china, Constants.KEY_CHANNEL_AREA_CHINA);
    }

    private void initChinaTaiwanChannelDb() {
        initChanneldb(R.array.channel_tx_Analog_china_taiwan, Constants.KEY_CHANNEL_AREA_CHINA_TW);
    }

    private void initEUChannelDb() {
        initChanneldb(R.array.channel_tx_Analog_eu, Constants.KEY_CHANNEL_AREA_EU);
    }

    private void initUSAChannelDb() {
        initChanneldb(R.array.channel_tx_Analog_usa, Constants.KEY_CHANNEL_AREA_USA);
    }

    private void initAUSChannelDb() {
        initChanneldb(R.array.channel_tx_Analog_aus, Constants.KEY_CHANNEL_AREA_AUS);
    }

    private void initRUSSIAChannelDb() {
        initChanneldb(R.array.channel_tx_Analog_russia, Constants.KEY_CHANNEL_AREA_RUS);
    }

    private void initIRANChannelDb() {
        initChanneldb(R.array.channel_tx_Analog_iran, Constants.KEY_CHANNEL_AREA_IRAN);
    }

    private void initKOREAChannelDb() {
        initChanneldb(R.array.channel_tx_Analog_korea, Constants.KEY_CHANNEL_AREA_KOREA);
    }

    private void initMALAYSIAChannelDb() {
        initChanneldb(R.array.channel_tx_Analog_malaysia, Constants.KEY_CHANNEL_AREA_MALAYSIA);
    }

    private void initJAPANChannelDb() {
        initChanneldb(R.array.channel_tx_Analog_japan, Constants.KEY_CHANNEL_AREA_JAPAN);
    }

    private void initNorWayChannelDb() {
        initChanneldb(R.array.channel_tx_Analog_norway, Constants.KEY_CHANNEL_AREA_NORWAY);
    }

    private void initSouthAfricaChannelDb() {
        initChanneldb(R.array.channel_tx_Analog_southaf, Constants.KEY_CHANNEL_AREA_SOUTH_AF);
    }

    private void initChanneldb(int i, String str) {
        ArrayList arrayList = new ArrayList();
        String[] stringArray = this.mContext.getResources().getStringArray(i);
        for (int i2 = 1; i2 <= stringArray.length; i2++) {
            int parseInt = Integer.parseInt(stringArray[i2 - 1]);
            ChannelData buildDefaultAnalogChannel = buildDefaultAnalogChannel(parseInt, parseInt, i2, 1, 1);
            if (i2 == 1) {
                buildDefaultAnalogChannel.active = 1;
            }
            arrayList.add(buildDefaultAnalogChannel);
        }
        insertChannelDataToDb(getCurrentDb(str), arrayList);
    }

    private ChannelData buildDefaultDigitalChannel(int i, int i2, int i3) {
        ChannelData channelData = new ChannelData();
        channelData._id = i3;
        channelData.type = 0;
        channelData.txFreq = i;
        channelData.rxFreq = i2;
        channelData.number = i3;
        return channelData;
    }

    private ChannelData buildDefaultDigitalChannel(int i, int i2, int i3, String str) {
        ChannelData channelData = new ChannelData();
        channelData._id = i3;
        channelData.name = str;
        channelData.type = 0;
        channelData.txFreq = i;
        channelData.rxFreq = i2;
        channelData.number = i3;
        return channelData;
    }

    private ChannelData myBuildDefaultDigitalChannel(int i, int i2, int i3, String str, int i4, int i5, int[] iArr) {
        ChannelData channelData = new ChannelData();
        channelData._id = i3;
        channelData.name = str;
        channelData.type = 0;
        channelData.txFreq = i;
        channelData.rxFreq = i2;
        channelData.number = i3;
        channelData.contactType = i4;
        if (i4 != 2) {
            channelData.txContact = i5;
            channelData.groups = iArr;
        }
        return channelData;
    }

    private ChannelData buildDefaultAnalogChannel(int i, int i2, int i3, int i4, int i5) {
        ChannelData channelData = new ChannelData();
        channelData._id = i3;
        channelData.power = i4;
        channelData.band = i5;
        channelData.type = 1;
        channelData.txFreq = i;
        channelData.rxFreq = i2;
        channelData.number = i3;
        return channelData;
    }

    private ChannelData buildDefaultAnalogChannel(int i, int i2, int i3, int i4, int i5, String str) {
        ChannelData channelData = new ChannelData();
        channelData._id = i3;
        channelData.name = str;
        channelData.power = i4;
        channelData.band = i5;
        channelData.type = 1;
        channelData.txFreq = i;
        channelData.rxFreq = i2;
        channelData.number = i3;
        return channelData;
    }

    private ChannelData myBuildDefaultAnalogChannel(int i, int i2, int i3, int i4, int i5, String str, int i6, int i7, int i8, int i9) {
        ChannelData channelData = new ChannelData();
        channelData._id = i3;
        channelData.name = str;
        channelData.power = i4;
        channelData.band = i5;
        channelData.type = 1;
        channelData.txFreq = i;
        channelData.rxFreq = i2;
        channelData.number = i3;
        channelData.rxType = i6;
        channelData.rxSubCode = i7;
        channelData.txType = i8;
        channelData.txSubCode = i9;
        return channelData;
    }

    private void insertChannelDataToDb(UtilChannelData utilChannelData, List<ChannelData> list) {
        for (ChannelData channelData : list) {
            if (utilChannelData.getChannel(channelData.getId()) != null) {
                utilChannelData.updateChannel(channelData);
            } else {
                utilChannelData.addChannel(channelData);
            }
        }
    }

    public void resetData() {
        resetData(false);
    }

    public void resetData(boolean z) {
        PersonSharePrefData.putStringData(this.mContext, PersonSharePrefData.PREF_PERSON_DEVICE_AREA_LIST, "");
        for (UtilChannelData utilChannelData : this.mUtilChannelDataList) {
            utilChannelData.deleteAll();
            utilChannelData.close();
            Context context = this.mContext;
            context.deleteDatabase(utilChannelData.mDBName + ".db");
        }
        this.mUtilChannelDataList.clear();
        initChannelDataList();
        initChannelDb(z);
    }

    public boolean isCheckDbName(String str) {
        for (int i = 0; i < this.mUtilChannelDataList.size(); i++) {
            if (this.mUtilChannelDataList.get(i).mDBName.equals("database_" + str)) {
                return true;
            }
        }
        return false;
    }

    private static String getValueOrDefault(String str, String str2) {
        return TextUtils.isEmpty(str) ? str2 : str;
    }

    private static int[] getStrToArray(String str, int[] iArr) {
        if (TextUtils.isEmpty(str)) {
            return iArr;
        }
        int[] iArr2 = new int[32];
        String[] split = str.split("");
        for (int i = 0; i < str.length(); i++) {
            iArr2[i] = Integer.parseInt(split[i]);
        }
        return iArr2;
    }
}
