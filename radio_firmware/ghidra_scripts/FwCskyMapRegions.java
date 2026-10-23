// First pre-script for the HR-C7000 layout (docs/grok-deep-dive/11 §21.0). Expects the whole
// file imported with BinaryLoader at base 0x0301A000 (scripts/fw1_ghidra_csky.ps1 default).
// Copy descriptors at file +0xC4 give the RAM regions; this script
//   - cuts the flash block at file +0x39408 and removes the tail (that part runs from IRAM),
//   - maps IRAM 0x00010000 from file +0x39408 (initialised length = descriptor), then IRAM .bss
//     up to 0x50000,
//   - maps SRAM 0x18000800 from file +0x322E0 (descriptor length), plus 0x18000000..0x180007FF,
//   - adds uninitialised peripheral blocks: modem 0x11000000, modem buffer/codec 0x16000000,
//     APB 0x14000000 (HR-C7000 user guide §4.5.3, as in AtomXL's MapDmrMemory.java).
// Read-only on the firmware bytes. Other scripts translate file offsets with FwCskyMapRegions.addr().
// @category DMR.Analysis

import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.Program;
import ghidra.program.model.mem.Memory;
import ghidra.program.model.mem.MemoryBlock;

import java.io.ByteArrayInputStream;

public class FwCskyMapRegions extends GhidraScript {

    static final long FLASH_BASE = 0x0301A000L;

    @Override
    public void run() throws Exception {
        Memory m = currentProgram.getMemory();
        MemoryBlock flash = m.getBlock(toAddr(FLASH_BASE));
        if (flash == null) {
            println("FwCskyMapRegions: no block at 0x0301A000 (import with -loader-baseAddr 0x0301A000); nothing done");
            return;
        }
        if (m.getBlock("iram") != null) {
            println("FwCskyMapRegions: already mapped");
            return;
        }
        byte[] file = new byte[(int) flash.getSize()];
        flash.getBytes(flash.getStart(), file);
        long[] d = new long[6];
        for (int i = 0; i < 6; i++) d[i] = le32(file, 0xC4 + 4 * i);
        long sramDst = d[0], sramEnd = d[1], sramSrc = d[2] - FLASH_BASE;
        long iramDst = d[3], iramEnd = d[4], iramSrc = d[5] - FLASH_BASE;
        println(String.format("descriptors: SRAM %08X..%08X <- +%X, IRAM %08X..%08X <- +%X",
                sramDst, sramEnd, sramSrc, iramDst, iramEnd, iramSrc));

        m.split(flash, toAddr(FLASH_BASE + iramSrc));
        MemoryBlock tail = m.getBlock(toAddr(FLASH_BASE + iramSrc));
        m.removeBlock(tail, monitor);
        m.getBlock(toAddr(FLASH_BASE)).setName("flash");

        int iramLen = (int) (iramEnd - iramDst);
        block("iram", iramDst, file, (int) iramSrc, iramLen, true);
        long bss = (iramEnd + 0xF) & ~0xFL;
        m.createUninitializedBlock("iram_bss", toAddr(bss), 0x50000 - bss, false).setWrite(true);

        m.createUninitializedBlock("sram_lo", toAddr(0x18000000L), sramDst - 0x18000000L, false).setWrite(true);
        block("sram", sramDst, file, (int) sramSrc, (int) (sramEnd - sramDst), false);

        m.createUninitializedBlock("modem", toAddr(0x11000000L), 0x1000, false).setVolatile(true);
        m.createUninitializedBlock("modem_buffer", toAddr(0x16000000L), 0x1000, false).setVolatile(true);
        m.createUninitializedBlock("apb", toAddr(0x14000000L), 0x160000, false).setVolatile(true);
        println("FwCskyMapRegions: flash/iram/iram_bss/sram_lo/sram/modem/modem_buffer/apb mapped");
    }

    private void block(String name, long dst, byte[] file, int src, int len, boolean exec) throws Exception {
        byte[] b = new byte[len];
        System.arraycopy(file, src, b, 0, len);
        MemoryBlock blk = currentProgram.getMemory().createInitializedBlock(name, toAddr(dst),
                new ByteArrayInputStream(b), len, monitor, false);
        blk.setRead(true);
        blk.setWrite(true);
        blk.setExecute(exec);
    }

    private static long le32(byte[] b, int o) {
        return (b[o] & 0xFFL) | ((b[o + 1] & 0xFFL) << 8) | ((b[o + 2] & 0xFFL) << 16) | ((b[o + 3] & 0xFFL) << 24);
    }

    /** File offset -> address in the mapped program (identity when the program is a flat base-0 import). */
    static Address addr(GhidraScript s, Program p, long fileOff) {
        if (p.getMemory().getBlock("iram") == null) return p.getAddressFactory().getDefaultAddressSpace().getAddress(fileOff);
        long iramSrc = 0x39408L, iramLen = 0x21AF4L;
        long a = (fileOff >= iramSrc && fileOff < iramSrc + iramLen) ? 0x10000L + fileOff - iramSrc : FLASH_BASE + fileOff;
        return p.getAddressFactory().getDefaultAddressSpace().getAddress(a);
    }
}
