# PowerShell Script: Find Buggy contactType Skip
# Purpose: Locate CMP r2,#2 instructions followed by conditional branches
#          that skip group ID extraction code (LDRB offsets 5-7)
# Usage: Run from PowerShell in phonedmrapp directory
# Author: Based on expert firmware RE guidance (March 2026)

$firmwarePath = "radio_firmware\DMR003.UV4T.V022-ORIGINAL.bin"

if (-not (Test-Path $firmwarePath)) {
    Write-Host "❌ Firmware file not found: $firmwarePath"
    exit 1
}

Write-Host "=" * 80
Write-Host "DMR Firmware Bug Hunter - contactType=2 Group ID Skip Detection"
Write-Host "=" * 80
Write-Host ""

# Read entire firmware
$bytes = [System.IO.File]::ReadAllBytes($firmwarePath)
Write-Host "✓ Loaded firmware: $($bytes.Length) bytes"
Write-Host ""

# [1/4] Find CMP r2, #2 instructions (bytes: 02 2A in little-endian Thumb)
Write-Host "[1/4] Searching for CMP r2, #2 instructions..."
$cmp_pattern = @(0x02, 0x2A)
$cmp_locations = @()

for ($i = 0; $i -lt ($bytes.Length - 1); $i++) {
    if ($bytes[$i] -eq $cmp_pattern[0] -and $bytes[$i+1] -eq $cmp_pattern[1]) {
        $memAddr = $i + 0x08000000
        $cmp_locations += @{
            FileOffset = $i
            MemAddr = $memAddr
        }
    }
}

Write-Host "   Found $($cmp_locations.Count) CMP r2,#2 instructions"
Write-Host ""

# [2/4] Analyze each CMP for conditional branches and extraction patterns
Write-Host "[2/4] Analyzing candidates (checking for conditional branches + LDRB patterns)..."
$candidates = @()

foreach ($cmp in $cmp_locations) {
    $offset = $cmp.FileOffset
    
    # Check next 10 bytes for conditional branch opcodes
    # Thumb conditional branches: Bxx (opcode pattern Dxxx in little-endian)
    # B** opcodes: D0-DF (BEQ, BNE, BCS, BCC, BMI, BPL, BVS, BVC, BHI, BLS, BGE, BLT, BGT, BLE)
    $has_branch = $false
    $branch_offset = 0
    $branch_type = "UNKNOWN"
    
    for ($j = 2; $j -lt 12; $j += 2) {
        if ($offset + $j -ge $bytes.Length) { break }
        
        $opcode = $bytes[$offset + $j + 1]  # Second byte has opcode
        
        # Check if it's a conditional branch (0xD0-0xDF, excluding 0xDE=undefined, 0xDF=SWI)
        if ($opcode -ge 0xD0 -and $opcode -le 0xDD) {
            $has_branch = $true
            $branch_offset = $j
            
            $branch_type = switch ($opcode) {
                0xD0 { "BEQ (equal)" }
                0xD1 { "BNE (not equal)" }
                0xD2 { "BCS (carry set)" }
                0xD3 { "BCC (carry clear)" }
                0xD8 { "BHI (higher)" }
                0xD9 { "BLS (lower/same)" }
                0xDA { "BGE (greater/equal)" }
                0xDB { "BLT (less than)" }
                0xDC { "BGT (greater than)" }
                0xDD { "BLE (less/equal)" }
                default { "B?? (conditional)" }
            }
            break
        }
    }
    
    if (-not $has_branch) { continue }
    
    # [3/4] Search for LDRB patterns in ±100 bytes
    # LDRB with immediate: 01111xxx (0x78-0x7F)
    # We want: LDRB with offset #5, #6, #7
    $search_start = [Math]::Max(0, $offset - 100)
    $search_end = [Math]::Min($bytes.Length - 2, $offset + 100)
    
    $has_ldrb_5 = $false
    $has_ldrb_6 = $false
    $has_ldrb_7 = $false
    $has_shift_combine = $false
    $ldrb_locations = @()
    
    for ($k = $search_start; $k -lt $search_end; $k += 2) {
        $instr_byte = $bytes[$k]
        
        # Check for LDRB (opcode 0x78-0x7F)
        if (($instr_byte -band 0xF8) -eq 0x78) {
            # Extract offset field (bits 6-10)
            $offset_field = ($instr_byte -shr 3) -band 0x1F
            
            if ($offset_field -eq 5) {
                $has_ldrb_5 = $true
                $ldrb_locations += "LDRB #5 at +$($k - $offset)"
            }
            elseif ($offset_field -eq 6) {
                $has_ldrb_6 = $true
                $ldrb_locations += "LDRB #6 at +$($k - $offset)"
            }
            elseif ($offset_field -eq 7) {
                $has_ldrb_7 = $true
                $ldrb_locations += "LDRB #7 at +$($k - $offset)"
            }
        }
        
        # Check for LSL/ORR (shift and combine)
        # LSL: 00000xxx (0x00-0x07) - but need better detection
        # ORR: 010011xx (0x43) typically
        if ($k + 1 -lt $bytes.Length) {
            $next_byte = $bytes[$k + 1]
            # Simple heuristic: check for ORR pattern (0x43 in second byte)
            if ($next_byte -eq 0x43 -or $next_byte -eq 0x40) {
                $has_shift_combine = $true
            }
        }
    }
    
    # Score candidate
    $score = 0
    if ($has_ldrb_5) { $score += 3 }
    if ($has_ldrb_6) { $score += 3 }
    if ($has_ldrb_7) { $score += 3 }
    if ($has_shift_combine) { $score += 2 }
    
    if ($score -ge 3) {
        $confidence = "LOW"
        if ($score -ge 9) { $confidence = "HIGH" }
        elseif ($score -ge 6) { $confidence = "MEDIUM" }
        
        $candidates += @{
            MemAddr = "0x{0:X8}" -f $cmp.MemAddr
            FileOffset = "0x{0:X}" -f $cmp.FileOffset
            BranchType = $branch_type
            BranchOffset = $branch_offset
            Score = $score
            Confidence = $confidence
            HasLdrb5 = $has_ldrb_5
            HasLdrb6 = $has_ldrb_6
            HasLdrb7 = $has_ldrb_7
            HasShift = $has_shift_combine
            LdrbLocs = $ldrb_locations
        }
    }
}

