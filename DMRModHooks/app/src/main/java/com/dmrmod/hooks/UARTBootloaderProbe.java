package com.dmrmod.hooks;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import de.robv.android.xposed.XposedBridge;

/**
 * UART Bootloader Probe
 * 
 * Tests for STM32-style bootloader access on the HR_C6000 radio module.
 * Based on AN3155 protocol - attempts to detect if we can access flash memory.
 * 
 * SAFETY: All methods here are read-only or safe probes. No destructive operations.
 * 
 * Usage:
 * 1. Call probeBootloader() during app idle time
 * 2. Check result - if ACK received, we can attempt flash operations
 * 3. Use readPatchLocation() to verify current firmware state
 * 
 * STM32 Bootloader Commands (AN3155):
 * - 0x7F: Sync/Entry byte
 * - 0x00 0xFF: Get (returns list of supported commands)
 * - 0x02 0xFD: Get ID (returns chip ID)
 * - 0x11 0xEE: Read Memory
 * - 0x31 0xCE: Write Memory (not used yet - would enable permanent patch)
 * - 0x43 0xBC: Erase (not used - too dangerous without confirmation)
 * 
 * Response codes:
 * - 0x79: ACK (command accepted)
 * - 0x1F: NACK (command rejected or not supported)
 */
public class UARTBootloaderProbe {
    
    private static final String TAG = "DMRModHooks:BootloaderProbe";
    private static final String UART_DEVICE = "/dev/ttyS1"; // Radio module UART
    
    // STM32 Bootloader commands
    private static final byte SYNC_BYTE = (byte) 0x7F;
    private static final byte CMD_GET = (byte) 0x00;
    private static final byte CMD_GET_COMPLEMENT = (byte) 0xFF;
    private static final byte CMD_GET_ID = (byte) 0x02;
    private static final byte CMD_GET_ID_COMPLEMENT = (byte) 0xFD;
    private static final byte CMD_READ_MEMORY = (byte) 0x11;
    private static final byte CMD_READ_MEMORY_COMPLEMENT = (byte) 0xEE;
    
    // Response codes
    private static final byte ACK = (byte) 0x79;
    private static final byte NACK = (byte) 0x1F;
    
    // Patch location in flash
    private static final int PATCH_ADDRESS = 0x08018F2C;
    private static final byte[] ORIGINAL_BYTES = {(byte) 0x0E, (byte) 0xD9}; // BLS instruction
    private static final byte[] PATCHED_BYTES = {(byte) 0x00, (byte) 0xBF}; // NOP instruction
    
