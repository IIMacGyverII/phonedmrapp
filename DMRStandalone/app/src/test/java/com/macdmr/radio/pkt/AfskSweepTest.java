package com.macdmr.radio.pkt;

import org.junit.Test;

/** Parameter sweep on the benchmark (tone filter length, band-pass edges): prints a table, asserts nothing. */
public class AfskSweepTest {
    @Test public void sweep() throws Exception {
        short[][] a = { AfskBenchTest.wav("noise100_flat.wav"), AfskBenchTest.wav("noise100_pre.wav"), AfskBenchTest.wav("noise100_de.wav") };
        StringBuilder sb = new StringBuilder("filter  band-pass      flat  pre  de  total" + System.lineSeparator());
        for (int fs : new int[] { 44, 48, 52, 56, 64 })
            for (double[] bp : new double[][] { { 800, 2600 }, { 900, 2500 }, { 700, 2700 } }) {
                AFSKDecoderIQ.toneFilterSize = fs; AFSKDecoderIQ.bpLowHz = bp[0]; AFSKDecoderIQ.bpHighHz = bp[1];
                int f = AfskBenchTest.count(a[0], true, false, false, true), p = AfskBenchTest.count(a[1], true, false, false, true), d = AfskBenchTest.count(a[2], true, false, false, true);
                sb.append(String.format("%5d   %4.0f-%4.0f   %5d %4d %3d  %5d%n", fs, bp[0], bp[1], f, p, d, f + p + d));
            }
        AFSKDecoderIQ.toneFilterSize = 52; AFSKDecoderIQ.bpLowHz = 800; AFSKDecoderIQ.bpHighHz = 2600;
        System.out.println(sb);
    }
}
