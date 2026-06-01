# DMRModHooks v3.3.4 Release Notes

## 🐛 Bug Fix Release

### Fixed
- **Channel Import Error Handling**: Fixed channel import failure when backup contains channels with malformed data
  - Import now continues processing valid channels even if some channels have parsing errors
  - Each channel is wrapped in individual error handling
  - Skipped channels are logged with detailed error messages
  - Import summary shows count of successful imports and skipped channels

### Technical Details

**Problem**: 
- Large backup imports would fail completely if ANY channel had invalid data (e.g., malformed frequency)
- Error: `NumberFormatException` at `Double.parseDouble()` when parsing frequencies
- Result: "Import partially successful - Channels: Failed" even though most channels were valid

**Solution**:
- Wrapped individual channel import in try-catch blocks
- Parsing errors (NumberFormatException) are caught per-channel instead of killing entire import
- Detailed logging shows which channel failed and why
- Added skip counter to report: "Imported X channels, skipped Y channels due to errors"

**Affected Code**:
- `DirectDatabaseImporter.java` lines 365-625
- Added per-channel error handling in import loop
- Enhanced logging for failed channels

### Testing Recommendations

1. **Export your current config** before importing
2. **Test import with large backup** - should now succeed even if some channels have errors
3. **Check logs** after import to see if any channels were skipped:
   ```
   adb logcat -d | Select-String "DMRModHooks_DirectImport"
   ```
4. **Verify imported channels** - most should import successfully, only malformed ones skipped

### Upgrade Notes

- **No migration required** - this is a pure bug fix
- **No data loss** - fix only affects import process
- **Backward compatible** - works with existing backups and zones

### Known Issues

None - this is a targeted bug fix for import error handling.

### Rollback

If you need to rollback to v3.3.3:
1. Download v3.3.3 from releases
2. Uninstall current version
3. Install v3.3.3 APK
4. Reactivate in LSPosed and restart target app

---

**Full Changelog**: v3.3.3...v3.3.4
