# Detailed ARM Thumb Instruction Analysis for CMP r2,#2 Locations
# Decodes instructions around each location to understand code context

$firmwarePath = "C:\Users\Joshua\Documents\android\phonedmrapp\radio_firmware\DMR003.UV4T.V022-ORIGINAL.bin"
$bytes = [System.IO.File]::ReadAllBytes($firmwarePath)

function Decode-ThumbInstruction {
    param($byte0, $byte1)
    
    $instr = ($byte1 -shl 8) -bor $byte0
    
    # CMP immediate
    if (($byte1 -band 0xF8) -eq 0x28) {
        $reg = $byte1 -band 0x07
        $imm = $byte0
        return "cmp r$reg, #$imm"
    }
    
    # Conditional branches (0xD0-0xDD)
    if ($byte1 -ge 0xD0 -and $byte1 -le 0xDD) {
        $cond = switch ($byte1) {
            0xD0 { "eq" }; 0xD1 { "ne" }; 0xD2 { "cs" }; 0xD3 { "cc" }
            0xD4 { "mi" }; 0xD5 { "pl" }; 0xD6 { "vs" }; 0xD7 { "vc" }
            0xD8 { "hi" }; 0xD9 { "ls" }; 0xDA { "ge" }; 0xDB { "lt" }
            0xDC { "gt" }; 0xDD { "le" }
            default { "??" }
        }
        $offset = if ($byte0 -band 0x80) { ($byte0 -bor 0xFFFFFF00) } else { $byte0 }
        $target = ($offset * 2) + 4
        return "b$cond <+$target>"
    }
    
    # CBZ/CBNZ (0xB1xx, 0xB9xx, 0xB3xx, 0xBBxx)
    if (($byte1 -band 0xF5) -eq 0xB1) {
        $is_nz = ($byte1 -band 0x08) -ne 0
        $reg = $byte0 -band 0x07
        $i = ($byte1 -band 0x02) -shr 1
        $imm5 = ($byte0 -band 0xF8) -shr 3
        $offset = ($i -shl 6) -bor ($imm5 -shl 1)
        $op = if ($is_nz) { "cbnz" } else { "cbz" }
        return "$op r$reg, <+$offset>"
    }
    
    # LDR immediate (01101xxx)
    if (($byte1 -band 0xF8) -eq 0x68) {
        $rd = $byte0 -band 0x07
        $rn = ($byte0 -band 0x38) -shr 3
        $imm = ($byte1 -band 0x07) -shl 2
        return "ldr r$rd, [r$rn, #$imm]"
    }
    
    # LDR immediate (01101xxx with higher bits)
    if (($byte0 -band 0xF8) -eq 0x68) {
        $rt = ($byte1 -band 0x07)
        $rn = ($byte1 -band 0x38) -shr 3
        $imm = ($byte0 -band 0x07) -shl 2
        return "ldr r$rt, [r$rn, #$imm]"
    }
    
    # LDRB immediate (01111xxx)
    if (($byte1 -band 0xF8) -eq 0x78) {
        $rd = $byte0 -band 0x07
        $rn = ($byte0 -band 0x38) -shr 3
        $offset = $byte1 -band 0x1F
        return "ldrb r$rd, [r$rn, #$offset]"
    }
    
    # MOVS immediate (00100xxx)
    if (($byte1 -band 0xF8) -eq 0x20) {
        $rd = $byte1 -band 0x07
        $imm = $byte0
        return "movs r$rd, #$imm"
    }
    
    # ADDS immediate (00110xxx)
    if (($byte1 -band 0xF8) -eq 0x30) {
        $rd = $byte1 -band 0x07
        $imm = $byte0
        return "adds r$rd, #$imm"
    }
    
    # LSL/LSR immediate
    if (($byte1 -band 0xF8) -eq 0x00) {
        $rd = $byte0 -band 0x07
        $rm = ($byte0 -band 0x38) -shr 3
        $imm = (($byte1 -band 0x07) -shl 2) -bor (($byte0 -band 0xC0) -shr 6)
        if ($imm -eq 0) { return "movs r$rd, r$rm" }
        return "lsls r$rd, r$rm, #$imm"
    }
    
    if (($byte1 -band 0xF8) -eq 0x08) {
        $rd = $byte0 -band 0x07
        $rm = ($byte0 -band 0x38) -shr 3
        $imm = (($byte1 -band 0x07) -shl 2) -bor (($byte0 -band 0xC0) -shr 6)
        return "lsrs r$rd, r$rm, #$imm"
    }
    
    # ORR register
    if ($byte1 -eq 0x43 -and ($byte0 -band 0xC0) -eq 0x00) {
        $rd = $byte0 -band 0x07
        $rm = ($byte0 -band 0x38) -shr 3
        return "orrs r$rd, r$rm"
    }
    
    # BL (long branch with link) - 32-bit instruction
    if (($byte1 -band 0xF8) -eq 0xF0) {
        return "bl <...> (32-bit)"
    }
    
    # Unknown
    $hex = "{0:X2}{1:X2}" -f $byte1, $byte0
    return "??? [$hex]"
}

