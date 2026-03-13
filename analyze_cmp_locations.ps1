# Simplified Firmware Bug Analysis
# Focus on the 5 known CMP r2,#2 locations

$firmwarePath = "C:\Users\Joshua\Documents\android\phonedmrapp\radio_firmware\DMR003.UV4T.V022-ORIGINAL.bin"
$bytes = [System.IO.File]::ReadAllBytes($firmwarePath)

Write-Host "=" * 80
Write-Host "DMR Firmware - CMP r2,#2 Location Analysis"
Write-Host "=" * 80
Write-Host ""

# The 5 known locations
$locations = @(
    @{Addr="0x08018F26"; Offset=0x18F26; Name="Location 1 (Patch 12 - documented)"},
    @{Addr="0x080392C9"; Offset=0x392C9; Name="Location 2 (data table)"},
    @{Addr="0x080490E2"; Offset=0x490E2; Name="Location 3 (Patch 13 - BGT)"},
    @{Addr="0x080524E0"; Offset=0x524E0; Name="Location 4 (bad instructions)"},
    @{Addr="0x080524FA"; Offset=0x524FA; Name="Location 5 (never tested)"}
)

foreach ($loc in $locations) {
    Write-Host "=" * 80
    Write-Host $loc.Name
    Write-Host "=" * 80
    Write-Host "Address: $($loc.Addr)"
    Write-Host ""
    
    $offset = $loc.Offset
    
    # Show 20 bytes of disassembly context
    Write-Host "Raw bytes at location:"
    $context_bytes = $bytes[$offset..($offset+19)]
    $hex_str = ($context_bytes | ForEach-Object { "{0:X2}" -f $_ }) -join ' '
    Write-Host "  $hex_str"
    Write-Host ""
    
    # Check for conditional branches in next 10 bytes
    Write-Host "Conditional branches nearby:"
    $found_branch = $false
    for ($j = 2; $j -lt 12; $j += 2) {
        if ($offset + $j + 1 -ge $bytes.Length) { break }
        $opcode = $bytes[$offset + $j + 1]
        
        if ($opcode -ge 0xD0 -and $opcode -le 0xDD) {
            $branch_type = switch ($opcode) {
                0xD0 { "BEQ (==)" }
                0xD1 { "BNE (!=)" }
                0xD8 { "BHI (higher)" }
                0xD9 { "BLS (lower/same)" }
                0xDA { "BGE (>=)" }
                0xDB { "BLT (<)" }
                0xDC { "BGT (>)" }
                0xDD { "BLE (<=)" }
                default { "B??" }
            }
            Write-Host "  [+] Found $branch_type at offset +$j"
            $found_branch = $true
        }
    }
    if (-not $found_branch) {
        Write-Host "  [ ] No conditional branches found"
    }
    Write-Host ""
    
    # Search for LDRB #5, #6, #7 in ±100 bytes
    $search_start = [Math]::Max(0, $offset - 100)
    $search_end = [Math]::Min($bytes.Length - 2, $offset + 100)
    
    $ldrb_found = @()
    for ($k = $search_start; $k -lt $search_end; $k += 2) {
        $instr_byte = $bytes[$k]
        
        if (($instr_byte -band 0xF8) -eq 0x78) {
            $offset_field = ($instr_byte -shr 3) -band 0x1F
            
            if ($offset_field -in @(5, 6, 7)) {
                $rel_pos = $k - $offset
                $ldrb_found += "LDRB #$offset_field at $rel_pos bytes"
            }
        }
    }
    
    Write-Host "LDRB patterns (offsets 5/6/7 in ±100 bytes):"
    if ($ldrb_found.Count -gt 0) {
        foreach ($ldrb in $ldrb_found) {
            Write-Host "  [+] $ldrb"
        }
    } else {
        Write-Host "  [ ] No LDRB #5/#6/#7 patterns found"
    }
    Write-Host ""
    
    # Scoring
    $score = 0
    if ($found_branch) { $score += 3 }
    if ($ldrb_found.Count -ge 3) { $score += 6 }
    elseif ($ldrb_found.Count -ge 2) { $score += 4 }
    elseif ($ldrb_found.Count -ge 1) { $score += 2 }
    
    $confidence = "UNKNOWN"
    if ($score -ge 8) { $confidence = "HIGH" }
    elseif ($score -ge 5) { $confidence = "MEDIUM" }
    elseif ($score -ge 3) { $confidence = "LOW" }
    
    Write-Host "CONFIDENCE: $confidence (Score: $score/9)"
    Write-Host ""
}

Write-Host "=" * 80
Write-Host "RECOMMENDATION"
Write-Host "=" * 80
Write-Host ""
Write-Host "Based on this analysis:"
Write-Host ""
Write-Host "1. Location 1 (0x08018F26) - Already investigated in Ghidra"
Write-Host "   - Has CMP + branches + LDRB patterns"
Write-Host "   - Branch target shows undefined bytes"
Write-Host "   - Patch 12 tested (failed)"
Write-Host ""
Write-Host "2. Location 3 (0x080490E2) - Next best candidate"
Write-Host "   - Check this one in Ghidra next"
Write-Host "   - Patch 13 tested (BGT NOP)"
Write-Host ""
Write-Host "3. Location 5 (0x080524FA) - Never tested"
Write-Host "   - Only 26 bytes from Location 4"
Write-Host "   - Worth checking if others fail"
Write-Host ""
Write-Host "Next steps:"
Write-Host "- Open Ghidra, press 'G', enter address"
Write-Host "- Press 'D' to disassemble if showing as data"
Write-Host "- Check decompiler for if(contactType==2) logic"
Write-Host "=" * 80
