package com.android.cellbroadcastservice;

import android.util.StatsEvent;
import android.util.StatsLog;

public class CellBroadcastStatsLog {
    public static final byte ANNOTATION_ID_EXCLUSIVE_STATE = 4;
    public static final byte ANNOTATION_ID_IS_UID = 1;
    public static final byte ANNOTATION_ID_PRIMARY_FIELD = 3;
    public static final byte ANNOTATION_ID_PRIMARY_FIELD_FIRST_UID = 5;
    public static final byte ANNOTATION_ID_STATE_NESTED = 8;
    public static final byte ANNOTATION_ID_TRIGGER_STATE_RESET = 7;
    public static final byte ANNOTATION_ID_TRUNCATE_TIMESTAMP = 2;
    public static final int CB_MESSAGE_ERROR = 250;
    public static final int CB_MESSAGE_FILTERED = 278;
    public static final int CB_MESSAGE_REPORTED = 249;
    public static final int CELL_BROADCAST_MESSAGE_ERROR__TYPE__CDMA_DECODING_ERROR = 1;
    public static final int CELL_BROADCAST_MESSAGE_ERROR__TYPE__CDMA_SCP_EMPTY = 2;
    public static final int CELL_BROADCAST_MESSAGE_ERROR__TYPE__CDMA_SCP_HANDLING_ERROR = 3;
    public static final int CELL_BROADCAST_MESSAGE_ERROR__TYPE__FAILED_TO_INSERT_TO_DB = 10;
    public static final int CELL_BROADCAST_MESSAGE_ERROR__TYPE__GSM_INVALID_GEO_FENCING_DATA = 8;
    public static final int CELL_BROADCAST_MESSAGE_ERROR__TYPE__GSM_INVALID_HEADER_LENGTH = 4;
    public static final int CELL_BROADCAST_MESSAGE_ERROR__TYPE__GSM_INVALID_PDU = 7;
    public static final int CELL_BROADCAST_MESSAGE_ERROR__TYPE__GSM_UMTS_INVALID_WAC = 9;
    public static final int CELL_BROADCAST_MESSAGE_ERROR__TYPE__GSM_UNSUPPORTED_HEADER_DATA_CODING_SCHEME = 6;
    public static final int CELL_BROADCAST_MESSAGE_ERROR__TYPE__GSM_UNSUPPORTED_HEADER_MESSAGE_TYPE = 5;
    public static final int CELL_BROADCAST_MESSAGE_ERROR__TYPE__NO_CONNECTION_TO_CB_SERVICE = 15;
    public static final int CELL_BROADCAST_MESSAGE_ERROR__TYPE__UNEXPECTED_CDMA_MESSAGE_TYPE_FROM_FWK = 13;
    public static final int CELL_BROADCAST_MESSAGE_ERROR__TYPE__UNEXPECTED_CDMA_SCP_MESSAGE_TYPE_FROM_FWK = 14;
    public static final int CELL_BROADCAST_MESSAGE_ERROR__TYPE__UNEXPECTED_GEOMETRY_FROM_FWK = 11;
    public static final int CELL_BROADCAST_MESSAGE_ERROR__TYPE__UNEXPECTED_GSM_MESSAGE_TYPE_FROM_FWK = 12;
    public static final int CELL_BROADCAST_MESSAGE_ERROR__TYPE__UNKNOWN_TYPE = 0;
    public static final int CELL_BROADCAST_MESSAGE_FILTERED__FILTER__AREA_INFO_MESSAGE = 3;
    public static final int CELL_BROADCAST_MESSAGE_FILTERED__FILTER__DISABLED_BY_OEM = 4;
    public static final int CELL_BROADCAST_MESSAGE_FILTERED__FILTER__DUPLICATE_MESSAGE = 1;
    public static final int CELL_BROADCAST_MESSAGE_FILTERED__FILTER__GEOFENCED_MESSAGE = 2;
    public static final int CELL_BROADCAST_MESSAGE_FILTERED__FILTER__NOT_FILTERED = 0;
    public static final int CELL_BROADCAST_MESSAGE_FILTERED__TYPE__CDMA = 2;
    public static final int CELL_BROADCAST_MESSAGE_FILTERED__TYPE__CDMA_SPC = 3;
    public static final int CELL_BROADCAST_MESSAGE_FILTERED__TYPE__GSM = 1;
    public static final int CELL_BROADCAST_MESSAGE_FILTERED__TYPE__UNKNOWN_TYPE = 0;
    public static final int CELL_BROADCAST_MESSAGE_REPORTED__SOURCE__CB_RECEIVER_APP = 3;
    public static final int CELL_BROADCAST_MESSAGE_REPORTED__SOURCE__CB_SERVICE = 2;
    public static final int CELL_BROADCAST_MESSAGE_REPORTED__SOURCE__FRAMEWORK = 1;
    public static final int CELL_BROADCAST_MESSAGE_REPORTED__SOURCE__UNKNOWN_SOURCE = 0;
    public static final int CELL_BROADCAST_MESSAGE_REPORTED__TYPE__CDMA = 2;
    public static final int CELL_BROADCAST_MESSAGE_REPORTED__TYPE__CDMA_SPC = 3;
    public static final int CELL_BROADCAST_MESSAGE_REPORTED__TYPE__GSM = 1;
    public static final int CELL_BROADCAST_MESSAGE_REPORTED__TYPE__UNKNOWN_TYPE = 0;

    public static void write(int i, int i2, int i3) {
        StatsEvent.Builder newBuilder = StatsEvent.newBuilder();
        newBuilder.setAtomId(i);
        newBuilder.writeInt(i2);
        newBuilder.writeInt(i3);
        newBuilder.usePooledBuffer();
        StatsLog.write(newBuilder.build());
    }

    public static void write(int i, int i2, String str) {
        StatsEvent.Builder newBuilder = StatsEvent.newBuilder();
        newBuilder.setAtomId(i);
        newBuilder.writeInt(i2);
        newBuilder.writeString(str);
        newBuilder.usePooledBuffer();
        StatsLog.write(newBuilder.build());
    }
}