    /**
     * Probe for STM32 bootloader on radio module UART
     * 
     * This is a SAFE, read-only test. It will:
     * 1. Send sync byte (0x7F)
     * 2. Wait for ACK (0x79)
     * 3. If ACK, send Get command to list supported operations
     * 4. Parse response to see if Write/Erase commands available
     * 
     * @return ProbeResult with details of what was found
     */
    public static ProbeResult probeBootloader() {
        ProbeResult result = new ProbeResult();
        FileInputStream uart_in = null;
        FileOutputStream uart_out = null;
        
        try {
            XposedBridge.log(TAG + ": 🔍 Starting bootloader probe on " + UART_DEVICE);
            
            // Open UART device
            uart_out = new FileOutputStream(UART_DEVICE);
            uart_in = new FileInputStream(UART_DEVICE);
            
            // Step 1: Send sync byte
            XposedBridge.log(TAG + ": → Sending SYNC byte (0x7F)");
            uart_out.write(SYNC_BYTE);
            uart_out.flush();
            
            // Wait for response (timeout 100ms)
            Thread.sleep(100);
            
            if (uart_in.available() > 0) {
                byte response = (byte) uart_in.read();
                XposedBridge.log(TAG + ": ← Received: 0x" + Integer.toHexString(response & 0xFF));
                
                if (response == ACK) {
                    XposedBridge.log(TAG + ": ✅ ACK received! Bootloader is responsive!");
                    result.bootloaderFound = true;
                    
                    // Step 2: Send Get command to enumerate capabilities
                    XposedBridge.log(TAG + ": → Sending GET command (0x00 0xFF)");
                    uart_out.write(CMD_GET);
                    uart_out.write(CMD_GET_COMPLEMENT);
                    uart_out.flush();
                    
                    Thread.sleep(100);
                    
                    if (uart_in.available() > 0) {
                        byte ack2 = (byte) uart_in.read();
                        if (ack2 == ACK) {
                            XposedBridge.log(TAG + ": ✅ GET command ACKed!");
                            
                            // Read number of commands
                            int numCommands = uart_in.read() + 1; // N+1 bytes
                            XposedBridge.log(TAG + ": Bootloader supports " + numCommands + " commands");
                            
                            // Read version
                            int version = uart_in.read();
                            XposedBridge.log(TAG + ": Bootloader version: 0x" + Integer.toHexString(version));
                            result.bootloaderVersion = version;
                            
                            // Read command list
                            byte[] commands = new byte[numCommands];
                            uart_in.read(commands);
                            
                            // Check for Write Memory command (0x31)
                            for (byte cmd : commands) {
                                XposedBridge.log(TAG + ":  - Command: 0x" + Integer.toHexString(cmd & 0xFF));
                                if (cmd == 0x31) {
                                    result.writeMemorySupported = true;
                                    XposedBridge.log(TAG + ": ⭐ Write Memory (0x31) SUPPORTED!");
                                }
                                if (cmd == 0x43) {
                                    result.eraseSupported = true;
                                    XposedBridge.log(TAG + ": ⭐ Erase (0x43) SUPPORTED!");
                                }
                                if (cmd == 0x11) {
                                    result.readMemorySupported = true;
                                }
                            }
                            
                            // Final ACK
                            byte finalAck = (byte) uart_in.read();
                            if (finalAck == ACK) {
                                XposedBridge.log(TAG + ": ✅ GET command completed successfully!");
                            }
                        }
                    }
                } else if (response == NACK) {
                    XposedBridge.log(TAG + ": ❌ NACK received - bootloader not accessible");
                } else {
                    XposedBridge.log(TAG + ": ⚠️ Unexpected response: 0x" + Integer.toHexString(response & 0xFF));
                }
            } else {
                XposedBridge.log(TAG + ": ⚠️ No response to SYNC byte (timeout)");
            }
            
        } catch (IOException e) {
            XposedBridge.log(TAG + ": ❌ IO Error: " + e.getMessage());
            result.error = e.getMessage();
        } catch (InterruptedException e) {
            XposedBridge.log(TAG + ": ⚠️ Interrupted: " + e.getMessage());
        } finally {
            try {
                if (uart_in != null) uart_in.close();
                if (uart_out != null) uart_out.close();
            } catch (IOException e) {
                // Ignore cleanup errors
            }
        }
        
        return result;
    }
    
