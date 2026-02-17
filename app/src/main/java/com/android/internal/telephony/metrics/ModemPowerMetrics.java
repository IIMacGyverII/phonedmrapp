package com.android.internal.telephony.metrics;

import android.os.BatteryStatsManager;
import android.os.connectivity.CellularBatteryStats;
import android.telephony.CellSignalStrength;
import android.telephony.ModemActivityInfo;
import android.telephony.TelephonyManager;
import com.android.internal.telephony.nano.TelephonyProto;
import java.util.ArrayList;

public class ModemPowerMetrics {
    private static final int DATA_CONNECTION_EMERGENCY_SERVICE;
    private static final int DATA_CONNECTION_OTHER;
    private static final int NUM_DATA_CONNECTION_TYPES;
    private BatteryStatsManager mBatteryStatsManager;

    static {
        int length = TelephonyManager.getAllNetworkTypes().length + 1;
        DATA_CONNECTION_EMERGENCY_SERVICE = length;
        int i = length + 1;
        DATA_CONNECTION_OTHER = i;
        NUM_DATA_CONNECTION_TYPES = i + 1;
    }

    public ModemPowerMetrics(BatteryStatsManager batteryStatsManager) {
        this.mBatteryStatsManager = batteryStatsManager;
    }

    public TelephonyProto.ModemPowerStats buildProto() {
        TelephonyProto.ModemPowerStats modemPowerStats = new TelephonyProto.ModemPowerStats();
        CellularBatteryStats stats = getStats();
        if (stats != null) {
            modemPowerStats.loggingDurationMs = stats.getLoggingDurationMillis();
            modemPowerStats.energyConsumedMah = ((double) stats.getEnergyConsumedMaMillis()) / 3600000.0d;
            modemPowerStats.numPacketsTx = stats.getNumPacketsTx();
            modemPowerStats.cellularKernelActiveTimeMs = stats.getKernelActiveTimeMillis();
            long timeInRxSignalStrengthLevelMicros = stats.getTimeInRxSignalStrengthLevelMicros(0);
            if (timeInRxSignalStrengthLevelMicros >= 0) {
                modemPowerStats.timeInVeryPoorRxSignalLevelMs = timeInRxSignalStrengthLevelMicros;
            }
            modemPowerStats.sleepTimeMs = stats.getSleepTimeMillis();
            modemPowerStats.idleTimeMs = stats.getIdleTimeMillis();
            modemPowerStats.rxTimeMs = stats.getRxTimeMillis();
            ArrayList arrayList = new ArrayList();
            for (int i = 0; i < ModemActivityInfo.getNumTxPowerLevels(); i++) {
                long txTimeMillis = stats.getTxTimeMillis(i);
                if (txTimeMillis >= 0) {
                    arrayList.add(Long.valueOf(txTimeMillis));
                }
            }
            modemPowerStats.txTimeMs = arrayList.stream().mapToLong(new ModemPowerMetrics$$ExternalSyntheticLambda0()).toArray();
            modemPowerStats.numBytesTx = stats.getNumBytesTx();
            modemPowerStats.numPacketsRx = stats.getNumPacketsRx();
            modemPowerStats.numBytesRx = stats.getNumBytesRx();
            ArrayList arrayList2 = new ArrayList();
            for (int i2 = 0; i2 < NUM_DATA_CONNECTION_TYPES; i2++) {
                long timeInRatMicros = stats.getTimeInRatMicros(i2);
                if (timeInRatMicros >= 0) {
                    arrayList2.add(Long.valueOf(timeInRatMicros));
                }
            }
            modemPowerStats.timeInRatMs = arrayList2.stream().mapToLong(new ModemPowerMetrics$$ExternalSyntheticLambda0()).toArray();
            ArrayList arrayList3 = new ArrayList();
            for (int i3 = 0; i3 < CellSignalStrength.getNumSignalStrengthLevels(); i3++) {
                long timeInRxSignalStrengthLevelMicros2 = stats.getTimeInRxSignalStrengthLevelMicros(i3);
                if (timeInRxSignalStrengthLevelMicros2 >= 0) {
                    arrayList3.add(Long.valueOf(timeInRxSignalStrengthLevelMicros2));
                }
            }
            modemPowerStats.timeInRxSignalStrengthLevelMs = arrayList3.stream().mapToLong(new ModemPowerMetrics$$ExternalSyntheticLambda0()).toArray();
            modemPowerStats.monitoredRailEnergyConsumedMah = ((double) stats.getMonitoredRailChargeConsumedMaMillis()) / 3600000.0d;
        }
        return modemPowerStats;
    }

    private CellularBatteryStats getStats() {
        BatteryStatsManager batteryStatsManager = this.mBatteryStatsManager;
        if (batteryStatsManager == null) {
            return null;
        }
        return batteryStatsManager.getCellularBatteryStats();
    }
}
