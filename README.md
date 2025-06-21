# 🏠 dotfiles

> Personal dotfiles managed with [Chezmoi](https://chezmoi.io) for automated macOS setup

This repository contains my personal development environment configuration and automation scripts. It provides a complete setup for macOS machines with all the tools, applications, and configurations I use daily.

## ✨ Features

- 🚀 **One-command setup** - Complete environment setup with a single command
- 🔐 **Secure secret management** - Integration with 1Password for sensitive data
- 📦 **Package management** - Automated installation via Homebrew
- ⚡ **Shell enhancement** - Oh My Zsh with custom themes and plugins
- 🛠️ **Development tools** - Pre-configured Git, npm, and development utilities
- 🎨 **Modern terminal** - Ghostty terminal with Oh My Posh/Starship prompt

## 🛠️ What's Included

### Applications & Tools

- **Terminal**: Ghostty with Oh My Posh/Starship theming
- **Development**: Git, GitHub CLI, Docker, JetBrains Toolbox
- **Utilities**: 1Password, AppCleaner, Keka, Notion
- **Fonts**: Nerd Fonts (JetBrains Mono, Fira Code, Cascadia Code)
- **Package Managers**: Homebrew, Node.js (via fnm)

### Shell Configuration

- **Zsh** with Oh My Zsh framework
- **Starship** cross-shell prompt
- **Useful aliases** and environment variables
- **1Password CLI integration** for secure secret management

### Development Environment

- **Git configuration** with signing and helpful aliases
- **npm configuration** with private registry support
- **SSH configuration** with 1Password integration
- **Editor configurations** and preferences

## 🚀 Quick Setup

### Prerequisites

- macOS (Intel or Apple Silicon)
- Internet connection
- Admin privileges

### Installation

Run this command in your terminal to set up everything automatically:

```bash
curl -sfL https://raw.githubusercontent.com/gperdomor/dotfiles/main/.startup.sh | bash
```

This will:

1. Install Xcode Command Line Tools (if needed)
2. Install Homebrew (if needed)
3. Install Chezmoi
4. Clone this repository
5. Apply all configurations

### Manual Installation

If you prefer to install manually:

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Chezmoi
brew install chezmoi

# Initialize with this repository
chezmoi init gperdomor

# Review changes (optional)
chezmoi diff

# Apply configurations
chezmoi apply
```

## 📁 Repository Structure

```
.
├── Brewfile                              # Homebrew packages and casks
├── dot_gitconfig                         # Git configuration
├── dot_npmrc                             # npm configuration
├── dot_zshrc                             # Zsh configuration
├── dot_zprofile                          # Zsh profile
├── dot_config/
│   ├── starship.toml                     # Starship prompt configuration
│   ├── ghostty/config                    # Ghostty terminal settings
│   └── ohmyposh/theme.toml               # Oh My Posh theme
├── run_once_install_ohmyzsh.sh           # Oh My Zsh installation script
└── run_onchange_install-packages.sh.tmpl # Package installation template
```

## 🔐 Security & Secrets

This setup integrates with 1Password for secure secret management:

- NPM tokens are read from 1Password items
- SSH keys can be managed through 1Password SSH agent
- No sensitive data is stored in this repository

## 🔄 Updates

To update your dotfiles:

```bash
# Pull latest changes
chezmoi update

# Or manually
chezmoi git pull && chezmoi apply
```

To modify configurations:

```bash
# Edit a file
chezmoi edit ~/.zshrc

# Apply changes
chezmoi apply
```

## 🤝 Contributing

This is a personal dotfiles repository, but feel free to:

- Fork it and adapt it to your needs
- Submit issues if you find bugs
- Suggest improvements via pull requests

## 📚 Learn More

- [Chezmoi Documentation](https://chezmoi.io)
- [1Password CLI Documentation](https://developer.1password.com/docs/cli/)
- [Homebrew Documentation](https://docs.brew.sh)

## 📄 License

This project is released under the [MIT License](LICENSE).
