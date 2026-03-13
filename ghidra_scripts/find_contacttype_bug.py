# Ghidra Script: Find Buggy contactType Skip
# Purpose: Locate CMP r2,#2 instructions followed by conditional branches
#          that skip group ID extraction code (LDRB offsets 5-7 + LSL/ORR)
# Usage: Run from Ghidra Script Manager on DMR003.UV4T.V022.bin project
# Author: Based on expert firmware RE guidance (March 2026)

from ghidra.program.model.block import BasicBlockModel
from ghidra.util.task import ConsoleTaskMonitor
from ghidra.program.model.lang import OperandType

monitor = ConsoleTaskMonitor()
fm = currentProgram.getFunctionManager()
mem = currentProgram.getMemory()
listing = currentProgram.getListing()

print("=" * 80)
print("DMR Firmware Bug Hunter - contactType=2 Group ID Skip Detection")
print("=" * 80)
print("")

# Find CMP #2 instructions (bytes: 02 2A for CMP r2, #2 in Thumb)
print("[1/4] Searching for CMP r2, #2 instructions...")
cmp_pattern = "02 2a"  # Little-endian Thumb: cmp r2, #0x2
cmp_addrs = []

# Search entire memory
start_addr = mem.getMinAddress()
while start_addr:
    found = mem.findBytes(start_addr, cmp_pattern, None, True, monitor)
    if not found:
        break
    cmp_addrs.append(found)
    start_addr = found.add(2)  # Move past found instruction

print("   Found {} CMP r2,#2 instructions".format(len(cmp_addrs)))
print("")

# Extraction pattern indicators (looking for these nearby)
# LDRB r0,[r3,#5] = 0x78 D8 (or similar with offset 5)
# LDRB r1,[r3,#6] = 0x79 D9 (offset 6)  
# LDRB r2,[r3,#7] = 0x7A DA (offset 7)
# LSL/ORR for combining bytes into 24-bit ID

print("[2/4] Analyzing candidates (checking for conditional branches + extraction patterns)...")
candidates = []

for idx, cmp_addr in enumerate(cmp_addrs):
    func = fm.getFunctionContaining(cmp_addr)
    func_name = func.getName() if func else "UNKNOWN"
    
    # Get the CMP instruction
    cmp_instr = listing.getInstructionAt(cmp_addr)
    if not cmp_instr:
        continue
    
    # Check next few instructions for conditional branches
    next_instr = cmp_instr.getNext()
    branch_count = 0
    check_limit = 5  # Check up to 5 instructions after CMP
    
    while next_instr and branch_count < check_limit:
        mnemonic = next_instr.getMnemonicString().upper()
        
        # Look for conditional branches (BEQ, BNE, BLS, BHI, BGT, BLE, etc.)
        if mnemonic.startswith('B') and len(mnemonic) > 1 and mnemonic[1] != 'L':
            # This is a conditional branch
            branch_target = None
            flows = next_instr.getFlows()
            if flows and len(flows) > 0:
                branch_target = flows[0]
            
            # Now search for extraction pattern
            # Check both before and after the branch (some compilers put extraction before CMP)
            
            # Search range: 100 bytes before CMP to 100 bytes after branch
            search_start = cmp_addr.subtract(100)
            search_end = branch_target.add(100) if branch_target else next_instr.getAddress().add(100)
            
            # Look for LDRB instructions loading from offsets 5, 6, 7
            has_ldrb_5 = False
            has_ldrb_6 = False
            has_ldrb_7 = False
            has_shift_combine = False
            
            search_addr = search_start
            while search_addr and search_addr.compareTo(search_end) < 0:
                search_instr = listing.getInstructionAt(search_addr)
                if search_instr:
                    search_mnem = search_instr.getMnemonicString().upper()
                    
                    # Check for LDRB with immediate offset
                    if search_mnem == "LDRB":
                        # Try to get the offset operand
                        op_count = search_instr.getNumOperands()
                        for op_idx in range(op_count):
                            op_type = search_instr.getOperandType(op_idx)
                            if (op_type & OperandType.SCALAR) != 0:
                                try:
                                    offset_val = search_instr.getScalar(op_idx).getValue()
                                    if offset_val == 5:
                                        has_ldrb_5 = True
                                    elif offset_val == 6:
                                        has_ldrb_6 = True
                                    elif offset_val == 7:
                                        has_ldrb_7 = True
                                except:
                                    pass
                    
                    # Check for LSL/ORR (shift and combine operations)
                    elif search_mnem in ["LSL", "LSLS", "ORR", "ORRS"]:
                        has_shift_combine = True
                
                search_addr = search_addr.add(2)  # Thumb instructions are 2 or 4 bytes
            
            # Scoring system
            extraction_score = 0
            if has_ldrb_5:
                extraction_score += 3
            if has_ldrb_6:
                extraction_score += 3
            if has_ldrb_7:
                extraction_score += 3
            if has_shift_combine:
                extraction_score += 2
            
            confidence = "UNKNOWN"
            if extraction_score >= 9:  # All 3 LDRBs + shift
                confidence = "HIGH"
            elif extraction_score >= 6:  # 2 LDRBs + shift or all 3 LDRBs
                confidence = "MEDIUM"
            elif extraction_score >= 3:  # At least 1 LDRB
                confidence = "LOW"
            
            if extraction_score >= 3:  # Only report if we found extraction indicators
                # Determine if branch skips extraction (is extraction after branch?)
                extraction_location = "UNKNOWN"
                if branch_target:
                    # Check if extraction pattern exists between CMP and branch target
                    pre_branch_start = cmp_addr
                    pre_branch_end = branch_target
                    has_extraction_in_skip = False
                    
                    test_addr = pre_branch_start
                    while test_addr and test_addr.compareTo(pre_branch_end) < 0:
                        test_instr = listing.getInstructionAt(test_addr)
                        if test_instr and test_instr.getMnemonicString().upper() == "LDRB":
                            has_extraction_in_skip = True
                            break
                        test_addr = test_addr.add(2)
                    
                    if has_extraction_in_skip:
                        extraction_location = "AFTER_BRANCH (skip-over pattern)"
                    else:
                        extraction_location = "BEFORE_CMP (inverse logic)"
                
                candidates.append({
                    'addr': cmp_addr.getOffset(),
                    'func': func_name,
                    'branch_mnem': mnemonic,
                    'branch_addr': next_instr.getAddress().getOffset(),
                    'branch_target': branch_target.getOffset() if branch_target else 0,
                    'confidence': confidence,
                    'score': extraction_score,
                    'ldrb_5': has_ldrb_5,
                    'ldrb_6': has_ldrb_6,
                    'ldrb_7': has_ldrb_7,
                    'shift_combine': has_shift_combine,
                    'extraction_loc': extraction_location
                })
        
        next_instr = next_instr.getNext()
        branch_count += 1

