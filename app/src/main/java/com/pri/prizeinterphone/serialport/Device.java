package com.pri.prizeinterphone.serialport;
/* loaded from: classes4.dex */
public class Device {
    private String baudrate;
    private String path;

    public Device() {
    }

    public Device(String str, String str2) {
        this.path = str;
        this.baudrate = str2;
    }

    public String getPath() {
        return this.path;
    }

    public void setPath(String str) {
        this.path = str;
    }

    public String getBaudrate() {
        return this.baudrate;
    }

    public void setBaudrate(String str) {
        this.baudrate = str;
    }

    public String toString() {
        return "Device{path='" + this.path + "', baudrate='" + this.baudrate + "'}";
    }
}
