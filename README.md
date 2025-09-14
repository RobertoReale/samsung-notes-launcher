# Samsung Notes Launcher for Non-Samsung Devices

A safe Windows batch script that temporarily spoofs system hardware identification to run Samsung Notes on non-Samsung devices.

## ⚠️ Important Disclaimer

This script temporarily modifies Windows registry values related to system hardware identification. While it includes multiple safety mechanisms to restore original values, use at your own risk. Always create a system backup before running.

## Features

- ✅ **Safe Registry Handling**: Multiple backup mechanisms ensure original values are restored
- ✅ **Error Handling**: Checks for failures and aborts safely if issues occur
- ✅ **Persistent Backups**: Creates timestamped backup files that survive system crashes
- ✅ **Verification**: Confirms restoration was successful
- ✅ **Manual Fallback**: Provides restoration script if automatic restoration fails
- ✅ **Admin Privilege Management**: Automatically requests elevated permissions when needed

## How It Works

1. **Backup**: Stores your current system identification values
2. **Modify**: Temporarily changes registry to identify as Samsung hardware
3. **Launch**: Starts Samsung Notes application
4. **Restore**: Returns system identification to original values
5. **Verify**: Confirms restoration was successful

## Prerequisites

- Windows 10/11
- Samsung Notes app installed from Microsoft Store
- Administrator privileges (script will request automatically)

## Installation & Usage

1. **Download the script**:
   ```bash
   git clone https://github.com/yourusername/samsung-notes-launcher.git
   cd samsung-notes-launcher
   ```

2. **Run the script**:
   - Right-click `samsung_notes_launcher.bat`
   - Select "Run as administrator" (or let the script request admin rights)

3. **Follow the prompts**:
   - The script will show your original values
   - Samsung Notes will launch automatically
   - Original values will be restored after 5 seconds

## Safety Mechanisms

### Multiple Backup Layers
- **Memory Variables**: Stores values in script variables
- **Backup File**: Creates persistent file with timestamp
- **Restoration Script**: Generates standalone restoration batch file

### Error Handling
- Verifies backup creation before proceeding
- Checks each registry modification for success
- Aborts and restores if any step fails
- Provides manual restoration instructions if needed

### Restoration Verification
- Confirms original values were actually restored
- Alerts if restoration may have failed
- Provides fallback restoration script

## Manual Restoration (If Needed)

If the script fails to restore automatically, you can restore manually:

1. **Check your backup file** (located in `%temp%` folder with timestamp)
2. **Run the restoration script** (if created) or use these commands:
   ```cmd
   reg add "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v SystemProductName /t REG_SZ /d "YourOriginalProductName" /f
   reg add "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v SystemManufacturer /t REG_SZ /d "YourOriginalManufacturer" /f
   ```

## Checking Current Values

To see your current system identification:
```cmd
reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v SystemProductName
reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v SystemManufacturer
```

## Registry Keys Modified

The script temporarily modifies these registry values:
- `HKLM\HARDWARE\DESCRIPTION\System\BIOS\SystemProductName`
- `HKLM\HARDWARE\DESCRIPTION\System\BIOS\SystemManufacturer`

## Troubleshooting

### Samsung Notes Won't Start
- Ensure Samsung Notes is installed from Microsoft Store
- Try running the script as administrator
- Check if Windows Store apps are properly configured

### Script Says "Access Denied"
- Run Command Prompt as Administrator
- Ensure User Account Control (UAC) is enabled
- Check Windows Defender isn't blocking the script

### Restoration Failed
- Check the backup file in your temp directory
- Run the generated restoration script manually
- Use the manual restoration commands above

## Technical Details

### What Gets Changed
- **SystemProductName**: Temporarily set to "NP960XFG-KC4UK" (Samsung laptop model)
- **SystemManufacturer**: Temporarily set to "Samsung"

### Why This Works
Samsung Notes checks system hardware identification to verify it's running on Samsung devices. This script temporarily spoofs that identification.

### Safety Considerations
- Changes are temporary (5 seconds)
- Multiple backup mechanisms prevent data loss
- Registry modifications are limited to hardware identification only
- No system files are modified

## Legal Notice

This tool is for educational and personal use only. Users are responsible for complying with software licensing terms and local laws. The author assumes no responsibility for any damages or legal issues resulting from use of this script.

## Contributing

Feel free to submit issues, suggestions, or improvements via GitHub issues or pull requests.

## License

This project is released under the MIT License. See [LICENSE](LICENSE) file for details.

---

**⚠️ Remember**: Always backup your system before running scripts that modify the registry, even with safety mechanisms in place.