    /**
     * Read 2 bytes from patch location to check if patch is loaded
     * 
     * Uses Read Memory command (0x11) if bootloader is accessible.
     * 
     * @return PatchStatus indicating current firmware state
     */
    public static PatchStatus readPatchLocation() {
        PatchStatus status = new PatchStatus();
        FileInputStream uart_in = null;
        FileOutputStream uart_out = null;
        
        try {
            XposedBridge.log(TAG + ": 🔍 Reading patch location (0x" + Integer.toHexString(PATCH_ADDRESS) + ")");
            
            uart_out = new FileOutputStream(UART_DEVICE);
            uart_in = new FileInputStream(UART_DEVICE);
            
            // Send sync
            uart_out.write(SYNC_BYTE);
            uart_out.flush();
            Thread.sleep(50);
            
            if (uart_in.available() > 0 && uart_in.read() == ACK) {
                // Send Read Memory command
                uart_out.write(CMD_READ_MEMORY);
                uart_out.write(CMD_READ_MEMORY_COMPLEMENT);
                uart_out.flush();
                Thread.sleep(50);
                
                if (uart_in.available() > 0 && uart_in.read() == ACK) {
                    // Send address (big-endian, 4 bytes + checksum)
                    byte[] addr = new byte[5];
                    addr[0] = (byte) ((PATCH_ADDRESS >> 24) & 0xFF);
                    addr[1] = (byte) ((PATCH_ADDRESS >> 16) & 0xFF);
                    addr[2] = (byte) ((PATCH_ADDRESS >> 8) & 0xFF);
                    addr[3] = (byte) (PATCH_ADDRESS & 0xFF);
                    addr[4] = (byte) (addr[0] ^ addr[1] ^ addr[2] ^ addr[3]); // XOR checksum
                    
                    uart_out.write(addr);
                    uart_out.flush();
                    Thread.sleep(50);
                    
                    if (uart_in.available() > 0 && uart_in.read() == ACK) {
                        // Send length (N+1 format: 1 byte = read 2 bytes, + checksum)
                        uart_out.write(0x01); // N = 1 (read 2 bytes)
                        uart_out.write(0xFE); // Complement
                        uart_out.flush();
                        Thread.sleep(50);
                        
                        if (uart_in.available() > 0 && uart_in.read() == ACK) {
                            // Read 2 bytes
                            byte[] data = new byte[2];
                            uart_in.read(data);
                            
                            XposedBridge.log(TAG + ": Read bytes: 0x" + Integer.toHexString(data[0] & 0xFF) + 
                                           " 0x" + Integer.toHexString(data[1] & 0xFF));
                            
                            // Check what we got
                            if (data[0] == ORIGINAL_BYTES[0] && data[1] == ORIGINAL_BYTES[1]) {
                                status.patchLoaded = false;
                                status.message = "Original firmware (BLS instruction)";
                                XposedBridge.log(TAG + ": ❌ Patch NOT loaded - original BLS present");
                            } else if (data[0] == PATCHED_BYTES[0] && data[1] == PATCHED_BYTES[1]) {
                                status.patchLoaded = true;
                                status.message = "Patched firmware (NOP instruction)";
                                XposedBridge.log(TAG + ": ✅ Patch IS loaded - NOP present");
                            } else {
                                status.patchLoaded = false;
                                status.message = "Unknown bytes: 0x" + Integer.toHexString(data[0] & 0xFF) + 
                                               " 0x" + Integer.toHexString(data[1] & 0xFF);
                                XposedBridge.log(TAG + ": ⚠️ Unexpected bytes at patch location!");
                            }
                            
                            status.success = true;
                        }
                    }
                }
            }
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": ❌ Read failed: " + e.getMessage());
            status.error = e.getMessage();
        } finally {
            try {
                if (uart_in != null) uart_in.close();
                if (uart_out != null) uart_out.close();
            } catch (IOException e) {
                // Ignore
            }
        }
        
        return status;
    }
    
    /**
     * Result of bootloader probe operation
     */
    public static class ProbeResult {
        public boolean bootloaderFound = false;
        public int bootloaderVersion = 0;
        public boolean writeMemorySupported = false;
        public boolean eraseSupported = false;
        public boolean readMemorySupported = false;
        public String error = null;
        
        public boolean canFlashPermanently() {
            return bootloaderFound && writeMemorySupported && eraseSupported;
        }
        
        @Override
        public String toString() {
            if (error != null) {
                return "Error: " + error;
            }
            if (!bootloaderFound) {
                return "Bootloader not accessible";
            }
            return String.format("Bootloader v0x%02X found! Write:%s Erase:%s Read:%s",
                bootloaderVersion,
                writeMemorySupported ? "YES" : "NO",
                eraseSupported ? "YES" : "NO",
                readMemorySupported ? "YES" : "NO");
        }
    }
    
    /**
     * Status of patch in flash/RAM
     */
    public static class PatchStatus {
        public boolean success = false;
        public boolean patchLoaded = false;
        public String message = "";
        public String error = null;
        
        @Override
        public String toString() {
            if (error != null) {
                return "Error: " + error;
            }
            if (!success) {
                return "Read failed";
            }
            return (patchLoaded ? "✓ " : "✗ ") + message;
        }
    }
}
