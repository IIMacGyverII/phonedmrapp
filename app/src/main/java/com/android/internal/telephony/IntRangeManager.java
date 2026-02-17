package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.stream.Collectors;

public abstract class IntRangeManager {
    private static final int INITIAL_CLIENTS_ARRAY_SIZE = 4;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private ArrayList<IntRange> mRanges = new ArrayList<>();

    /* access modifiers changed from: protected */
    public abstract void addRange(int i, int i2, boolean z);

    /* access modifiers changed from: protected */
    public abstract boolean finishUpdate();

    /* access modifiers changed from: protected */
    public abstract void startUpdate();

    private class IntRange {
        final ArrayList<ClientRange> mClients;
        int mEndId;
        int mStartId;

        IntRange(int i, int i2, String str) {
            this.mStartId = i;
            this.mEndId = i2;
            ArrayList<ClientRange> arrayList = new ArrayList<>(4);
            this.mClients = arrayList;
            arrayList.add(new ClientRange(i, i2, str));
        }

        IntRange(ClientRange clientRange) {
            this.mStartId = clientRange.mStartId;
            this.mEndId = clientRange.mEndId;
            ArrayList<ClientRange> arrayList = new ArrayList<>(4);
            this.mClients = arrayList;
            arrayList.add(clientRange);
        }

        IntRange(IntRange intRange, int i) {
            this.mStartId = intRange.mStartId;
            this.mEndId = intRange.mEndId;
            this.mClients = new ArrayList<>(intRange.mClients.size());
            for (int i2 = 0; i2 < i; i2++) {
                this.mClients.add(intRange.mClients.get(i2));
            }
        }

        /* access modifiers changed from: package-private */
        public void insert(ClientRange clientRange) {
            int size = this.mClients.size();
            int i = -1;
            for (int i2 = 0; i2 < size; i2++) {
                ClientRange clientRange2 = this.mClients.get(i2);
                if (clientRange.mStartId <= clientRange2.mStartId) {
                    if (!clientRange.equals(clientRange2)) {
                        if (clientRange.mStartId == clientRange2.mStartId && clientRange.mEndId > clientRange2.mEndId) {
                            i = i2 + 1;
                            if (i >= size) {
                                break;
                            }
                        } else {
                            this.mClients.add(i2, clientRange);
                            return;
                        }
                    } else {
                        return;
                    }
                }
            }
            if (i == -1 || i >= size) {
                this.mClients.add(clientRange);
            } else {
                this.mClients.add(i, clientRange);
            }
        }

        public String toString() {
            return "[" + this.mStartId + "-" + this.mEndId + "]";
        }
    }

    private class ClientRange {
        final String mClient;
        final int mEndId;
        final int mStartId;

        ClientRange(int i, int i2, String str) {
            this.mStartId = i;
            this.mEndId = i2;
            this.mClient = str;
        }

        public boolean equals(Object obj) {
            if (obj == null || !(obj instanceof ClientRange)) {
                return false;
            }
            ClientRange clientRange = (ClientRange) obj;
            if (this.mStartId == clientRange.mStartId && this.mEndId == clientRange.mEndId && this.mClient.equals(clientRange.mClient)) {
                return true;
            }
            return false;
        }

        public int hashCode() {
            return (((this.mStartId * 31) + this.mEndId) * 31) + this.mClient.hashCode();
        }
    }

    protected IntRangeManager() {
    }

    public synchronized void clearRanges() {
        this.mRanges.clear();
    }

