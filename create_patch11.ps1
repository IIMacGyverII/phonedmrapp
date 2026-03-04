# Create Patch 11 - Mega Patch All ContactType Locations
# NOP the CMP and ALL nearby branches at all 5 locations

$fw = "app\src\main\assets\DMR003.UV4T.V022.bin"
$bytes = [System.IO.File]::ReadAllBytes($fw)

Write-Host "=== Creating Patch 11 - Mega Patch ===" -ForegroundColor Cyan
Write-Host "NOPing CMP and branches at ALL 5 contactType locations`n"

# Location 1: 0x08018F26
Write-Host "Location 1 (0x08018F26):"
Write-Host "  - NOP CMP at 0x18F26"
$bytes[0x18F26] = 0x00; $bytes[0x18F26+1] = 0xBF  # CMP r2,#2 → NOP
Write-Host "  - NOP BLS at 0x18F2C"
$bytes[0x18F2C] = 0x00; $bytes[0x18F2C+1] = 0xBF  # BLS → NOP

# Location 2: 0x080392C9
Write-Host "Location 2 (0x080392C9):"
Write-Host "  - NOP CMP at 0x392C9"  
$bytes[0x392C9] = 0x00; $bytes[0x392C9+1] = 0xBF  # CMP r2,#2 → NOP

# Location 3: 0x080490E2
Write-Host "Location 3 (0x080490E2):"
Write-Host "  - NOP CMP at 0x490E2"
$bytes[0x490E2] = 0x00; $bytes[0x490E2+1] = 0xBF  # CMP r2,#2 → NOP
Write-Host "  - NOP BGT at 0x490E6"
$bytes[0x490E6] = 0x00; $bytes[0x490E6+1] = 0xBF  # BGT → NOP

# Location 4: 0x080524E0
Write-Host "Location 4 (0x080524E0):"
Write-Host "  - NOP CMP at 0x524E0"
$bytes[0x524E0] = 0x00; $bytes[0x524E0+1] = 0xBF  # CMP r2,#2 → NOP

# Location 5: 0x080524FA
Write-Host "Location 5 (0x080524FA):"
Write-Host "  - NOP CMP at 0x524FA"
$bytes[0x524FA] = 0x00; $bytes[0x524FA+1] = 0xBF  # CMP r2,#2 → NOP

$outFile = "firmware_patch11_mega.bin"
[System.IO.File]::WriteAllBytes($outFile, $bytes)

Write-Host "`n✓ Created: $outFile" -ForegroundColor Green
Write-Host "`nThis patch NOPs all contactType comparisons AND key branches"
Write-Host "If this works, contactType checks are completely bypassed"