Write-Host "   Found $($candidates.Count) candidates with extraction patterns nearby"
Write-Host ""

# [3/4] Sort and display results
Write-Host "[3/4] Analysis Results:"
Write-Host ""

$sorted_candidates = $candidates | Sort-Object -Property @{Expression={
    switch ($_.Confidence) {
        "HIGH" { 0 }
        "MEDIUM" { 1 }
        "LOW" { 2 }
        default { 3 }
    }
}}, @{Expression={-$_.Score}}

if ($sorted_candidates.Count -eq 0) {
    Write-Host "   ❌ No candidates found with extraction patterns"
    Write-Host ""
    Write-Host "   Possible reasons:"
    Write-Host "   - Pattern variations not detected (try Ghidra manual inspection)"
    Write-Host "   - Extraction uses different registers/offsets"
    Write-Host "   - Bug is in different code path"
} else {
    $idx = 1
    foreach ($cand in $sorted_candidates) {
        Write-Host "=" * 80
        Write-Host "CANDIDATE #$idx - Confidence: $($cand.Confidence) (Score: $($cand.Score)/11)"
        Write-Host "=" * 80
        Write-Host ""
        Write-Host "  Location (CMP): $($cand.MemAddr)"
        Write-Host "  File Offset: $($cand.FileOffset)"
        Write-Host ""
        Write-Host "  Branch: $($cand.BranchType) at +$($cand.BranchOffset) bytes"
        Write-Host ""
        Write-Host "  Extraction Pattern Detection:"
        Write-Host "    - LDRB offset #5 (byte 5): $(if($cand.HasLdrb5){'[+] FOUND'}else{'[ ] missing'})"
        Write-Host "    - LDRB offset #6 (byte 6): $(if($cand.HasLdrb6){'[+] FOUND'}else{'[ ] missing'})"
        Write-Host "    - LDRB offset #7 (byte 7): $(if($cand.HasLdrb7){'[+] FOUND'}else{'[ ] missing'})"
        Write-Host "    - LSL/ORR (combine): $(if($cand.HasShift){'[+] FOUND'}else{'[ ] missing'})"
        Write-Host ""
        
        if ($cand.LdrbLocs.Count -gt 0) {
            Write-Host "  LDRB Details:"
            foreach ($loc in $cand.LdrbLocs) {
                Write-Host "    • $loc"
            }
            Write-Host ""
        }
        
        if ($cand.Confidence -in @("HIGH", "MEDIUM")) {
            Write-Host "  🔧 RECOMMENDED ACTION:"
            Write-Host ""
            Write-Host "    1. Open Ghidra and navigate to $($cand.MemAddr)"
            Write-Host "    2. Press 'G' (goto), enter address"
            Write-Host "    3. Check decompiler (Window > Decompiler)"
            Write-Host "    4. Look for: if(contactType==2) { ...skip extraction... }"
            Write-Host "    5. Create patch: NOP the branch or invert condition"
            Write-Host ""
        }
        
        # Check if this matches documented locations
        $known = $false
        if ($cand.MemAddr -eq "0x08018F26") {
            Write-Host "  📝 NOTE: This is Location 1 from Patch 12 (documented)"
            $known = $true
        }
        elseif ($cand.MemAddr -eq "0x080490E2") {
            Write-Host "  📝 NOTE: This is Location 3 from Patch 13 (documented)"
            $known = $true
        }
        elseif ($cand.MemAddr -eq "0x080524FA") {
            Write-Host "  📝 NOTE: This is Location 5 (never tested)"
            $known = $true
        }
        
        Write-Host ""
        $idx++
    }
}

Write-Host ""
Write-Host "[4/4] Next Steps:"
Write-Host ""
Write-Host "1. Review HIGH/MEDIUM confidence candidates in Ghidra"
Write-Host "2. Navigate to memory addresses with 'G' key in Ghidra"
Write-Host "3. Press 'D' to disassemble if showing as data"
Write-Host "4. Check decompiler for if(contactType==2) logic"
Write-Host "5. Create patch and test with DMRDEBUG.bin"
Write-Host ""
Write-Host "=" * 80
Write-Host "Script complete! Found $($sorted_candidates.Count) candidates"
Write-Host "=" * 80