    /* JADX WARNING: Code restructure failed: missing block: B:44:0x0085, code lost:
        return true;
     */
    /* JADX WARNING: Removed duplicated region for block: B:37:0x0064  */
    /* JADX WARNING: Removed duplicated region for block: B:45:0x0086 A[DONT_GENERATE] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized boolean enableRange(int r12, int r13, java.lang.String r14) {
        /*
            r11 = this;
            monitor-enter(r11)
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r0 = r11.mRanges     // Catch:{ all -> 0x020f }
            int r0 = r0.size()     // Catch:{ all -> 0x020f }
            r1 = 0
            r2 = 1
            if (r0 != 0) goto L_0x001f
            boolean r0 = r11.tryAddRanges(r12, r13, r2)     // Catch:{ all -> 0x020f }
            if (r0 == 0) goto L_0x001d
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r0 = r11.mRanges     // Catch:{ all -> 0x020f }
            com.android.internal.telephony.IntRangeManager$IntRange r1 = new com.android.internal.telephony.IntRangeManager$IntRange     // Catch:{ all -> 0x020f }
            r1.<init>(r12, r13, r14)     // Catch:{ all -> 0x020f }
            r0.add(r1)     // Catch:{ all -> 0x020f }
            monitor-exit(r11)
            return r2
        L_0x001d:
            monitor-exit(r11)
            return r1
        L_0x001f:
            r3 = r1
        L_0x0020:
            if (r3 >= r0) goto L_0x01fb
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r4 = r11.mRanges     // Catch:{ all -> 0x020f }
            java.lang.Object r4 = r4.get(r3)     // Catch:{ all -> 0x020f }
            com.android.internal.telephony.IntRangeManager$IntRange r4 = (com.android.internal.telephony.IntRangeManager.IntRange) r4     // Catch:{ all -> 0x020f }
            int r5 = r4.mStartId     // Catch:{ all -> 0x020f }
            if (r12 < r5) goto L_0x003c
            int r6 = r4.mEndId     // Catch:{ all -> 0x020f }
            if (r13 > r6) goto L_0x003c
            com.android.internal.telephony.IntRangeManager$ClientRange r0 = new com.android.internal.telephony.IntRangeManager$ClientRange     // Catch:{ all -> 0x020f }
            r0.<init>(r12, r13, r14)     // Catch:{ all -> 0x020f }
            r4.insert(r0)     // Catch:{ all -> 0x020f }
            monitor-exit(r11)
            return r2
        L_0x003c:
            int r6 = r12 + -1
            int r7 = r4.mEndId     // Catch:{ all -> 0x020f }
            if (r6 != r7) goto L_0x0088
            int r3 = r3 + r2
            r5 = 0
            if (r3 >= r0) goto L_0x005d
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r0 = r11.mRanges     // Catch:{ all -> 0x020f }
            java.lang.Object r0 = r0.get(r3)     // Catch:{ all -> 0x020f }
            com.android.internal.telephony.IntRangeManager$IntRange r0 = (com.android.internal.telephony.IntRangeManager.IntRange) r0     // Catch:{ all -> 0x020f }
            int r3 = r0.mStartId     // Catch:{ all -> 0x020f }
            int r6 = r3 + -1
            if (r6 > r13) goto L_0x005d
            int r5 = r0.mEndId     // Catch:{ all -> 0x020f }
            if (r13 > r5) goto L_0x005a
            int r3 = r3 - r2
            goto L_0x005b
        L_0x005a:
            r3 = r13
        L_0x005b:
            r5 = r0
            goto L_0x005e
        L_0x005d:
            r3 = r13
        L_0x005e:
            boolean r0 = r11.tryAddRanges(r12, r3, r2)     // Catch:{ all -> 0x020f }
            if (r0 == 0) goto L_0x0086
            r4.mEndId = r13     // Catch:{ all -> 0x020f }
            com.android.internal.telephony.IntRangeManager$ClientRange r0 = new com.android.internal.telephony.IntRangeManager$ClientRange     // Catch:{ all -> 0x020f }
            r0.<init>(r12, r13, r14)     // Catch:{ all -> 0x020f }
            r4.insert(r0)     // Catch:{ all -> 0x020f }
            if (r5 == 0) goto L_0x0084
            int r12 = r4.mEndId     // Catch:{ all -> 0x020f }
            int r13 = r5.mEndId     // Catch:{ all -> 0x020f }
            if (r12 >= r13) goto L_0x0078
            r4.mEndId = r13     // Catch:{ all -> 0x020f }
        L_0x0078:
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$ClientRange> r12 = r4.mClients     // Catch:{ all -> 0x020f }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$ClientRange> r13 = r5.mClients     // Catch:{ all -> 0x020f }
            r12.addAll(r13)     // Catch:{ all -> 0x020f }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r12 = r11.mRanges     // Catch:{ all -> 0x020f }
            r12.remove(r5)     // Catch:{ all -> 0x020f }
        L_0x0084:
            monitor-exit(r11)
            return r2
        L_0x0086:
            monitor-exit(r11)
            return r1
        L_0x0088:
            if (r12 >= r5) goto L_0x016b
            int r6 = r13 + 1
            if (r6 >= r5) goto L_0x00a2
            boolean r0 = r11.tryAddRanges(r12, r13, r2)     // Catch:{ all -> 0x020f }
            if (r0 == 0) goto L_0x00a0
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r0 = r11.mRanges     // Catch:{ all -> 0x020f }
            com.android.internal.telephony.IntRangeManager$IntRange r1 = new com.android.internal.telephony.IntRangeManager$IntRange     // Catch:{ all -> 0x020f }
            r1.<init>(r12, r13, r14)     // Catch:{ all -> 0x020f }
            r0.add(r3, r1)     // Catch:{ all -> 0x020f }
            monitor-exit(r11)
            return r2
        L_0x00a0:
            monitor-exit(r11)
            return r1
        L_0x00a2:
            if (r13 > r7) goto L_0x00bb
            int r5 = r5 - r2
            boolean r0 = r11.tryAddRanges(r12, r5, r2)     // Catch:{ all -> 0x020f }
            if (r0 == 0) goto L_0x00b9
            r4.mStartId = r12     // Catch:{ all -> 0x020f }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$ClientRange> r0 = r4.mClients     // Catch:{ all -> 0x020f }
            com.android.internal.telephony.IntRangeManager$ClientRange r3 = new com.android.internal.telephony.IntRangeManager$ClientRange     // Catch:{ all -> 0x020f }
            r3.<init>(r12, r13, r14)     // Catch:{ all -> 0x020f }
            r0.add(r1, r3)     // Catch:{ all -> 0x020f }
            monitor-exit(r11)
            return r2
        L_0x00b9:
            monitor-exit(r11)
            return r1
        L_0x00bb:
            int r3 = r3 + r2
            r5 = r3
        L_0x00bd:
            if (r5 >= r0) goto L_0x0139
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r7 = r11.mRanges     // Catch:{ all -> 0x020f }
            java.lang.Object r7 = r7.get(r5)     // Catch:{ all -> 0x020f }
            com.android.internal.telephony.IntRangeManager$IntRange r7 = (com.android.internal.telephony.IntRangeManager.IntRange) r7     // Catch:{ all -> 0x020f }
            int r8 = r7.mStartId     // Catch:{ all -> 0x020f }
            if (r6 >= r8) goto L_0x00fd
            boolean r0 = r11.tryAddRanges(r12, r13, r2)     // Catch:{ all -> 0x020f }
            if (r0 == 0) goto L_0x00fb
            r4.mStartId = r12     // Catch:{ all -> 0x020f }
            r4.mEndId = r13     // Catch:{ all -> 0x020f }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$ClientRange> r0 = r4.mClients     // Catch:{ all -> 0x020f }
            com.android.internal.telephony.IntRangeManager$ClientRange r6 = new com.android.internal.telephony.IntRangeManager$ClientRange     // Catch:{ all -> 0x020f }
            r6.<init>(r12, r13, r14)     // Catch:{ all -> 0x020f }
            r0.add(r1, r6)     // Catch:{ all -> 0x020f }
            r12 = r3
        L_0x00e0:
            if (r12 >= r5) goto L_0x00f9
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r13 = r11.mRanges     // Catch:{ all -> 0x020f }
            java.lang.Object r13 = r13.get(r3)     // Catch:{ all -> 0x020f }
            com.android.internal.telephony.IntRangeManager$IntRange r13 = (com.android.internal.telephony.IntRangeManager.IntRange) r13     // Catch:{ all -> 0x020f }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$ClientRange> r14 = r4.mClients     // Catch:{ all -> 0x020f }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$ClientRange> r0 = r13.mClients     // Catch:{ all -> 0x020f }
            r14.addAll(r0)     // Catch:{ all -> 0x020f }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r14 = r11.mRanges     // Catch:{ all -> 0x020f }
            r14.remove(r13)     // Catch:{ all -> 0x020f }
            int r12 = r12 + 1
            goto L_0x00e0
        L_0x00f9:
            monitor-exit(r11)
            return r2
        L_0x00fb:
            monitor-exit(r11)
            return r1
        L_0x00fd:
            int r9 = r7.mEndId     // Catch:{ all -> 0x020f }
            if (r13 > r9) goto L_0x0136
            int r8 = r8 - r2
            boolean r0 = r11.tryAddRanges(r12, r8, r2)     // Catch:{ all -> 0x020f }
            if (r0 == 0) goto L_0x0134
            r4.mStartId = r12     // Catch:{ all -> 0x020f }
            int r0 = r7.mEndId     // Catch:{ all -> 0x020f }
            r4.mEndId = r0     // Catch:{ all -> 0x020f }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$ClientRange> r0 = r4.mClients     // Catch:{ all -> 0x020f }
            com.android.internal.telephony.IntRangeManager$ClientRange r6 = new com.android.internal.telephony.IntRangeManager$ClientRange     // Catch:{ all -> 0x020f }
            r6.<init>(r12, r13, r14)     // Catch:{ all -> 0x020f }
            r0.add(r1, r6)     // Catch:{ all -> 0x020f }
            r12 = r3
        L_0x0119:
            if (r12 > r5) goto L_0x0132
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r13 = r11.mRanges     // Catch:{ all -> 0x020f }
            java.lang.Object r13 = r13.get(r3)     // Catch:{ all -> 0x020f }
            com.android.internal.telephony.IntRangeManager$IntRange r13 = (com.android.internal.telephony.IntRangeManager.IntRange) r13     // Catch:{ all -> 0x020f }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$ClientRange> r14 = r4.mClients     // Catch:{ all -> 0x020f }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$ClientRange> r0 = r13.mClients     // Catch:{ all -> 0x020f }
            r14.addAll(r0)     // Catch:{ all -> 0x020f }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r14 = r11.mRanges     // Catch:{ all -> 0x020f }
            r14.remove(r13)     // Catch:{ all -> 0x020f }
            int r12 = r12 + 1
            goto L_0x0119
        L_0x0132:
            monitor-exit(r11)
            return r2
        L_0x0134:
            monitor-exit(r11)
            return r1
        L_0x0136:
            int r5 = r5 + 1
            goto L_0x00bd
        L_0x0139:
            boolean r5 = r11.tryAddRanges(r12, r13, r2)     // Catch:{ all -> 0x020f }
            if (r5 == 0) goto L_0x0169
            r4.mStartId = r12     // Catch:{ all -> 0x020f }
            r4.mEndId = r13     // Catch:{ all -> 0x020f }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$ClientRange> r5 = r4.mClients     // Catch:{ all -> 0x020f }
            com.android.internal.telephony.IntRangeManager$ClientRange r6 = new com.android.internal.telephony.IntRangeManager$ClientRange     // Catch:{ all -> 0x020f }
            r6.<init>(r12, r13, r14)     // Catch:{ all -> 0x020f }
            r5.add(r1, r6)     // Catch:{ all -> 0x020f }
            r12 = r3
        L_0x014e:
            if (r12 >= r0) goto L_0x0167
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r13 = r11.mRanges     // Catch:{ all -> 0x020f }
            java.lang.Object r13 = r13.get(r3)     // Catch:{ all -> 0x020f }
            com.android.internal.telephony.IntRangeManager$IntRange r13 = (com.android.internal.telephony.IntRangeManager.IntRange) r13     // Catch:{ all -> 0x020f }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$ClientRange> r14 = r4.mClients     // Catch:{ all -> 0x020f }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$ClientRange> r1 = r13.mClients     // Catch:{ all -> 0x020f }
            r14.addAll(r1)     // Catch:{ all -> 0x020f }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r14 = r11.mRanges     // Catch:{ all -> 0x020f }
            r14.remove(r13)     // Catch:{ all -> 0x020f }
            int r12 = r12 + 1
            goto L_0x014e
        L_0x0167:
            monitor-exit(r11)
            return r2
        L_0x0169:
            monitor-exit(r11)
            return r1
        L_0x016b:
            int r5 = r12 + 1
            if (r5 > r7) goto L_0x01f7
            if (r13 > r7) goto L_0x017b
            com.android.internal.telephony.IntRangeManager$ClientRange r0 = new com.android.internal.telephony.IntRangeManager$ClientRange     // Catch:{ all -> 0x020f }
            r0.<init>(r12, r13, r14)     // Catch:{ all -> 0x020f }
            r4.insert(r0)     // Catch:{ all -> 0x020f }
            monitor-exit(r11)
            return r2
        L_0x017b:
            int r5 = r3 + 1
            r7 = r3
            r6 = r5
        L_0x017f:
            if (r6 >= r0) goto L_0x0196
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r8 = r11.mRanges     // Catch:{ all -> 0x020f }
            java.lang.Object r8 = r8.get(r6)     // Catch:{ all -> 0x020f }
            com.android.internal.telephony.IntRangeManager$IntRange r8 = (com.android.internal.telephony.IntRangeManager.IntRange) r8     // Catch:{ all -> 0x020f }
            int r9 = r13 + 1
            int r8 = r8.mStartId     // Catch:{ all -> 0x020f }
            if (r9 >= r8) goto L_0x0190
            goto L_0x0196
        L_0x0190:
            int r7 = r6 + 1
            r10 = r7
            r7 = r6
            r6 = r10
            goto L_0x017f
        L_0x0196:
            if (r7 != r3) goto L_0x01af
            int r0 = r4.mEndId     // Catch:{ all -> 0x020f }
            int r0 = r0 + r2
            boolean r0 = r11.tryAddRanges(r0, r13, r2)     // Catch:{ all -> 0x020f }
            if (r0 == 0) goto L_0x01ad
            r4.mEndId = r13     // Catch:{ all -> 0x020f }
            com.android.internal.telephony.IntRangeManager$ClientRange r0 = new com.android.internal.telephony.IntRangeManager$ClientRange     // Catch:{ all -> 0x020f }
            r0.<init>(r12, r13, r14)     // Catch:{ all -> 0x020f }
            r4.insert(r0)     // Catch:{ all -> 0x020f }
            monitor-exit(r11)
            return r2
        L_0x01ad:
            monitor-exit(r11)
            return r1
        L_0x01af:
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r0 = r11.mRanges     // Catch:{ all -> 0x020f }
            java.lang.Object r0 = r0.get(r7)     // Catch:{ all -> 0x020f }
            com.android.internal.telephony.IntRangeManager$IntRange r0 = (com.android.internal.telephony.IntRangeManager.IntRange) r0     // Catch:{ all -> 0x020f }
            int r3 = r0.mEndId     // Catch:{ all -> 0x020f }
            if (r13 > r3) goto L_0x01bf
            int r3 = r0.mStartId     // Catch:{ all -> 0x020f }
            int r3 = r3 - r2
            goto L_0x01c0
        L_0x01bf:
            r3 = r13
        L_0x01c0:
            int r6 = r4.mEndId     // Catch:{ all -> 0x020f }
            int r6 = r6 + r2
            boolean r3 = r11.tryAddRanges(r6, r3, r2)     // Catch:{ all -> 0x020f }
            if (r3 == 0) goto L_0x01f5
            int r0 = r0.mEndId     // Catch:{ all -> 0x020f }
            if (r13 > r0) goto L_0x01ce
            goto L_0x01cf
        L_0x01ce:
            r0 = r13
        L_0x01cf:
            r4.mEndId = r0     // Catch:{ all -> 0x020f }
            com.android.internal.telephony.IntRangeManager$ClientRange r0 = new com.android.internal.telephony.IntRangeManager$ClientRange     // Catch:{ all -> 0x020f }
            r0.<init>(r12, r13, r14)     // Catch:{ all -> 0x020f }
            r4.insert(r0)     // Catch:{ all -> 0x020f }
            r12 = r5
        L_0x01da:
            if (r12 > r7) goto L_0x01f3
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r13 = r11.mRanges     // Catch:{ all -> 0x020f }
            java.lang.Object r13 = r13.get(r5)     // Catch:{ all -> 0x020f }
            com.android.internal.telephony.IntRangeManager$IntRange r13 = (com.android.internal.telephony.IntRangeManager.IntRange) r13     // Catch:{ all -> 0x020f }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$ClientRange> r14 = r4.mClients     // Catch:{ all -> 0x020f }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$ClientRange> r0 = r13.mClients     // Catch:{ all -> 0x020f }
            r14.addAll(r0)     // Catch:{ all -> 0x020f }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r14 = r11.mRanges     // Catch:{ all -> 0x020f }
            r14.remove(r13)     // Catch:{ all -> 0x020f }
            int r12 = r12 + 1
            goto L_0x01da
        L_0x01f3:
            monitor-exit(r11)
            return r2
        L_0x01f5:
            monitor-exit(r11)
            return r1
        L_0x01f7:
            int r3 = r3 + 1
            goto L_0x0020
        L_0x01fb:
            boolean r0 = r11.tryAddRanges(r12, r13, r2)     // Catch:{ all -> 0x020f }
            if (r0 == 0) goto L_0x020d
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r0 = r11.mRanges     // Catch:{ all -> 0x020f }
            com.android.internal.telephony.IntRangeManager$IntRange r1 = new com.android.internal.telephony.IntRangeManager$IntRange     // Catch:{ all -> 0x020f }
            r1.<init>(r12, r13, r14)     // Catch:{ all -> 0x020f }
            r0.add(r1)     // Catch:{ all -> 0x020f }
            monitor-exit(r11)
            return r2
        L_0x020d:
            monitor-exit(r11)
            return r1
        L_0x020f:
            r12 = move-exception
            monitor-exit(r11)
            throw r12
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.IntRangeManager.enableRange(int, int, java.lang.String):boolean");
    }

    /* JADX WARNING: Code restructure failed: missing block: B:28:0x0051, code lost:
        return false;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:86:0x010e, code lost:
        return true;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized boolean disableRange(int r13, int r14, java.lang.String r15) {
        /*
            r12 = this;
            monitor-enter(r12)
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r0 = r12.mRanges     // Catch:{ all -> 0x011e }
            int r0 = r0.size()     // Catch:{ all -> 0x011e }
            r1 = 0
            r2 = r1
        L_0x0009:
            if (r2 >= r0) goto L_0x011c
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r3 = r12.mRanges     // Catch:{ all -> 0x011e }
            java.lang.Object r3 = r3.get(r2)     // Catch:{ all -> 0x011e }
            com.android.internal.telephony.IntRangeManager$IntRange r3 = (com.android.internal.telephony.IntRangeManager.IntRange) r3     // Catch:{ all -> 0x011e }
            int r4 = r3.mStartId     // Catch:{ all -> 0x011e }
            if (r13 >= r4) goto L_0x0019
            monitor-exit(r12)
            return r1
        L_0x0019:
            int r4 = r3.mEndId     // Catch:{ all -> 0x011e }
            if (r14 > r4) goto L_0x0118
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$ClientRange> r4 = r3.mClients     // Catch:{ all -> 0x011e }
            int r5 = r4.size()     // Catch:{ all -> 0x011e }
            r6 = 1
            if (r5 != r6) goto L_0x0052
            java.lang.Object r0 = r4.get(r1)     // Catch:{ all -> 0x011e }
            com.android.internal.telephony.IntRangeManager$ClientRange r0 = (com.android.internal.telephony.IntRangeManager.ClientRange) r0     // Catch:{ all -> 0x011e }
            int r4 = r0.mStartId     // Catch:{ all -> 0x011e }
            if (r4 != r13) goto L_0x0050
            int r13 = r0.mEndId     // Catch:{ all -> 0x011e }
            if (r13 != r14) goto L_0x0050
            java.lang.String r13 = r0.mClient     // Catch:{ all -> 0x011e }
            boolean r13 = r13.equals(r15)     // Catch:{ all -> 0x011e }
            if (r13 == 0) goto L_0x0050
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r13 = r12.mRanges     // Catch:{ all -> 0x011e }
            r13.remove(r2)     // Catch:{ all -> 0x011e }
            boolean r13 = r12.updateRanges()     // Catch:{ all -> 0x011e }
            if (r13 == 0) goto L_0x0049
            monitor-exit(r12)
            return r6
        L_0x0049:
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r13 = r12.mRanges     // Catch:{ all -> 0x011e }
            r13.add(r2, r3)     // Catch:{ all -> 0x011e }
            monitor-exit(r12)
            return r1
        L_0x0050:
            monitor-exit(r12)
            return r1
        L_0x0052:
            r7 = -2147483648(0xffffffff80000000, float:-0.0)
            r8 = r1
        L_0x0055:
            if (r8 >= r5) goto L_0x0118
            java.lang.Object r9 = r4.get(r8)     // Catch:{ all -> 0x011e }
            com.android.internal.telephony.IntRangeManager$ClientRange r9 = (com.android.internal.telephony.IntRangeManager.ClientRange) r9     // Catch:{ all -> 0x011e }
            int r10 = r9.mStartId     // Catch:{ all -> 0x011e }
            if (r10 != r13) goto L_0x010f
            int r10 = r9.mEndId     // Catch:{ all -> 0x011e }
            if (r10 != r14) goto L_0x010f
            java.lang.String r10 = r9.mClient     // Catch:{ all -> 0x011e }
            boolean r10 = r10.equals(r15)     // Catch:{ all -> 0x011e }
            if (r10 == 0) goto L_0x010f
            int r13 = r5 + -1
            if (r8 != r13) goto L_0x0090
            int r13 = r3.mEndId     // Catch:{ all -> 0x011e }
            if (r13 != r7) goto L_0x007a
            r4.remove(r8)     // Catch:{ all -> 0x011e }
            monitor-exit(r12)
            return r6
        L_0x007a:
            r4.remove(r8)     // Catch:{ all -> 0x011e }
            r3.mEndId = r7     // Catch:{ all -> 0x011e }
            boolean r13 = r12.updateRanges()     // Catch:{ all -> 0x011e }
            if (r13 == 0) goto L_0x0087
            monitor-exit(r12)
            return r6
        L_0x0087:
            r4.add(r8, r9)     // Catch:{ all -> 0x011e }
            int r13 = r9.mEndId     // Catch:{ all -> 0x011e }
            r3.mEndId = r13     // Catch:{ all -> 0x011e }
            monitor-exit(r12)
            return r1
        L_0x0090:
            com.android.internal.telephony.IntRangeManager$IntRange r13 = new com.android.internal.telephony.IntRangeManager$IntRange     // Catch:{ all -> 0x011e }
            r13.<init>(r3, r8)     // Catch:{ all -> 0x011e }
            if (r8 != 0) goto L_0x00b1
            java.lang.Object r15 = r4.get(r6)     // Catch:{ all -> 0x011e }
            com.android.internal.telephony.IntRangeManager$ClientRange r15 = (com.android.internal.telephony.IntRangeManager.ClientRange) r15     // Catch:{ all -> 0x011e }
            int r15 = r15.mStartId     // Catch:{ all -> 0x011e }
            int r0 = r3.mStartId     // Catch:{ all -> 0x011e }
            if (r15 == r0) goto L_0x00a7
            r13.mStartId = r15     // Catch:{ all -> 0x011e }
            r15 = r6
            goto L_0x00a8
        L_0x00a7:
            r15 = r1
        L_0x00a8:
            java.lang.Object r0 = r4.get(r6)     // Catch:{ all -> 0x011e }
            com.android.internal.telephony.IntRangeManager$ClientRange r0 = (com.android.internal.telephony.IntRangeManager.ClientRange) r0     // Catch:{ all -> 0x011e }
            int r7 = r0.mEndId     // Catch:{ all -> 0x011e }
            goto L_0x00b2
        L_0x00b1:
            r15 = r1
        L_0x00b2:
            java.util.ArrayList r0 = new java.util.ArrayList     // Catch:{ all -> 0x011e }
            r0.<init>()     // Catch:{ all -> 0x011e }
            int r8 = r8 + r6
        L_0x00b8:
            if (r8 >= r5) goto L_0x00e7
            java.lang.Object r9 = r4.get(r8)     // Catch:{ all -> 0x011e }
            com.android.internal.telephony.IntRangeManager$ClientRange r9 = (com.android.internal.telephony.IntRangeManager.ClientRange) r9     // Catch:{ all -> 0x011e }
            int r10 = r9.mStartId     // Catch:{ all -> 0x011e }
            int r11 = r7 + 1
            if (r10 <= r11) goto L_0x00d2
            r13.mEndId = r7     // Catch:{ all -> 0x011e }
            r0.add(r13)     // Catch:{ all -> 0x011e }
            com.android.internal.telephony.IntRangeManager$IntRange r13 = new com.android.internal.telephony.IntRangeManager$IntRange     // Catch:{ all -> 0x011e }
            r13.<init>(r9)     // Catch:{ all -> 0x011e }
            r15 = r6
            goto L_0x00df
        L_0x00d2:
            int r10 = r13.mEndId     // Catch:{ all -> 0x011e }
            int r11 = r9.mEndId     // Catch:{ all -> 0x011e }
            if (r10 >= r11) goto L_0x00da
            r13.mEndId = r11     // Catch:{ all -> 0x011e }
        L_0x00da:
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$ClientRange> r10 = r13.mClients     // Catch:{ all -> 0x011e }
            r10.add(r9)     // Catch:{ all -> 0x011e }
        L_0x00df:
            int r9 = r9.mEndId     // Catch:{ all -> 0x011e }
            if (r9 <= r7) goto L_0x00e4
            r7 = r9
        L_0x00e4:
            int r8 = r8 + 1
            goto L_0x00b8
        L_0x00e7:
            if (r7 >= r14) goto L_0x00ec
            r13.mEndId = r7     // Catch:{ all -> 0x011e }
            r15 = r6
        L_0x00ec:
            r0.add(r13)     // Catch:{ all -> 0x011e }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r13 = r12.mRanges     // Catch:{ all -> 0x011e }
            r13.remove(r2)     // Catch:{ all -> 0x011e }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r13 = r12.mRanges     // Catch:{ all -> 0x011e }
            r13.addAll(r2, r0)     // Catch:{ all -> 0x011e }
            if (r15 == 0) goto L_0x010d
            boolean r13 = r12.updateRanges()     // Catch:{ all -> 0x011e }
            if (r13 != 0) goto L_0x010d
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r13 = r12.mRanges     // Catch:{ all -> 0x011e }
            r13.removeAll(r0)     // Catch:{ all -> 0x011e }
            java.util.ArrayList<com.android.internal.telephony.IntRangeManager$IntRange> r13 = r12.mRanges     // Catch:{ all -> 0x011e }
            r13.add(r2, r3)     // Catch:{ all -> 0x011e }
            monitor-exit(r12)
            return r1
        L_0x010d:
            monitor-exit(r12)
            return r6
        L_0x010f:
            int r9 = r9.mEndId     // Catch:{ all -> 0x011e }
            if (r9 <= r7) goto L_0x0114
            r7 = r9
        L_0x0114:
            int r8 = r8 + 1
            goto L_0x0055
        L_0x0118:
            int r2 = r2 + 1
            goto L_0x0009
        L_0x011c:
            monitor-exit(r12)
            return r1
        L_0x011e:
            r13 = move-exception
            monitor-exit(r12)
            throw r13
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.IntRangeManager.disableRange(int, int, java.lang.String):boolean");
    }

    public boolean updateRanges() {
        startUpdate();
        populateAllRanges();
        return finishUpdate();
    }

    /* access modifiers changed from: protected */
    public boolean tryAddRanges(int i, int i2, boolean z) {
        startUpdate();
        populateAllRanges();
        addRange(i, i2, z);
        return finishUpdate();
    }

    public boolean isEmpty() {
        return this.mRanges.isEmpty();
    }

    private void populateAllRanges() {
        Iterator<IntRange> it = this.mRanges.iterator();
        while (it.hasNext()) {
            IntRange next = it.next();
            addRange(next.mStartId, next.mEndId, true);
        }
    }

    private void populateAllClientRanges() {
        int size = this.mRanges.size();
        for (int i = 0; i < size; i++) {
            IntRange intRange = this.mRanges.get(i);
            int size2 = intRange.mClients.size();
            for (int i2 = 0; i2 < size2; i2++) {
                ClientRange clientRange = intRange.mClients.get(i2);
                addRange(clientRange.mStartId, clientRange.mEndId, true);
            }
        }
    }

    public String toString() {
        return (String) this.mRanges.stream().map(new IntRangeManager$$ExternalSyntheticLambda0()).collect(Collectors.joining(","));
    }
}
