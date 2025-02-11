# 🦁 BetterBrave

BetterBrave is a PowerShell script that disables unnecessary features from Brave Browser and enforce secure DNS.

<div align="center">

[![GitHub license](https://img.shields.io/github/license/aaxyat/BetterBrave)](https://github.com/aaxyat/BetterBrave/blob/main/LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/aaxyat/BetterBrave)](https://github.com/aaxyat/BetterBrave/stargazers)
[![PowerShell](https://img.shields.io/badge/PowerShell-%235391FE.svg?style=flat&logo=powershell&logoColor=white)](https://learn.microsoft.com/en-us/powershell/)
[![Brave](https://img.shields.io/badge/Brave-FB542B?style=flat&logo=Brave&logoColor=white)](https://brave.com/)

</div>

## ✨ Features

- 🚫 Disables cryptocurrency-related features (Rewards, Wallet)
- 🔒 Enforces secure DNS using Cloudflare over HTTPS 
- 🎯 Disables unnecessary features (VPN, AI Chat, Ads)
- 🛡️ Automatic administrator privilege elevation
- 🔄 Easy to revert changes or restore defaults
- 🧪 Dry-run mode to preview changes

## 🚀 Usage

```powershell
# Apply restrictive policies (automatically elevates if needed)
.\BetterBrave.ps1

# Show help and available options
.\BetterBrave.ps1 --help

# Preview changes without applying them
.\BetterBrave.ps1 --dry-run

# Revert to Brave's default settings
.\BetterBrave.ps1 --revert

# Remove all policy settings completely
.\BetterBrave.ps1 --default
```

## 🔧 Managed Policies

| Policy | Default | BetterBrave | Description |
|--------|---------|-------------|-------------|
| BraveRewards | Enabled | Disabled | Cryptocurrency rewards system |
| BraveWallet | Enabled | Disabled | Cryptocurrency wallet |
| BraveVPN | Enabled | Disabled | Built-in VPN service |
| BraveAIChat | Enabled | Disabled | AI chat features |
| PasswordManager | Enabled | Disabled | Built-in password manager |
| HttpsUpgrades | Enabled | Disabled | Automatic HTTPS upgrades |
| BraveAds | Enabled | Disabled | Advertisement system |
| DNS over HTTPS | System | Cloudflare | Secure DNS provider |

## 📥 Installation

1. Clone the repository:
```bash
git clone https://github.com/aaxyat/BetterBrave.git
```

2. Navigate to the directory:
```bash
cd BetterBrave
```

3. Set PowerShell execution policy:
```powershell
# Option 1: Set for current user only (recommended)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Option 2: Set for entire system (requires admin)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
```

4. Run the script:
```powershell
.\BetterBrave.ps1
```
> Note: Administrator privileges will be requested automatically if needed

## ⚡ Requirements

- Windows 10/11
- PowerShell 5.1 or later
- Brave Browser
- PowerShell Execution Policy set to at least RemoteSigned
- Administrator privileges (requested automatically)

## ⚠️ Important Notes

- PowerShell execution policy must be set to RemoteSigned or less restrictive
- Script automatically requests administrator privileges when needed
- Use `--dry-run` to preview changes without applying them
- `--revert` restores Brave's default settings
- `--default` completely removes all policy settings
- Some changes require a browser restart to take effect

## 🛠️ Troubleshooting

### Execution Policy Error
If you see an execution policy error, try one of these solutions:

1. Set policy for current user only:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

2. Run PowerShell as Administrator and set system-wide policy:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
```

3. Bypass policy for a single execution:
```powershell
PowerShell -ExecutionPolicy Bypass -File .\BetterBrave.ps1
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Brave Browser](https://brave.com) for their amazing browser
- All contributors and users of this project

## 📬 Contact

- GitHub: [@aaxyat](https://github.com/aaxyat)

---
<div align="center">
Made with ❤️ by <a href="https://github.com/aaxyat">aaxyat</a>
</div>
