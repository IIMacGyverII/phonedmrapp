package com.pri.prizeinterphone.record;

import com.android.internal.telephony.d2d.DtmfTransport;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

public class WaveHeader {
    public int AvgBytesPerSec;
    public short BitsPerSample;
    public short BlockAlign;
    public short Channels;
    public char[] DataHdrID = {'d', 'a', 't', 'a'};
    public int DataHdrLeth;
    public char[] FmtHdrID = {'f', 'm', 't', ' '};
    public int FmtHdrLeth;
    public short FormatTag;
    public int SamplesPerSec;
    public final char[] fileID = {'R', 'I', 'F', 'F'};
    public int fileLength;
    public char[] wavTag = {'W', DtmfTransport.DTMF_MESSAGE_START, 'V', 'E'};

    public byte[] getHeader() throws IOException {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        WriteChar(byteArrayOutputStream, this.fileID);
        WriteInt(byteArrayOutputStream, this.fileLength);
        WriteChar(byteArrayOutputStream, this.wavTag);
        WriteChar(byteArrayOutputStream, this.FmtHdrID);
        WriteInt(byteArrayOutputStream, this.FmtHdrLeth);
        WriteShort(byteArrayOutputStream, this.FormatTag);
        WriteShort(byteArrayOutputStream, this.Channels);
        WriteInt(byteArrayOutputStream, this.SamplesPerSec);
        WriteInt(byteArrayOutputStream, this.AvgBytesPerSec);
        WriteShort(byteArrayOutputStream, this.BlockAlign);
        WriteShort(byteArrayOutputStream, this.BitsPerSample);
        WriteChar(byteArrayOutputStream, this.DataHdrID);
        WriteInt(byteArrayOutputStream, this.DataHdrLeth);
        byteArrayOutputStream.flush();
        byte[] byteArray = byteArrayOutputStream.toByteArray();
        byteArrayOutputStream.close();
        return byteArray;
    }

    private void WriteShort(ByteArrayOutputStream byteArrayOutputStream, int i) throws IOException {
        byte[] bArr = new byte[2];
        bArr[1] = (byte) ((i << 16) >> 24);
        bArr[0] = (byte) ((i << 24) >> 24);
        byteArrayOutputStream.write(bArr);
    }

    private void WriteInt(ByteArrayOutputStream byteArrayOutputStream, int i) throws IOException {
        byte[] bArr = new byte[4];
        bArr[3] = (byte) (i >> 24);
        bArr[2] = (byte) ((i << 8) >> 24);
        bArr[1] = (byte) ((i << 16) >> 24);
        bArr[0] = (byte) ((i << 24) >> 24);
        byteArrayOutputStream.write(bArr);
    }

    private void WriteChar(ByteArrayOutputStream byteArrayOutputStream, char[] cArr) {
        for (char write : cArr) {
            byteArrayOutputStream.write(write);
        }
    }
}
