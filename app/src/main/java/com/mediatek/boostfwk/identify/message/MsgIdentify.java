package com.mediatek.boostfwk.identify.message;

import com.mediatek.boostfwk.identify.BaseIdentify;
import com.mediatek.boostfwk.scenario.BasicScenario;
import com.mediatek.boostfwk.scenario.message.MessageScenario;
import com.mediatek.boostfwk.utils.Config;
import com.mediatek.boostfwk.utils.LogUtil;
import java.util.ArrayList;
import java.util.List;

public class MsgIdentify extends BaseIdentify {
    private static final String TAG = "MsgIdentify";
    private static MsgIdentify sInstance;
    private static Object slock = new Object();
    private List<AudioStateListener> mAudioStateListeners = new ArrayList();
    private boolean mIsAudioMsgBegin = false;
    private final String[] mSpAudioMsgViewList = {"SoundWaveView", "LanguageChoiceLayout"};
    private List<Integer> mSpAudioStepList = new ArrayList();

    public interface AudioStateListener {
        void onAudioMsgStatusUpdate(boolean z);
    }

    private boolean audioMsgUpdate(int i) {
        return i == 0;
    }

    public static MsgIdentify getInstance() {
        if (sInstance == null) {
            synchronized (slock) {
                if (sInstance == null) {
                    sInstance = new MsgIdentify();
                }
            }
        }
        return sInstance;
    }

    public void registerAudioStateListener(AudioStateListener audioStateListener) {
        if (audioStateListener != null) {
            this.mAudioStateListeners.add(audioStateListener);
        }
    }

    public boolean dispatchScenario(BasicScenario basicScenario) {
        if (basicScenario == null) {
            LogUtil.mLogw(TAG, "No message scenario to dispatcher.");
            return false;
        }
        MessageScenario messageScenario = (MessageScenario) basicScenario;
        int scenarioAction = messageScenario.getScenarioAction();
        if (Config.isBoostFwkLogEnable()) {
            LogUtil.mLogd(TAG, "Message action dispatcher to = " + scenarioAction);
        }
        if (scenarioAction != 0) {
            LogUtil.mLogw(TAG, "Not found dispatcher message action.");
            return true;
        }
        audioMsgStatusUpdate(messageScenario);
        return true;
    }

    public void audioMsgStatusUpdate(MessageScenario messageScenario) {
        String viewName = messageScenario.getViewName();
        int visibilityMask = messageScenario.getVisibilityMask();
        boolean z = false;
        if (viewName.equals(MessageScenario.mAudioMsgViewList[0])) {
            z = audioMsgUpdate(visibilityMask);
        } else if (viewName.contains(MessageScenario.mAudioMsgViewList[1])) {
            z = specialAudioMsgUpdate(viewName, visibilityMask);
        }
        if (this.mIsAudioMsgBegin != z) {
            this.mIsAudioMsgBegin = z;
            for (AudioStateListener onAudioMsgStatusUpdate : this.mAudioStateListeners) {
                onAudioMsgStatusUpdate.onAudioMsgStatusUpdate(this.mIsAudioMsgBegin);
            }
            if (LogUtil.DEBUG) {
                LogUtil.mLogd(TAG, "audioMsgStatusUpdate. status = " + this.mIsAudioMsgBegin);
            }
        }
    }

    private boolean specialAudioMsgUpdate(String str, int i) {
        if (LogUtil.DEBUG) {
            LogUtil.mLogd(TAG, "specialAudioMsgUpdate. viewName = " + str + " visibilityMask = " + i);
        }
        if (!this.mIsAudioMsgBegin) {
            if (str.trim().contains(this.mSpAudioMsgViewList[0])) {
                int size = this.mSpAudioStepList.size();
                if (size != 0) {
                    if (size != 1) {
                        if (size == 2 && i == 0 && this.mSpAudioStepList.get(1).intValue() == 8) {
                            this.mSpAudioStepList.add(Integer.valueOf(i));
                            return true;
                        }
                    } else if (i == 8 && this.mSpAudioStepList.get(0).intValue() == 0) {
                        this.mSpAudioStepList.add(Integer.valueOf(i));
                    }
                } else if (i == 0) {
                    this.mSpAudioStepList.add(Integer.valueOf(i));
                }
            }
            return false;
        } else if (!str.trim().contains(this.mSpAudioMsgViewList[1]) || this.mSpAudioStepList.size() < 3 || i != 8) {
            str.trim().contains(this.mSpAudioMsgViewList[0]);
            return true;
        } else {
            this.mSpAudioStepList.clear();
            return false;
        }
    }
}