print("   Found {} candidates with extraction patterns nearby".format(len(candidates)))
print("")

# Sort by confidence and score
confidence_order = {'HIGH': 0, 'MEDIUM': 1, 'LOW': 2, 'UNKNOWN': 3}
candidates_sorted = sorted(candidates, key=lambda x: (confidence_order[x['confidence']], -x['score']))

print("[3/4] Analysis Results:")
print("")

if len(candidates_sorted) == 0:
    print("   ❌ No candidates found with extraction patterns")
    print("")
    print("   Possible reasons:")
    print("   - Pattern variations not detected (try manual inspection)")
    print("   - Extraction uses different registers/offsets")
    print("   - Bug is in different code path (not using CMP r2,#2)")
    print("   - Ghidra needs better disassembly (try Force Thumb on undefined regions)")
else:
    for idx, cand in enumerate(candidates_sorted):
        print("=" * 80)
        print("CANDIDATE #{} - Confidence: {} (Score: {}/11)".format(idx + 1, cand['confidence'], cand['score']))
        print("=" * 80)
        print("")
        print("  Location (CMP): 0x{:08X}".format(cand['addr']))
        print("  Function: {}".format(cand['func']))
        print("")
        print("  Branch Instruction: {} at 0x{:08X}".format(cand['branch_mnem'], cand['branch_addr']))
        print("  Branch Target: 0x{:08X}".format(cand['branch_target']))
        print("")
        print("  Extraction Pattern Detection:")
        print("    - LDRB offset #5 (byte 5): {}".format("✓ FOUND" if cand['ldrb_5'] else "✗ missing"))
        print("    - LDRB offset #6 (byte 6): {}".format("✓ FOUND" if cand['ldrb_6'] else "✗ missing"))
        print("    - LDRB offset #7 (byte 7): {}".format("✓ FOUND" if cand['ldrb_7'] else "✗ missing"))
        print("    - LSL/ORR (combine): {}".format("✓ FOUND" if cand['shift_combine'] else "✗ missing"))
        print("")
        print("  Extraction Location: {}".format(cand['extraction_loc']))
        print("")
        
        # Patch recommendation
        if cand['confidence'] in ['HIGH', 'MEDIUM']:
            print("  🔧 RECOMMENDED PATCH:")
            print("")
            if "skip-over" in cand['extraction_loc']:
                print("    Problem: Branch at 0x{:08X} skips extraction code".format(cand['branch_addr']))
                print("    Solution: NOP the branch instruction")
                print("    Bytes: Change conditional branch to 00 BF (NOP)")
            else:
                print("    Problem: Logic may be inverted (extraction before CMP)")
                print("    Solution: Verify in decompiler, may need to invert branch condition")
            print("")
            print("    Steps:")
            print("    1. Navigate to 0x{:08X} in Ghidra".format(cand['addr']))
            print("    2. Check decompiler view (Window > Decompiler)")
            print("    3. Look for: if(contactType==2) {{ ...skip extraction... }}")
            print("    4. Create patch: Copy bin, modify bytes, test")
            print("")
        else:
            print("  ⚠️  Low confidence - manual verification needed")
            print("")
        
        print("")

print("[4/4] Next Steps:")
print("")
print("1. Review HIGH/MEDIUM confidence candidates in Ghidra decompiler")
print("2. Check function names - look for 'receive', 'decode', 'dmr', 'frame'")
print("3. Cross-reference with documented locations (0x08018F26, 0x080490E2, etc.)")
print("4. Verify extraction pattern in decompiler (should see frame[5]|frame[6]<<8|frame[7]<<16)")
print("5. Create patch file and test with DMRDEBUG.bin")
print("")
print("=" * 80)
print("Script complete!")
print("=" * 80)
