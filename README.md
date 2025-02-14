# Mac Hardware ID Reset Tool for Cursor

A tool specifically designed to reset hardware identifiers for Cursor IDE on macOS. This tool was created out of necessity during a challenging financial period.

## 🙏 A Note to Cursor Team

I want to start with a sincere apology to the Cursor team. I created this tool during a period when I couldn't afford a subscription, but I truly value your amazing work and innovation in AI-powered development. I promise to purchase a proper license as soon as I secure a new client or land a better job position. Your tool has significantly improved my coding workflow and allowed me to build a lot of MVP and demos while pitching client, and I want to properly support your development efforts.

## 📋 What This Tool Does

- Resets hardware identifiers used by Cursor IDE
- Modifies MAC addresses for network interfaces
- Cleans up Cursor-specific identifiers
- Provides a user-friendly interface to preview changes

## 🔧 Installation

1. Download the script:
```bash
curl -O https://raw.githubusercontent.com/krsjoseph/mac-reset/main/reset.sh
```

2. Make the script executable:
```bash
chmod +x reset.sh
```

## 💻 Usage

1. Close Cursor IDE if it's running
2. Open Terminal
3. Navigate to the script directory
4. Run the script with sudo privileges:
```bash
sudo ./reset.sh
```

The script will:
1. Show a disclaimer
2. Display current identifiers
3. Show proposed new values
4. Ask for confirmation before making changes
5. Clean up Cursor-specific data

## ⚙️ What It Modifies

Specifically for Cursor:
- Removes Cursor machine ID files
- Resets hardware identifiers used by Cursor
- Modifies network identifiers that Cursor might use for validation

## ⚠️ Important Considerations

1. **System Requirements**
   - macOS 10.13 or later
   - Administrator privileges
   - Terminal access
   - Cursor IDE must be closed during the process

2. **Safety Notes**
   - Backup any important Cursor settings before using
   - Some changes require a system restart
   - May need to reconfigure Cursor settings after reset

## 🔍 Verification

After running the script and restarting your system, you can verify the changes:

```bash
# Check if Cursor machine ID was removed
ls ~/Library/Application\ Support/Cursor/machineid

# Check network changes
networksetup -listallhardwareports
```

## ⚖️ Legal Disclaimer

This tool is provided "as is", without warranty of any kind. Please note that:
1. This is a temporary solution for those in financial hardship
2. Users should support Cursor by purchasing a license when possible
3. The tool should only be used on your own systems

## 🐛 Troubleshooting

Common issues:

1. **Cursor still recognizes old ID**
   - Make sure to completely quit Cursor before running
   - Clear Cursor application data
   - Restart your system after running the script

2. **Changes don't persist**
   - Some macOS security features may reset changes
   - May need to reapply after Cursor updates

## 💰 Supporting Cursor

If you're using this tool, please consider:
1. Purchasing a license when financially possible
2. Sharing feedback about Cursor to help improve the product
3. Contributing to the Cursor community
4. Recommending Cursor to other developers

The goal is to eventually support the Cursor team properly, as they deserve compensation for their excellent work.

## 📬 Contact

For issues or questions:
- Open an issue in the repository
- Reach out via email: krspjoseph@gmail.com

Remember: This is meant as a temporary solution. Please support the Cursor team by purchasing a license when you can afford it. They're creating an incredible tool that deserves proper compensation.