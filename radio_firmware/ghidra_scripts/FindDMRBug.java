// Ghidra Java Script: Find DMR Monitor Mode Bug
// @author Grok / XMacGyverX
// @category DMR.Analysis
// @keybinding
// @menupath Tools.DMR.Find Monitor Mode Bug
// @toolbar

import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.*;
import ghidra.program.model.mem.*;
import ghidra.program.model.symbol.*;
import java.util.*;

public class FindDMRBug extends GhidraScript {
    
    // Known contactType CMP #2 locations from manual analysis
    private long[] CMP_LOCATIONS = {
        0x08018F26L, 0x080392C9L, 0x080490E2L, 0x080524E0L, 0x080524FAL
    };
    
    @Override
    public void run() throws Exception {
        println("======================================================================");
        println("DMR MONITOR MODE BUG FINDER");
        println("Automated analysis for contactType=2 group ID extraction bug");
        println("======================================================================");
        println("");
        
        // Step 1: Analyze known CMP locations
        println("[1/4] Analyzing known contactType comparison locations...");
        analyzeCMPLocations();
        
        // Step 2: Search for 0xFFFFFF patterns
        println("");
        println("[2/4] Searching for 0xFFFFFF constant patterns...");
        findFFFFFFPatterns();
        
        // Step 3: Search for CMP r2, #2 patterns
        println("");
        println("[3/4] Searching for CMP r2, #2 instruction patterns...");
        findCMPPatterns();
        
        // Step 4: Analyze branches at Location 1 and 3
        println(""); 
        println("[4/4] Analyzing control flow at eliminated locations...");
        analyzeEliminatedLocations();
        
        println("");
        println("======================================================================");
        println("ANALYSIS COMPLETE - See findings above");
        println("======================================================================");
        println("");
        println("RECOMMENDATION:");
        println("Check locations that have CMP r2, #2 followed by conditional branches");
        println("that we haven't tested yet (Locations 2, 4, 5).");
        println("");
        println("Manual next steps:");
        println("1. Navigate to untested locations in Ghidra GUI");
        println("2. Check decompiler window for contactType logic");  
        println("3. Look for branches that skip 24-bit extraction sequences");
        println("");
    }
    
    private void analyzeCMPLocations() {
        for (long addr : CMP_LOCATIONS) {
            Address address = toAddr(addr);
            Instruction instr = getInstructionAt(address);
            
            if (instr != null) {
                println(String.format("  0x%08X: %s", addr, instr));
                
                // Get function containing this address
                Function func = getFunctionContaining(address);
                if (func != null) {
                    println(String.format("    Function: %s at 0x%08X", 
                        func.getName(), func.getEntryPoint().getOffset()));
                    
                    // Count references to this function
                    Reference[] refs = getReferencesTo(func.getEntryPoint());
                    println(String.format("    Called by: %d functions", refs.length));
                }
                
                // Look at next few instructions
                Address nextAddr = address.add(2);
                for (int i = 0; i < 5 && nextAddr != null; i++) {
                    Instruction nextInstr = getInstructionAt(nextAddr);
                    if (nextInstr != null) {
                        println(String.format("    +%d: %s", i*2+2, nextInstr));
                        nextAddr = nextInstr.getMaxAddress().add(1);
                    } else {
                        break;
                    }
                }
                println("");
            } else {
                println(String.format("  0x%08X: No instruction found", addr));
            }
        }
    }
    
    private void findFFFFFFPatterns() {
        byte[] pattern = new byte[] {(byte)0xFF, (byte)0xFF, (byte)0xFF};
        Memory memory = currentProgram.getMemory();
        Address startAddr = currentProgram.getMinAddress();
        int count = 0;
        
        try {
            Address found = memory.findBytes(startAddr, pattern, null, true, monitor);
            while (found != null && count < 30) {
                // Check if in code section
                Instruction instr = getInstructionContaining(found);
                if (instr != null) {
                    println(String.format("  0x%08X: %s (in instruction)", 
                        found.getOffset(), instr));
                    count++;
                }
                
                found = memory.findBytes(found.add(1), pattern, null, true, monitor);
            }
            
            if (count == 0) {
                println("  No 0xFFFFFF patterns found in code sections");
            } else if (count >= 30) {
                println(String.format("  ... (showing first 30 of many)"));
            }
        } catch (Exception e) {
            println("  Error searching: " + e.getMessage());
        }
    }
    
    private void findCMPPatterns() {
        // Pattern for "CMP r2, #2" in Thumb mode: 02 2A
        byte[] pattern = new byte[] {0x02, 0x2A};
        Memory memory = currentProgram.getMemory();
        Address startAddr = currentProgram.getMinAddress();
        int count = 0;
        
        try {
            Address found = memory.findBytes(startAddr, pattern, null, true, monitor);
            while (found != null && count < 20) {
                Instruction instr = getInstructionAt(found);
                if (instr != null && instr.getMnemonicString().equals("cmp")) {
                    println(String.format("  0x%08X: %s", found.getOffset(), instr));
                    
                    Function func = getFunctionContaining(found);
                    if (func != null) {
                        println(String.format("    In function: %s", func.getName()));
                    }
                    count++;
                }
                
                found = memory.findBytes(found.add(1), pattern, null, true, monitor);
            }
            
            if (count == 0) {
                println("  No CMP r2, #2 patterns found");
            }
        } catch (Exception e) {
            println("  Error searching: " + e.getMessage());
        }
    }
    
    private void analyzeEliminatedLocations() {
        println("");
        println("Location 1 (0x08018F26): TESTED 7 times - NOT the bug");
        analyzeDetailedLocation(0x08018F26L);
        
        println("");
        println("Location 3 (0x080490E2): TESTED - NOT the bug");
        analyzeDetailedLocation(0x080490E2L);
    }
    
    private void analyzeDetailedLocation(long addr) {
        Address address = toAddr(addr);
        Function func = getFunctionContaining(address);
        
        if (func != null) {
            println(String.format("  Function: %s", func.getName()));
            println(String.format("  Entry: 0x%08X", func.getEntryPoint().getOffset()));
            println(String.format("  Size: %d bytes", func.getBody().getNumAddresses()));
            
            // Show calling functions
            Reference[] refs = getReferencesTo(func.getEntryPoint());
            if (refs.length > 0) {
                println("  Called by:");
                for (Reference ref : refs) {
                    Function caller = getFunctionContaining(ref.getFromAddress());
                    if (caller != null) {
                        println(String.format("    - %s at 0x%08X", 
                            caller.getName(), caller.getEntryPoint().getOffset()));
                    }
                }
            }
        }
    }
}
