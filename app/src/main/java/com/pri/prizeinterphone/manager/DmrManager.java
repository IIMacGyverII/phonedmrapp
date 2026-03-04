package com.pri.prizeinterphone.manager;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.res.AssetManager;
import android.media.RingtoneManager;
import android.os.Handler;
import android.text.TextUtils;
import android.util.ArrayMap;
import android.util.Log;
import androidx.core.app.NotificationCompat;
import com.pri.prizeinterphone.InterPhoneService;
import com.pri.prizeinterphone.PrizeInterPhoneApp;
import com.pri.prizeinterphone.Util.ReadFileUtils;
import com.pri.prizeinterphone.constant.Constants;
import com.pri.prizeinterphone.message.AnalogMessage;
import com.pri.prizeinterphone.message.BaseMessage;
import com.pri.prizeinterphone.message.DigitalMessage;
import com.pri.prizeinterphone.message.EnhanceMessage;
import com.pri.prizeinterphone.message.FetchSmsMessage;
import com.pri.prizeinterphone.message.InitMessage;
import com.pri.prizeinterphone.message.InterruptMessage;
import com.pri.prizeinterphone.message.LaunchMessage;
import com.pri.prizeinterphone.message.MicMessage;
import com.pri.prizeinterphone.message.QueryInitMessage;
import com.pri.prizeinterphone.message.RelayMessage;
import com.pri.prizeinterphone.message.SendSmsMessage;
import com.pri.prizeinterphone.message.SmsProtocolMessage;
import com.pri.prizeinterphone.message.TotMessage;
import com.pri.prizeinterphone.message.VersionMessage;
import com.pri.prizeinterphone.serial.SerialManager;
import com.pri.prizeinterphone.serial.data.AudioRecordData;
import com.pri.prizeinterphone.serial.data.ChannelData;
import com.pri.prizeinterphone.serial.data.ContactData;
import com.pri.prizeinterphone.serial.data.ConversationData;
import com.pri.prizeinterphone.serial.data.MessageData;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;
import com.pri.prizeinterphone.serial.data.UtilChannelData;
import com.pri.prizeinterphone.serial.data.UtilContactsData;
import com.pri.prizeinterphone.serial.data.UtilConversationData;
import com.pri.prizeinterphone.serial.data.UtilInitChannelData;
import com.pri.prizeinterphone.serial.data.UtilMessageData;
import com.pri.prizeinterphone.serial.data.UtilRecordData;
import com.pri.prizeinterphone.state.CmdStateMachine;
import com.pri.prizeinterphone.ymodem.YModemManager;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.function.Consumer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
/* loaded from: classes4.dex */
public class DmrManager {
    private static final boolean DEBUG_IS_SUPPORT_FRQC_BAND_U = false;
    private static final boolean DEBUG_IS_SUPPORT_FRQC_BAND_UV = false;
    private static final boolean DEBUG_IS_SUPPORT_FRQC_BAND_V = false;
    private static final boolean DEBUG_RELATED_MODULE_VER = false;
    public static final String TAG = "DmrManager";
    private static String frqcBandName = "";
    private static String moduleVersion = "";
    private static DmrManager presenter;
    private ChannelData currentChannel;
    private ContactData currentContact;
    private UtilContactsData dbContactHelper;
    private UtilConversationData dbConversationHelper;
    private UtilMessageData dbMessageTool;
    private UtilRecordData dbRecordHelper;
    private UtilInitChannelData mInitChannelDataDB;
    private UpdateChannelDataNotificationListener mUpdateChannelDataNotificationListener;
    private List<ContactLisenter> contactListeners = new ArrayList();
    private List<ChannelListener> channelListeners = new ArrayList();
    private List<MessageLisenter> messageListeners = new ArrayList();
    private List<LaunchListener> launchListeners = new ArrayList();
    private List<InterruptResultListener> interruptResultListeners = new ArrayList();
    private List<ChannelData> channels = new ArrayList();
    private int localId = 1;
    private int chatId = PersonSharePrefData.getIntData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_CONTACTS_SELECTED_ID, 1);
    private int chatType = PersonSharePrefData.getIntData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_CONTACTS_SELECTED_TYPE, 0);
    private boolean background = true;
    private boolean isLauncher = false;
    private boolean isTestBitErrorRate = false;
    private Handler mHandler = new Handler();
    private int mChannelIndex = 0;
    private MessageData mLastMsg = null;
    private ArrayList<UpdateListener> mUpdateChannelListListeners = new ArrayList<>();
    private ArrayMap<Byte, CopyOnWriteArrayList<MessageListener>> mMessageListenerLists = new ArrayMap<>();

    /* loaded from: classes4.dex */
    public interface MessageListener {
        default void dealEvent(BaseMessage baseMessage) {
        }

        default void errorEvent(Byte b) {
        }
    }

    /* loaded from: classes4.dex */
    public interface UpdateChannelDataNotificationListener {
        void updateNotification(ChannelData channelData);
    }

    /* loaded from: classes4.dex */
    public interface UpdateListener {
        void updateModuleInit();

        void updateTalkBackChannelList();
    }

    public int getLaunchTime() {
        return 60;
    }

    public void onChannelBusy() {
    }

    public void setLaunchTime(int i) {
    }

    private DmrManager() {
    }

    public static DmrManager getInstance() {
        if (presenter == null) {
            presenter = new DmrManager();
        }
        return presenter;
    }

    public boolean init() {
        this.dbMessageTool = new UtilMessageData(PrizeInterPhoneApp.getContext());
        this.dbContactHelper = new UtilContactsData(PrizeInterPhoneApp.getContext());
        this.dbConversationHelper = new UtilConversationData(PrizeInterPhoneApp.getContext());
        this.dbRecordHelper = new UtilRecordData(PrizeInterPhoneApp.getContext());
        return true;
    }

    public void setTestBitErrorRate(boolean z) {
        this.isTestBitErrorRate = z;
    }

    public boolean isTestBitErrorRate() {
        return this.isTestBitErrorRate;
    }

    public ArrayList<AudioRecordData> getAllRecordList() {
        return this.dbRecordHelper.getAllRecordFiles();
    }

    public void deleteRecordFile(AudioRecordData audioRecordData) {
        this.dbRecordHelper.removeRecordFile(audioRecordData);
    }

    public void addRecordDb(AudioRecordData audioRecordData) {
        audioRecordData.setId(this.dbRecordHelper.addRecordData(audioRecordData));
        if (this.dbRecordHelper.updateRecordData(audioRecordData) == 1) {
            Log.i(TAG, "addRecordDb: success");
        }
    }

    public void initChannelData() {
        this.localId = PersonSharePrefData.getIntData(PrizeInterPhoneApp.getContext(), "pref_person_device_id", 1);
        UtilInitChannelData utilInitChannelData = new UtilInitChannelData(PrizeInterPhoneApp.getContext());
        this.mInitChannelDataDB = utilInitChannelData;
        utilInitChannelData.mCurrentChannelSelectIndex = Constants.getSelectedChannelArea(PrizeInterPhoneApp.getContext());
        if (this.mInitChannelDataDB.isDBEmpty() || getDefaultDbHelper().getAllChannels().size() == 0) {
            this.mInitChannelDataDB.initChannelDb();
        }
        updateChannelList();
    }

    public UtilInitChannelData getInitChannelDataDB() {
        return this.mInitChannelDataDB;
    }

    public void initSerialPort() {
        SerialManager.getInstance().init();
    }

    public void releaseSerialPort() {
        SerialManager.getInstance().release();
    }

    public void onModuleInited() {
        updateModuleInit();
    }

    public void syncChannelInfo(ChannelData channelData) {
        if (channelData.active == 1) {
            syncChannelInfo();
        } else {
            Log.d(TAG, "only active channel can syncChannelInfo");
        }
    }

    public void syncChannelInfo() {
        Log.d(TAG, "syncChannelInfo");
        CmdStateMachine cmdStateMachine = CmdStateMachine.getInstance();
        cmdStateMachine.startCmdMachine();
        cmdStateMachine.transitionToSetChannelStateState();
        cmdStateMachine.setChannelData(null);
        cmdStateMachine.deferMessage(cmdStateMachine.obtainMessage(10));
        cmdStateMachine.sendMessage(cmdStateMachine.obtainMessage(10));
    }

    public void syncChannelInfoWithData(ChannelData channelData) {
        Log.d(TAG, "syncChannelInfoWithData");
        CmdStateMachine cmdStateMachine = CmdStateMachine.getInstance();
        cmdStateMachine.startCmdMachine();
        cmdStateMachine.transitionToSetChannelStateState();
        cmdStateMachine.setChannelData(channelData);
        cmdStateMachine.deferMessage(cmdStateMachine.obtainMessage(10));
        cmdStateMachine.sendMessage(cmdStateMachine.obtainMessage(10));
    }

    public void updateChannelList() {
        this.channels = getCurrentDbHelper().getAllChannels();
        if (this.mUpdateChannelListListeners.size() > 0) {
            Iterator<UpdateListener> it = this.mUpdateChannelListListeners.iterator();
            while (it.hasNext()) {
                it.next().updateTalkBackChannelList();
            }
        }
    }

    public void updateModuleInit() {
        this.channels = getCurrentDbHelper().getAllChannels();
        if (this.mUpdateChannelListListeners.size() > 0) {
            Iterator<UpdateListener> it = this.mUpdateChannelListListeners.iterator();
            while (it.hasNext()) {
                it.next().updateModuleInit();
            }
        }
    }

    public List<ChannelData> getChannelList() {
        return getCurrentDbHelper().getAllChannels();
    }

    public List<ChannelData> getChannelList(String str) {
        return this.mInitChannelDataDB.getCurrentDb(str).getAllChannels();
    }

    public UtilChannelData getCurrentDbHelper() {
        return this.mInitChannelDataDB.getCurrentDb(Constants.getSelectedChannelArea(PrizeInterPhoneApp.getContext()));
    }

    public UtilChannelData getDefaultDbHelper() {
        return this.mInitChannelDataDB.getCurrentDb(Constants.KEY_DEF_AREA);
    }

    public void updateChannel(ChannelData channelData) {
        getCurrentDbHelper().updateChannel(channelData);
        updateChannelList();
        syncChannelInfo(channelData);
    }

    public void updateChannel(String str, ChannelData channelData) {
        this.mInitChannelDataDB.getCurrentDb(str).updateChannel(channelData);
        updateChannelList();
        syncChannelInfo(channelData);
    }

    public void createChannel(String str, ChannelData channelData) {
        this.mInitChannelDataDB.getCurrentDb(str).addChannel(channelData);
        updateChannelList();
    }

    public void deleteChannel(ChannelData channelData) {
        getCurrentDbHelper().deleteChannel(channelData);
        updateChannelList();
    }

    public void deleteChannel(String str, ChannelData channelData) {
        this.mInitChannelDataDB.getCurrentDb(str).deleteChannel(channelData);
        updateChannelList();
    }

    public ChannelData getCurrentChannel() {
        for (int i = 0; i < this.channels.size(); i++) {
            if (this.channels.get(i).active == 1) {
                this.mChannelIndex = i;
                return this.channels.get(i);
            }
        }
        if (this.channels.size() < 1) {
            this.channels = getCurrentDbHelper().getAllChannels();
        }
        return this.channels.get(0);
    }

    public int getCurrentChannelIndex() {
        return this.mChannelIndex;
    }

    public int getLocalId() {
        return this.localId;
    }

    public void setLocalId(int i) {
        PersonSharePrefData.putIntData(PrizeInterPhoneApp.getContext(), "pref_person_device_id", i);
        if (this.localId != i) {
            this.localId = i;
            syncChannelInfo();
        }
    }

    public int getChatId() {
        return this.chatId;
    }

    public void setChatId(int i) {
        this.chatId = i;
    }

    public int getChatType() {
        return this.chatType;
    }

    public void setChatType(int i) {
        this.chatType = i;
    }

    public ContactData getCurrentContact() {
        return this.dbContactHelper.getActiveContact();
    }

    private void sendDigitalMessage(ChannelData channelData) {
        DigitalMessage digitalMessage = new DigitalMessage();
        digitalMessage.localId = getLocalId();
        digitalMessage.rxFreq = channelData.getRxFreq();
        digitalMessage.txFreq = channelData.getTxFreq();
        digitalMessage.power = (byte) channelData.getPower();
        digitalMessage.contactType = (byte) channelData.getContactType();
        digitalMessage.txContact = channelData.getTxContact();
        digitalMessage.cc = (byte) channelData.getCc();
        digitalMessage.inboundSlot = (byte) channelData.getInBoundSlot();
        digitalMessage.outboundSlot = (byte) channelData.getOutBoundSlot();
        digitalMessage.channelMode = (byte) channelData.getChannelMode();
        digitalMessage.encryptSw = (byte) channelData.getEncryptSw();
        digitalMessage.encryptKey = !channelData.getEncryptKey().equals("") ? channelData.getEncryptKey().getBytes() : getByteDefault();
        
        // DEBUG: Log RX group list configuration
        android.util.Log.i("DMRModHooks_GroupDebug", "=== sendDigitalMessage DEBUG ===");
        android.util.Log.i("DMRModHooks_GroupDebug", "Channel: " + channelData.getName() + " (ID: " + channelData.getId() + ")");
        android.util.Log.i("DMRModHooks_GroupDebug", "contactType: " + channelData.contactType);
        android.util.Log.i("DMRModHooks_GroupDebug", "txContact: " + channelData.getTxContact());
        android.util.Log.i("DMRModHooks_GroupDebug", "groups array: " + java.util.Arrays.toString(channelData.groups));
        
        if (channelData.contactType == 1) {
            digitalMessage.groupList = channelData.groups;
            android.util.Log.i("DMRModHooks_GroupDebug", "✓ Setting groupList in digitalMessage (contactType==1)");
            android.util.Log.i("DMRModHooks_GroupDebug", "groupList to send: " + java.util.Arrays.toString(digitalMessage.groupList));
        } else {
            android.util.Log.w("DMRModHooks_GroupDebug", "✗ NOT setting groupList (contactType=" + channelData.contactType + ", expected 1 for GROUP)");
            android.util.Log.w("DMRModHooks_GroupDebug", "Default groupList will be used: " + java.util.Arrays.toString(digitalMessage.groupList));
        }
        
        digitalMessage.mic = (byte) PersonSharePrefData.getIntData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_MiC_GAN_VALUE, 0);
        digitalMessage.relay = (byte) channelData.getRelay();
        
        android.util.Log.i("DMRModHooks_GroupDebug", "Sending digital message to hardware...");
        android.util.Log.i("DMRModHooks_GroupDebug", digitalMessage.toString());
        
        digitalMessage.send();
    }

    private void sendAnalogMessage(ChannelData channelData) {
        AnalogMessage analogMessage = new AnalogMessage();
        analogMessage.setBand((byte) channelData.getBand());
        analogMessage.setPower((byte) channelData.getPower());
        analogMessage.setTxFreq(channelData.getTxFreq());
        analogMessage.setRxFreq(channelData.getRxFreq());
        analogMessage.setSq((byte) channelData.getSq());
        analogMessage.setRxType((byte) channelData.getRxType());
        analogMessage.setRxSubCode((byte) channelData.getRxSubCode());
        analogMessage.setTxType((byte) channelData.getTxType());
        analogMessage.setTxSubCode((byte) channelData.getTxSubCode());
        analogMessage.setRelay((byte) channelData.getRelay());
        analogMessage.send();
    }

    public byte[] getByteDefault() {
        byte[] bArr = new byte[8];
        for (int i = 0; i < 8; i++) {
            bArr[i] = 0;
        }
        return bArr;
    }

    public void onModuleStatusReceived(byte b) {
        if (b == 1) {
            onReceiveStart();
        } else if (b == 2) {
            onReceiveStop();
        } else if (b == 3) {
            onSendStart();
        } else if (b == 4) {
            onSendStop();
        } else if (b == 6) {
            onSendTimeout();
        } else if (b == 5) {
            onNewSmsNotify();
        } else if (b == 8) {
            onSmsSendSuccess();
        } else if (b == 9) {
            onSmsSendFail();
        } else if (b == 7) {
            onChannelBusy();
        }
    }

    public void onReceiveStart() {
        for (LaunchListener launchListener : this.launchListeners) {
            launchListener.onReceiveStart();
        }
    }

    public void onReceiveStop() {
        for (LaunchListener launchListener : this.launchListeners) {
            launchListener.onReceiveStop();
        }
    }

    public void onSendStart() {
        for (LaunchListener launchListener : this.launchListeners) {
            launchListener.onSendStart();
        }
        this.isLauncher = true;
    }

    public void onSendStop() {
        for (LaunchListener launchListener : this.launchListeners) {
            launchListener.onSendStop();
        }
        this.isLauncher = false;
    }

    public void onSendTimeout() {
        for (LaunchListener launchListener : this.launchListeners) {
            launchListener.onSendTimeout();
        }
        this.isLauncher = false;
    }

    public void onNewSmsNotify() {
        new FetchSmsMessage().send();
    }

    public void onSmsReceived(FetchSmsMessage fetchSmsMessage) {
        Log.i(TAG, "onSmsReceived: " + fetchSmsMessage.toString());
        MessageData messageData = new MessageData();
        messageData.setDirection(1);
        messageData.setStatus(0);
        messageData.setConvType(fetchSmsMessage.type);
        messageData.setFrom(fetchSmsMessage.callID);
        if (fetchSmsMessage.type == 1) {
            int txContact = getCurrentChannel().getTxContact();
            messageData.setTo(txContact);
            messageData.setConv_target(txContact);
        } else {
            messageData.setTo(PersonSharePrefData.getIntData(PrizeInterPhoneApp.getContext(), "pref_person_device_id", 1));
            messageData.setConv_target(fetchSmsMessage.callID);
        }
        messageData.setTimestamp(System.currentTimeMillis());
        messageData.setContent(fetchSmsMessage.msgContent);
        this.dbMessageTool.addSms(messageData);
        if (this.background) {
            playRingtoneDefault();
        }
        updateConversationTimestamp(messageData);
        notifyMessageReceive();
    }

    public boolean saveSms(MessageData messageData) {
        this.dbMessageTool.addSms(messageData);
        updateConversationTimestamp(messageData);
        return sendSms(messageData);
    }

    public boolean sendSms(MessageData messageData) {
        SendSmsMessage sendSmsMessage = new SendSmsMessage();
        ChannelData currentChannel = getCurrentChannel();
        if (currentChannel.getContactType() == 0) {
            sendSmsMessage.setMsgType((byte) 1);
        } else if (currentChannel.getContactType() == 1) {
            sendSmsMessage.setMsgType((byte) 3);
        } else if (currentChannel.getContactType() == 2) {
            sendSmsMessage.setMsgType((byte) 2);
        }
        sendSmsMessage.setCallNumber(currentChannel.getTxContact());
        sendSmsMessage.setMsgContent(messageData.getContent());
        sendSmsMessage.send();
        this.mLastMsg = messageData;
        notifyMessageSend(messageData);
        return true;
    }

    public void onSmsSendSuccess() {
        this.mLastMsg.setStatus(2);
        this.dbMessageTool.updateSms(this.mLastMsg);
        notifyMessageSend(this.mLastMsg);
    }

    public void onSmsSendFail() {
        this.mLastMsg.setStatus(3);
        int updateSms = this.dbMessageTool.updateSms(this.mLastMsg);
        Log.i(TAG, "onSmsSendFail saveSms: result =" + updateSms);
        notifyMessageSend(this.mLastMsg);
    }

    public boolean deleteSms(MessageData messageData) {
        this.dbMessageTool.deleteSms(messageData);
        notifyMessageDelete(messageData);
        return true;
    }

    public boolean deleteAllSms(int i, int i2) {
        this.dbMessageTool.deleteAllSms(i, i2);
        notifyMessageDelete(null);
        return true;
    }

    public boolean deleteConverList(ConversationData conversationData) {
        this.dbConversationHelper.deleteConverstion(conversationData);
        return true;
    }

    private void updateConversationTimestamp(MessageData messageData) {
        ContactData contact;
        String str;
        ConversationData conversationData = new ConversationData();
        conversationData.setTimestamp(Long.valueOf(messageData.getTimestamp()));
        conversationData.setConvType(messageData.getConvType());
        if (messageData.getDirection() == 0 || messageData.getConvType() == 1) {
            conversationData.setConvTarget(messageData.getTo());
            contact = this.dbContactHelper.getContact(messageData.getConvType(), messageData.getTo());
            str = messageData.getTo() + "";
        } else {
            conversationData.setConvTarget(messageData.getFrom());
            contact = this.dbContactHelper.getContact(messageData.getConvType(), messageData.getFrom());
            str = messageData.getFrom() + "";
        }
        if (contact != null && !TextUtils.isEmpty(contact.getNumber())) {
            str = contact.getName();
        }
        conversationData.setName(str);
        ConversationData conversation = this.dbConversationHelper.getConversation(conversationData.getConvType(), conversationData.getConvTarget());
        if (conversation != null) {
            if (messageData.getDirection() == 1) {
                conversationData.setUnReadCount(conversation.getUnReadCount() + 1);
            }
            this.dbConversationHelper.updateConverstion(conversationData);
            return;
        }
        conversationData.setId((int) this.dbConversationHelper.addConversation(conversationData));
        if (messageData.getDirection() == 1) {
            conversationData.setUnReadCount(1);
        }
        this.dbConversationHelper.updateConverstion(conversationData);
    }

    public ConversationData getConversationData(int i, int i2) {
        return this.dbConversationHelper.getConversation(i, i2);
    }

    public void updateConversation(ConversationData conversationData) {
        this.dbConversationHelper.updateConverstion(conversationData);
    }

    public ArrayList<ContactData> getAllContacts() {
        return this.dbContactHelper.getAllContacts();
    }

    public ArrayList<ContactData> getAllContacts(int i) {
        return this.dbContactHelper.getAllContacts(i);
    }

    public ArrayList<MessageData> getAllSms(String str) {
        return this.dbMessageTool.getAllSms(str);
    }

    public ArrayList<MessageData> getAllSms(int i) {
        return this.dbMessageTool.getAllSms(i);
    }

    public ArrayList<MessageData> getAllSms(int i, int i2) {
        return this.dbMessageTool.getAllSms(i, i2);
    }

    public MessageData getLastSms(int i, int i2) {
        return this.dbMessageTool.getLastSms(i, i2);
    }

    public ContactData getContact(int i) {
        return this.dbContactHelper.getContact(i);
    }

    public ContactData getContact(int i, int i2) {
        return this.dbContactHelper.getContact(i, i2);
    }

    public boolean updateContact(ContactData contactData) {
        boolean updateContact = this.dbContactHelper.updateContact(contactData);
        if (updateContact) {
            notifyContactUpdate(contactData);
        }
        return updateContact;
    }

    public boolean saveContact(ContactData contactData) {
        long addContact = this.dbContactHelper.addContact();
        contactData.setId((int) addContact);
        this.dbContactHelper.updateContact(contactData);
        int i = (addContact > 0L ? 1 : (addContact == 0L ? 0 : -1));
        if (i > 0) {
            notifyContactAdded(contactData);
        }
        return i > 0;
    }

    public boolean deleteContact(ContactData contactData) {
        this.dbContactHelper.deleteContact(contactData);
        notifyContactDelete(contactData);
        return true;
    }

    public ArrayList<ConversationData> getAllConversations() {
        return this.dbConversationHelper.getAllConversations();
    }

    public void notifyMessageSend(MessageData messageData) {
        for (MessageLisenter messageLisenter : this.messageListeners) {
            messageLisenter.onMessageSend(messageData);
            messageLisenter.onUnreadStatusUpdated();
        }
    }

    public void notifyMessageReceive() {
        for (MessageLisenter messageLisenter : this.messageListeners) {
            messageLisenter.onMessageReceived();
        }
    }

    public void notifyUnreadChange() {
        for (MessageLisenter messageLisenter : this.messageListeners) {
            messageLisenter.onUnreadStatusUpdated();
        }
    }

    public void notifyMessageDelete(MessageData messageData) {
        for (MessageLisenter messageLisenter : this.messageListeners) {
            messageLisenter.onMessageDelete(messageData);
        }
    }

    public void notifyContactAdded(ContactData contactData) {
        for (ContactLisenter contactLisenter : this.contactListeners) {
            contactLisenter.onContactAdded(contactData);
        }
    }

    public void notifyContactDelete(ContactData contactData) {
        for (ContactLisenter contactLisenter : this.contactListeners) {
            contactLisenter.onContactRemoved(contactData);
        }
    }

    public void notifyContactUpdate(ContactData contactData) {
        for (ContactLisenter contactLisenter : this.contactListeners) {
            Log.d("fzc", "listener=" + contactLisenter);
            contactLisenter.onContactUpdated(contactData);
        }
    }

    public void addLaunchListener(LaunchListener launchListener) {
        this.launchListeners.add(launchListener);
    }

    public void addInterruptListener(InterruptResultListener interruptResultListener) {
        this.interruptResultListeners.add(interruptResultListener);
    }

    public void removeInterruptListener(InterruptResultListener interruptResultListener) {
        this.interruptResultListeners.remove(interruptResultListener);
    }

    /* JADX INFO: Access modifiers changed from: private */
    public static /* synthetic */ void lambda$notifyInterruptReceive$0(byte b, InterruptResultListener interruptResultListener) {
        interruptResultListener.onReceiveInterrupt(Byte.toUnsignedInt(b));
    }

    public void notifyInterruptReceive(final byte b) {
        this.interruptResultListeners.forEach(new Consumer() { // from class: com.pri.prizeinterphone.manager.DmrManager$$ExternalSyntheticLambda0
            @Override // java.util.function.Consumer
            public final void accept(Object obj) {
                DmrManager.lambda$notifyInterruptReceive$0(b, (InterruptResultListener) obj);
            }
        });
    }

    public void addContactListener(ContactLisenter contactLisenter) {
        this.contactListeners.add(contactLisenter);
    }

    public void removeContactListener(ContactLisenter contactLisenter) {
        this.contactListeners.remove(contactLisenter);
    }

    public void addChannelListener(ChannelListener channelListener) {
        this.channelListeners.add(channelListener);
    }

    public void removeMessageListener(ChannelListener channelListener) {
        this.channelListeners.remove(channelListener);
    }

    public void addMessageListener(MessageLisenter messageLisenter) {
        this.messageListeners.add(messageLisenter);
    }

    public void removeMessageListener(MessageLisenter messageLisenter) {
        this.messageListeners.remove(messageLisenter);
    }

    public void queryInitStatus() {
        new InitMessage().send();
    }

    public void setSmsProtocol() {
        new SmsProtocolMessage().send();
    }

    private void playRingtoneDefault() {
        RingtoneManager.getRingtone(PrizeInterPhoneApp.getContext(), RingtoneManager.getDefaultUri(2)).play();
    }

    public boolean isLauncher() {
        return this.isLauncher;
    }

    public void launchCommand() {
        LaunchMessage launchMessage = new LaunchMessage();
        launchMessage.launch = (byte) 1;
        launchMessage.send();
    }

    public void relayCommand() {
        RelayMessage relayMessage = new RelayMessage();
        relayMessage.relay = (byte) getCurrentChannel().getRelay();
        relayMessage.send();
    }

    public void enhanceFunction(byte b, int i) {
        EnhanceMessage enhanceMessage = new EnhanceMessage();
        enhanceMessage.fun = b;
        enhanceMessage.callNum = i;
        enhanceMessage.send();
    }

    public void launchEnd() {
        LaunchMessage launchMessage = new LaunchMessage();
        launchMessage.launch = (byte) 2;
        launchMessage.send();
    }

    public void sendQueryVersionCmdToMdl() {
        new VersionMessage().send();
    }

    public void sendQueryInitializedCmdToMdl() {
        new QueryInitMessage().send();
    }

    public void sendSetTotCmdToMdl() {
        TotMessage totMessage = new TotMessage();
        totMessage.tot = (byte) 0;
        totMessage.send();
    }

    public void sendTransmissionInterruptCmdToMdl() {
        sendTransmissionInterruptCmdToMdl(getCurrentChannel().getInterrupt());
    }

    public void sendTransmissionInterruptCmdToMdl(int i) {
        InterruptMessage interruptMessage = new InterruptMessage();
        interruptMessage.interrupt = (byte) i;
        interruptMessage.send();
    }

    public void sendSetChannelCmdToMdl() {
        ChannelData currentChannel = getInstance().getCurrentChannel();
        if (currentChannel != null) {
            if (currentChannel.getType() == 0) {
                getInstance().sendDigitalMessage(currentChannel);
            } else {
                getInstance().sendAnalogMessage(currentChannel);
            }
        }
    }

    public void sendSetChannelCmdToMdl(ChannelData channelData) {
        if (channelData != null) {
            if (channelData.getType() == 0) {
                getInstance().sendDigitalMessage(channelData);
                return;
            } else {
                getInstance().sendAnalogMessage(channelData);
                return;
            }
        }
        sendSetChannelCmdToMdl();
    }

    public void sendSetMicGainCmdToMdl() {
        MicMessage micMessage = new MicMessage();
        micMessage.gain = (byte) PersonSharePrefData.getIntData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_MiC_GAN_VALUE, 0);
        micMessage.send();
    }

    public void registerUpdateListener(UpdateListener updateListener) {
        this.mUpdateChannelListListeners.add(updateListener);
    }

    public void unregisterUpdateListener(UpdateListener updateListener) {
        this.mUpdateChannelListListeners.remove(updateListener);
    }

    public synchronized void registerEventListener(byte b, MessageListener messageListener) {
        if (!this.mMessageListenerLists.containsKey(Byte.valueOf(b))) {
            CopyOnWriteArrayList<MessageListener> copyOnWriteArrayList = new CopyOnWriteArrayList<>();
            copyOnWriteArrayList.add(messageListener);
            this.mMessageListenerLists.put(Byte.valueOf(b), copyOnWriteArrayList);
        } else {
            this.mMessageListenerLists.get(Byte.valueOf(b)).add(messageListener);
        }
    }

    public synchronized void dealEvent(byte b, BaseMessage baseMessage) {
        if (this.mMessageListenerLists.isEmpty()) {
            return;
        }
        CopyOnWriteArrayList<MessageListener> copyOnWriteArrayList = this.mMessageListenerLists.get(Byte.valueOf(b));
        if (copyOnWriteArrayList != null && !copyOnWriteArrayList.isEmpty()) {
            Iterator<MessageListener> it = copyOnWriteArrayList.iterator();
            while (it.hasNext()) {
                try {
                    it.next().dealEvent(baseMessage);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public synchronized void errorEvent(byte b) {
        if (this.mMessageListenerLists.isEmpty()) {
            return;
        }
        CopyOnWriteArrayList<MessageListener> copyOnWriteArrayList = this.mMessageListenerLists.get(Byte.valueOf(b));
        if (copyOnWriteArrayList != null && !copyOnWriteArrayList.isEmpty()) {
            Iterator<MessageListener> it = copyOnWriteArrayList.iterator();
            while (it.hasNext()) {
                try {
                    it.next().errorEvent(Byte.valueOf(b));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public synchronized void unregisterEventListener(Byte b, MessageListener messageListener) {
        if (this.mMessageListenerLists.containsKey(b)) {
            if (this.mMessageListenerLists.get(b).contains(messageListener)) {
                this.mMessageListenerLists.get(b).remove(messageListener);
            }
            if (this.mMessageListenerLists.get(b).isEmpty()) {
                this.mMessageListenerLists.remove(b);
            }
        }
    }

    public void onVersionReceived(VersionMessage versionMessage) {
        Log.d(TAG, "onVersionReceived start");
        if (versionMessage != null) {
            PersonSharePrefData.putStringData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_DEVICE_DMR_VERSION, versionMessage.versionName);
        }
        Constants.initDefChannelAreas();
        initChannelData();
        Log.d(TAG, "onVersionReceived end");
    }

    public void resetData() {
        resetData(true);
    }

    public void resetData(boolean z) {
        this.localId = 1;
        PersonSharePrefData.putIntData(PrizeInterPhoneApp.getContext(), "pref_person_device_id", 1);
        PersonSharePrefData.putIntData(PrizeInterPhoneApp.getContext(), "pref_person_limit_send_time", 30);
        PersonSharePrefData.putBooleanData(PrizeInterPhoneApp.getContext(), "pref_person_ptt_start_tone", true);
        PersonSharePrefData.putBooleanData(PrizeInterPhoneApp.getContext(), "pref_person_ptt_end_tone", true);
        PersonSharePrefData.putBooleanData(PrizeInterPhoneApp.getContext(), "pref_person_ptt_record", false);
        PersonSharePrefData.putStringData(PrizeInterPhoneApp.getContext(), "pref_person_channel_area_selected_index", Constants.KEY_DEF_AREA);
        PersonSharePrefData.putBooleanData(PrizeInterPhoneApp.getContext(), "pref_person_busy_no_send", true);
        PersonSharePrefData.putIntData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_MiC_GAN_VALUE, 0);
        this.mInitChannelDataDB.resetData(z);
        this.dbContactHelper.resetData();
        this.dbConversationHelper.resetData();
        notifyUnreadChange();
        this.dbMessageTool.resetData();
        updateChannelList();
        syncChannelInfo();
    }

    public void setUpdateChannelDataNotificationListener(UpdateChannelDataNotificationListener updateChannelDataNotificationListener) {
        this.mUpdateChannelDataNotificationListener = updateChannelDataNotificationListener;
    }

    public boolean needSaveRecordFile() {
        return PersonSharePrefData.getBooleanData(PrizeInterPhoneApp.getContext(), "pref_person_ptt_record", false);
    }

    public boolean playStartPromptTone() {
        return PersonSharePrefData.getBooleanData(PrizeInterPhoneApp.getContext(), "pref_person_ptt_start_tone", true);
    }

    public boolean playEndPromptTone() {
        return PersonSharePrefData.getBooleanData(PrizeInterPhoneApp.getContext(), "pref_person_ptt_end_tone", true);
    }

    public boolean getBusyNoSend() {
        return PersonSharePrefData.getBooleanData(PrizeInterPhoneApp.getContext(), "pref_person_busy_no_send", true);
    }

    public void setSendStatus(int i) {
        PersonSharePrefData.putIntData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_SEND_STATUS, i);
    }

    public boolean isSendStatus() {
        return PersonSharePrefData.getIntData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_SEND_STATUS, 0) == 1;
    }

    private void initRelatedModuleVer() {
        moduleVersion = PersonSharePrefData.getStringData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_DEVICE_DMR_VERSION, Constants.DEF_MODULE_VERSION);
        Log.d(TAG, "initRelatedModuleVer,moduleVersion=" + moduleVersion);
        frqcBandName = getUVBandFromVersion(moduleVersion);
        Log.d(TAG, "initRelatedModuleVer,frqcBandName=" + frqcBandName);
    }

    public boolean isSupportUVFrequencyBand() {
        initRelatedModuleVer();
        return frqcBandName.startsWith(Constants.MODULE_FRQC_BAND_UV);
    }

    public boolean isSupportOnlyUFrequencyBand() {
        initRelatedModuleVer();
        return !frqcBandName.startsWith(Constants.MODULE_FRQC_BAND_UV) && frqcBandName.startsWith(Constants.MODULE_FRQC_BAND_U);
    }

    public boolean isSupportOnlyVFrequencyBand() {
        initRelatedModuleVer();
        return frqcBandName.startsWith(Constants.MODULE_FRQC_BAND_V);
    }

    private String getUVBandFromVersion(String str) {
        try {
            String[] split = str.split("\\.");
            if (split.length == 4) {
                return split[2];
            }
            return split[1];
        } catch (Exception e) {
            Log.d(TAG, "getUVBandFromVersion,error", e);
            return Constants.MODULE_FRQC_BAND_U;
        }
    }

    public int getVersionNumberFromModule() {
        String str;
        try {
            String[] split = PersonSharePrefData.getStringData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_DEVICE_DMR_VERSION, Constants.DEF_MODULE_VERSION).split("\\.");
            if (split.length == 4) {
                str = split[3];
            } else {
                str = split[2];
            }
            Matcher matcher = Pattern.compile("\\d+").matcher(str);
            if (matcher.find()) {
                return Integer.parseInt(matcher.group());
            }
            return 0;
        } catch (Exception e) {
            Log.d(TAG, "getUVBandFromVersion,error", e);
            return 0;
        }
    }

    public int getVersionNumberFromRes() {
        String str;
        AssetManager assets = PrizeInterPhoneApp.getContext().getAssets();
        try {
            ArrayList arrayList = new ArrayList();
            String[] list = assets.list("");
            int length = list.length;
            int i = 0;
            while (true) {
                if (i >= length) {
                    break;
                }
                String str2 = list[i];
                Log.d(TAG, "getVersionNumberFromRes," + str2);
                if (str2.startsWith("DMR") && str2.endsWith("bin")) {
                    arrayList.add(str2);
                    break;
                }
                i++;
            }
            if (arrayList.size() != 1) {
                throw new RuntimeException("asset dir dmr firmware must only one");
            }
            String[] split = ((String) arrayList.get(0)).split("\\.");
            if (split.length == 4) {
                str = split[2];
            } else {
                str = split[3];
            }
            Matcher matcher = Pattern.compile("\\d+").matcher(str);
            if (matcher.find()) {
                return Integer.parseInt(matcher.group());
            }
            return 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public String getVersionFromRes() {
        AssetManager assets = PrizeInterPhoneApp.getContext().getAssets();
        try {
            ArrayList arrayList = new ArrayList();
            String[] list = assets.list("");
            int length = list.length;
            int i = 0;
            while (true) {
                if (i >= length) {
                    break;
                }
                String str = list[i];
                Log.d(TAG, "getVersionNumberFromRes," + str);
                if (str.startsWith("DMR") && str.endsWith("bin")) {
                    arrayList.add(str);
                    break;
                }
                i++;
            }
            if (arrayList.size() != 1) {
                throw new RuntimeException("asset dir dmr firmware must only one");
            }
            return (String) arrayList.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    public void restartApp() {
        PrizeInterPhoneApp.getContext().stopService(new Intent(PrizeInterPhoneApp.getContext(), InterPhoneService.class));
        YModemManager.getInstance().releaseYModem();
        ReadFileUtils.getInstance().pullDownPwdFoot();
        getInstance().releaseSerialPort();
        ((AlarmManager) PrizeInterPhoneApp.getContext().getSystemService(NotificationCompat.CATEGORY_ALARM)).set(1, System.currentTimeMillis() + 1000, PendingIntent.getActivity(PrizeInterPhoneApp.getContext(), 0, PrizeInterPhoneApp.getContext().getPackageManager().getLaunchIntentForPackage(PrizeInterPhoneApp.getContext().getPackageName()), 67108864));
        System.exit(0);
    }
}