Write-Host "=" * 80
Write-Host "DETAILED ARM THUMB INSTRUCTION ANALYSIS"
Write-Host "=" * 80
Write-Host ""

$locations = @(
    @{Addr=0x08018F26; Offset=0x18F26; Name="Location 1 (Patch 12)"},
    @{Addr=0x080392C9; Offset=0x392C9; Name="Location 2 (data table)"},
    @{Addr=0x080490E2; Offset=0x490E2; Name="Location 3 (Patch 13 - BGT)"},
    @{Addr=0x080524E0; Offset=0x524E0; Name="Location 4 (bad instructions)"},
    @{Addr=0x080524FA; Offset=0x524FA; Name="Location 5 (never tested)"}
)

foreach ($loc in $locations) {
    Write-Host ""
    Write-Host "=" * 80
    Write-Host $loc.Name
    Write-Host "Address: 0x{0:X8}" -f $loc.Addr
    Write-Host "=" * 80
    Write-Host ""
    
    $offset = $loc.Offset
    
    # Disassemble ±20 bytes
    Write-Host "DISASSEMBLY (±20 bytes):"
    Write-Host ("-" * 80)
    
    $start = $offset - 20
    $end = $offset + 20
    
    for ($i = $start; $i -lt $end; $i += 2) {
        if ($i -lt 0 -or $i + 1 -ge $bytes.Length) { continue }
        
        $addr = $i + 0x08000000
        $byte0 = $bytes[$i]
        $byte1 = $bytes[$i + 1]
        
        $disasm = Decode-ThumbInstruction $byte0 $byte1
        
        $marker = if ($i -eq $offset) { ">>> " } else { "    " }
        $addr_str = "0x{0:X8}" -f $addr
        $bytes_str = "{0:X2} {1:X2}" -f $byte0, $byte1
        
        Write-Host "$marker$addr_str  $bytes_str  $disasm"
    }
    
    Write-Host ""
    Write-Host "ANALYSIS:"
    Write-Host ("-" * 80)
    
    # Check what comes after CMP
    $found_patterns = @()
    
    # Check for conditional branches
    for ($j = 2; $j -lt 12; $j += 2) {
        if ($offset + $j + 1 -ge $bytes.Length) { break }
        $b1 = $bytes[$offset + $j + 1]
        
        if ($b1 -ge 0xD0 -and $b1 -le 0xDD) {
            $cond = switch ($b1) {
                0xD0 { "BEQ (branch if equal)" }
                0xD1 { "BNE (branch if not equal)" }
                0xD8 { "BHI (branch if higher)" }
                0xD9 { "BLS (branch if lower/same)" }
                0xDA { "BGE (branch if >=)" }
                0xDB { "BLT (branch if <)" }
                0xDC { "BGT (branch if >)" }
                0xDD { "BLE (branch if <=)" }
                default { "B??" }
            }
            $found_patterns += "- Conditional branch: $cond at +$j bytes"
            
            # Analyze what condition means for contactType=2
            if ($b1 -eq 0xD9) {
                $found_patterns += "  * BLS would branch if r2 <= 2 (INCLUDES contactType=2!)"
            }
            elseif ($b1 -eq 0xDC) {
                $found_patterns += "  * BGT would branch if r2 > 2 (EXCLUDES contactType=2)"
            }
            elseif ($b1 -eq 0xD0) {
                $found_patterns += "  * BEQ would branch if r2 == 2 (EXACT MATCH for contactType=2!)"
            }
        }
        
        # Check for CBZ/CBNZ
        if (($b1 -band 0xF5) -eq 0xB1) {
            $is_cbz = ($b1 -band 0x08) -eq 0
            $op = if ($is_cbz) { "CBZ (branch if zero)" } else { "CBNZ (branch if non-zero)" }
            $found_patterns += "- $op at +$j bytes"
        }
    }
    
    # Check for data loads nearby
    $load_count = 0
    for ($k = $offset - 30; $k -lt $offset + 30; $k += 2) {
        if ($k -lt 0 -or $k + 1 -ge $bytes.Length) { continue }
        $b1 = $bytes[$k + 1]
        
        if (($b1 -band 0xF8) -eq 0x68) {
            $load_count++
        }
    }
    
    if ($load_count -gt 0) {
        $found_patterns += "- Found $load_count LDR (load word) instructions nearby"
    }
    
    # Check for bit manipulation (shifts, OR)
    $shift_count = 0
    for ($k = $offset - 20; $k -lt $offset + 30; $k += 2) {
        if ($k -lt 0 -or $k + 1 -ge $bytes.Length) { continue }
        $b0 = $bytes[$k]
        $b1 = $bytes[$k + 1]
        
        # LSL/LSR
        if (($b1 -band 0xF8) -eq 0x00 -or ($b1 -band 0xF8) -eq 0x08) {
            $shift_count++
        }
        # ORR
        if ($b1 -eq 0x43 -and ($b0 -band 0xC0) -eq 0x00) {
            $shift_count++
        }
    }
    
    if ($shift_count -gt 0) {
        $found_patterns += "- Found $shift_count bit manipulation instructions (LSL/LSR/ORR)"
        $found_patterns += "  * Could indicate multi-byte value assembly (group ID extraction!)"
    }
    
    if ($found_patterns.Count -eq 0) {
        Write-Host "[ ] No significant patterns found - likely data or unrelated code"
    }
    else {
        foreach ($pattern in $found_patterns) {
            Write-Host $pattern
        }
    }
    
    Write-Host ""
    
    # Calculate likelihood score
    $score = 0
    $reasons = @()
    
    # Points for conditional branch that includes contactType=2
    if ($found_patterns -match "BLS.*INCLUDES") {
        $score += 5
        $reasons += "BLS branch would catch contactType=2"
    }
    elseif ($found_patterns -match "BEQ.*EXACT MATCH") {
        $score += 5
        $reasons += "BEQ branch for exact contactType=2"
    }
    elseif ($found_patterns -match "BGT.*EXCLUDES") {
        $score += 2
        $reasons += "BGT branch (inverse logic possible)"
    }
    
    # Points for data loading
    if ($load_count -ge 2) {
        $score += 3
        $reasons += "$load_count data loads (frame buffer access?)"
    }
    
    # Points for bit manipulation
    if ($shift_count -ge 2) {
        $score += 3
        $reasons += "$shift_count shifts/ORs (multi-byte assembly)"
    }
    
    # Location-specific knowledge
    if ($loc.Name -match "Patch 12") {
        $score += 1
        $reasons += "Documented in Patch 12 (tested, failed)"
    }
    
    $confidence = "VERY LOW"
    if ($score -ge 10) { $confidence = "HIGH" }
    elseif ($score -ge 7) { $confidence = "MEDIUM-HIGH" }
    elseif ($score -ge 4) { $confidence = "MEDIUM" }
    elseif ($score -ge 2) { $confidence = "LOW" }
    
    Write-Host "LIKELIHOOD SCORE: $score/11 - Confidence: $confidence"
    if ($reasons.Count -gt 0) {
        Write-Host ""
        Write-Host "Reasoning:"
        foreach ($reason in $reasons) {
            Write-Host "  + $reason"
        }
    }
    
    Write-Host ""
}

Write-Host ""
Write-Host "=" * 80
Write-Host "SUMMARY & RECOMMENDATIONS"
Write-Host "=" * 80
Write-Host ""
Write-Host "Based on disassembly analysis:"
Write-Host ""
Write-Host "1. Check the location with HIGHEST score in Ghidra decompiler"
Write-Host "2. Look for code pattern: if(contactType <= 2) or if(contactType == 2)"
Write-Host "3. Verify branch target - should have group ID extraction code"
Write-Host "4. If extraction uses 32-bit load + shifts (not LDRB x3), that's expected"
Write-Host ""
Write-Host "Next actions in Ghidra:"
Write-Host "- Press 'G', enter the highest-scoring address"
Write-Host "- Window > Decompiler"
Write-Host "- Look for Frame buffer access and contactType checks"
Write-Host "- Create function if not auto-detected (press 'F')"
Write-Host ""
Write-Host "=" * 80
