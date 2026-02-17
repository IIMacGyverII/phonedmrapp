package com.pri.prizeinterphone.activity;

public class RecordItem {
    private int id;
    private int index;
    private boolean isplay;
    private String name;

    public RecordItem() {
    }

    public RecordItem(int i, String str, int i2) {
        this.index = i;
        this.name = str;
        this.id = i2;
        this.isplay = false;
    }

    public int getIndex() {
        return this.index;
    }

    public void setIndex(int i) {
        this.index = i;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String str) {
        this.name = str;
    }

    public int getId() {
        return this.id;
    }

    public void setId(int i) {
        this.id = i;
    }

    public boolean isIsplay() {
        return this.isplay;
    }

    public void setIsplay(boolean z) {
        this.isplay = z;
    }
}
