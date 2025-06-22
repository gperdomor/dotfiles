# 🏠 dotfiles

> Personal dotfiles managed with [Chezmoi](https://chezmoi.io) for automated macOS development environment setup

[![macOS](https://img.shields.io/badge/macOS-Sequoia%2B-blue?logo=apple)](https://www.apple.com/macos/)
[![Chezmoi](https://img.shields.io/badge/Chezmoi-Latest-green?logo=git)](https://chezmoi.io)
[![1Password](https://img.shields.io/badge/1Password-CLI%20Integration-0099cc?logo=1password)](https://1password.com/downloads/command-line/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

This repository contains my complete development environment configuration and automation scripts. It provides a **zero-touch setup** for macOS machines with all the tools, applications, and configurations needed for modern development work.

## ✨ Features

- 🚀 **One-command setup** - Complete environment setup with a single curl command
- 🔐 **Secure secret management** - Deep integration with 1Password for all sensitive data
- 📦 **Automated package management** - Homebrew with curated application selection
- ⚡ **Enhanced shell experience** - Oh My Zsh with productivity plugins and themes
- 🛠️ **Pre-configured development tools** - Git, Docker, npm, and modern CLI utilities
- 🎨 **Modern terminal setup** - Ghostty terminal with Starship/Oh My Posh theming
- 🔄 **Idempotent installation** - Safe to run multiple times, updates existing setup
- 🏢 **Enterprise-ready** - Support for corporate GitLab and private registries

## 🛠️ What's Included

### 🖥️ Applications & Tools

- **Terminal Emulator**: [Ghostty](https://ghostty.org/) - Modern, fast terminal
- **Development Environment**: [JetBrains Toolbox](https://www.jetbrains.com/toolbox-app/), [Visual Studio Code](https://code.visualstudio.com/), [Docker](https://www.docker.com/), [Postman](https://www.postman.com/)
- **Version Control**: [Git](https://git-scm.com/), [GitHub CLI](https://cli.github.com/), [Tower](https://www.git-tower.com/)
- **Productivity Tools**: [1Password](https://1password.com/), [Notion](https://www.notion.so/), [Microsoft Teams](https://www.microsoft.com/microsoft-teams/)
- **Utilities**: [AppCleaner](https://freemacsoft.net/appcleaner/), [Keka](https://www.keka.io/), [TablePlus](https://tableplus.com/)
- **Development Tools**: [mise](https://mise.jdx.dev) - Modern runtime manager for Node.js, Go, Rust, and more
- **CLI Tools**: [fzf](https://github.com/junegunn/fzf), [zoxide](https://github.com/ajeetdsouza/zoxide), [jq](https://stedolan.github.io/jq/), [fastfetch](https://github.com/fastfetch-cli/fastfetch)
- **Fonts**: Nerd Fonts collection (JetBrains Mono, Fira Code, Cascadia Code)
- **Package Managers**: [Homebrew](https://brew.sh/) for system packages
- For a full list of apps and tools check the [`Brewfile`](Brewfile) file

### 🐚 Shell Configuration

- **Framework**: [Oh My Zsh](https://ohmyz.sh/) with productivity plugins
- **Prompts**: [Oh My Posh](https://ohmyposh.dev) for Ghostty Terminal and [Starship](https://starship.rs/) for Apple Terminal
- **Plugins**: Auto-suggestions, syntax highlighting, completions
- **Integration**: 1Password CLI for secure secret management

### 💻 Development Environment

- **Git**: Advanced configuration with signing, aliases, and URL rewriting
- **npm**: Multi-registry support with 1Password token integration
- **SSH**: 1Password SSH agent integration for seamless authentication
- **Docker**: Registry authentication for private repositories
- **GitLab**: Corporate GitLab integration with PAT management
- **Runtime Management**: [mise](https://mise.jdx.dev) for managing programming language versions
  - **Node.js**: Latest LTS version with Corepack enabled
  - **Go**: Latest stable version for modern Go development
  - **Rust**: Latest version with cargo and rustup integration
  - **Auto-switching**: Project-specific versions via `.mise.toml` files

## 🚀 Quick Setup

### 📋 Prerequisites

- **macOS** (Intel or Apple Silicon)
- **Internet connection** for downloads
- **Administrator privileges** for system modifications

### ⚡ One-Command Installation

Run this command in Terminal to set up everything automatically:

```bash
curl -sfL https://raw.githubusercontent.com/gperdomor/dotfiles/main/.install.sh | bash
```

### 🔧 What This Does

The installation script will automatically:

1. ✅ **Install Xcode Command Line Tools** - Required for development
2. 🍺 **Install Homebrew** - The missing package manager for macOS
3. 🔐 **Install 1Password** - Password manager with CLI integration for secure secret management
4. 📦 **Install Chezmoi** - Dotfiles manager for configuration sync
5. 🛠️ **Install Development Tools** - Git, Mise, and essential utilities
6. 🏠 **Clone & Apply Dotfiles** - Download and configure your environment

### 🕒 Installation Time

- **Fresh installation**: ~15-30 minutes (depending on internet speed)
- **Updates/Re-runs**: ~2-5 minutes

## 📁 Repository Structure

```
📦 dotfiles
├── 📄 Brewfile                                        # Homebrew packages and applications
├── 📄 LICENSE                                         # MIT License
├── 📄 README.md                                       # This file
├── 📄 .chezmoiignore                                  # Files to ignore during apply
├── 📄 .chezmoi.toml.tmpl                              # Chezmoi configuration template
├── 📄 .install.sh                                     # Main installation script
│
├── 🔧 Configuration Files
├── 📄 dot_allowed_signers.tmpl                        # Git allowed signers template
├── 📄 dot_default-npm-packages                        # Default npm packages for new Node.js versions
├── 📄 dot_gitconfig.tmpl                              # Git configuration template with 1Password integration
├── 📄 dot_gitignore                                   # Global Git ignore patterns
├── 📄 dot_npmrc.tmpl                                  # npm configuration with 1Password token integration
├── 📄 dot_zprofile                                    # Zsh profile for environment setup
├── 📄 dot_zshrc                                       # Zsh configuration and aliases
│
├── 📁 dot_config/                                     # Application configurations
│   ├── 📄 starship.toml                               # Starship prompt configuration
│   ├── 📁 ghostty/                                    # Ghostty terminal configuration
│   │   └── 📄 config                                  # Ghostty settings
│   ├── 📁 mise/                                       # Mise development environment manager
│   │   └── 📄 config.toml                             # Mise configuration
│   └── 📁 ohmyposh/                                   # Oh My Posh theme configuration
│       └── 📄 theme.toml                              # Oh My Posh theme settings
│
├── 📁 private_dot_ssh/                                # SSH configuration (private)
│   ├── 📄 private_config                              # SSH client configuration
│   ├── 📄 private_github.pub.tmpl                     # GitHub SSH public key template
│   └── 📄 private_gitlab.pub.tmpl                     # GitLab SSH public key template
│
└── 🔧 Setup Scripts
    ├── 📄 run_once_install_ohmyzsh.sh                 # Oh My Zsh setup with plugins and themes
    ├── � run_once_after_create-developer-dir.sh     # Create Developer directory and clone repos
    ├── 📄 run_onchange_after_docker-login.sh.tmpl    # Docker registry authentication
    ├── 📄 run_onchange_after_setup-system-settings.sh # macOS system preferences configuration
    ├── � run_onchange_install-homebrew-packages.sh.tmpl # Homebrew package installation
    └── � run_onchange_mise-install.sh.tmpl           # Mise tool version management
```

### 📋 File Types Explanation

- **`dot_*`**: Files that become dotfiles (`.filename`) in your home directory
- **`private_*`**: Files with restricted permissions (600) for security
- **`*.tmpl`**: Template files that use 1Password and other data sources
- **`run_once_*`**: Scripts that run only once during initial setup
- **`run_onchange_*`**: Scripts that run when their content or dependencies change

## 🔐 Security & Secrets Management

This setup uses **1Password as the central secret store**, ensuring no sensitive data is committed to version control:

### 🔑 Integrated Secrets

- **NPM Tokens**: Private registry authentication via 1Password
- **Docker Registry**: Container registry credentials
- **SSH Keys**: 1Password SSH agent for seamless authentication
- **API Tokens**: GitLab, GitHub, and other service tokens

### 🛡️ Security Features

- **No hardcoded secrets** in repository
- **Encrypted credential storage** via 1Password
- **SSH key management** with biometric unlock
- **Automatic token rotation** support

### 📝 Adding New Secrets

```bash
# Store a new secret in 1Password
op item create --category=password --title="My API Token" --vault="Personal" password="your-secret-here"

# Use in dotfiles template
echo "{{ onepasswordRead \"op://Personal/My API Token/password\" }}"
```

## 🔄 Maintenance & Updates

### 📥 Updating Dotfiles

```bash
# Update to latest dotfiles version
chezmoi update

# Manual update process
chezmoi git pull && chezmoi apply

# Update only specific files
chezmoi apply ~/.zshrc ~/.gitconfig
```

### ✏️ Making Changes

```bash
# Edit configuration files
chezmoi edit ~/.zshrc          # Edit shell configuration
chezmoi edit ~/.gitconfig      # Edit Git configuration
chezmoi edit ~/.npmrc          # Edit npm configuration

# Edit templates with data
chezmoi edit --apply ~/.zshrc  # Edit and apply immediately

# View differences before applying
chezmoi diff

# Apply all changes
chezmoi apply
```

### 📦 Managing Packages

```bash
# Add new Homebrew package
echo 'brew "package-name"' >> ~/.local/share/chezmoi/Brewfile
chezmoi apply

# Update all packages
brew update && brew upgrade && brew cleanup

# Install new cask application
echo 'cask "app-name"' >> ~/.local/share/chezmoi/Brewfile
chezmoi apply
```

### 🔧 Troubleshooting

```bash
# Check chezmoi status
chezmoi status

# Verify 1Password integration
op account list

# Re-run specific scripts
chezmoi execute-template < ~/.local/share/chezmoi/run_once_install_ohmyzsh.sh

# Reset and re-apply everything
chezmoi init --force && chezmoi apply
```

## 🚨 Common Issues & Solutions

### Issue: 1Password CLI not working

```bash
# Solution 1: Check if 1Password app is running
open -a "1Password"

# Solution 2: Re-enable CLI integration
# Go to 1Password → Settings → Developer → Enable CLI integration

# Solution 3: Test connection
op account list
```

### Issue: Homebrew packages not installing

```bash
# Solution: Update Homebrew and retry
brew update
brew doctor
chezmoi apply
```

### Issue: Git signing not working

```bash
# Solution: Check SSH key configuration
ssh-add -l                          # List loaded keys
git config --get user.signingkey    # Check signing key
git log --show-signature -1         # Verify last commit signature
```

## 🤝 Contributing & Customization

### 🍴 Fork for Personal Use

This is a personal dotfiles repository, but you're welcome to:

1. **Fork the repository** and adapt it to your needs
2. **Use as inspiration** for your own dotfiles setup
3. **Submit issues** if you find bugs or have questions
4. **Suggest improvements** via pull requests

### 🔧 Customization Guide

```bash
# 1. Fork this repository on GitHub
# 2. Clone your fork
chezmoi init --apply your-username/dotfiles

# 3. Customize configurations
chezmoi edit ~/.zshrc          # Add your aliases and functions
chezmoi edit Brewfile          # Add your preferred applications
chezmoi edit ~/.gitconfig      # Update with your information

# 4. Commit and push changes
chezmoi git add .
chezmoi git commit -m "Customize for my setup"
chezmoi git push
```

### 📝 Adding Your Own Scripts

```bash
# Add one-time setup scripts
chezmoi add --template run_once_your_script.sh

# Add scripts that run when files change
chezmoi add --template run_onchange_your_updates.sh

# Add data for templates
chezmoi edit-config  # Edit .chezmoi.toml to add custom data
```

## 🌟 Inspiration & Credits

This dotfiles setup is inspired by and builds upon:

- **[Chezmoi Documentation](https://chezmoi.io)** - The amazing dotfiles manager
- **[Homebrew](https://brew.sh)** - Package management for macOS
- **[Oh My Zsh](https://ohmyz.sh)** - Framework for Zsh configuration
- **[1Password CLI](https://developer.1password.com/docs/cli/)** - Secure secret management
- **[Dotfiles Community](https://dotfiles.github.io/)** - Best practices and inspiration

Special thanks to the open-source community for creating these fantastic tools!

## 📚 Additional Resources

### 📖 Documentation & Learning

- **[Chezmoi User Guide](https://chezmoi.io/user-guide/)** - Comprehensive dotfiles management
- **[1Password CLI Reference](https://developer.1password.com/docs/cli/reference/)** - Command reference
- **[Homebrew Documentation](https://docs.brew.sh)** - Package management
- **[Oh My Zsh Wiki](https://github.com/ohmyzsh/ohmyzsh/wiki)** - Shell configuration
- **[Starship Configuration](https://starship.rs/config/)** - Prompt customization

### 🔗 Related Projects

- **[Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)** - Curated list of dotfiles resources
- **[macOS Defaults](https://github.com/kevinSuttle/macOS-Defaults)** - System configuration options
- **[Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle)** - Brewfile documentation

### 🛠️ Tools Used

- **[Chezmoi](https://chezmoi.io)** - Dotfiles manager
- **[1Password](https://1password.com)** - Password and secret management
- **[Homebrew](https://brew.sh)** - macOS package manager
- **[Oh My Zsh](https://ohmyz.sh)** - Zsh framework
- **[Starship](https://starship.rs)** - Cross-shell prompt
- **[Ghostty](https://ghostty.org)** - Modern terminal emulator
- **[Mise](https://mise.jdx.dev)** - The front-end to your dev env
- And many more...

---

## 📄 License

This project is released under the **[MIT License](LICENSE)**.

---

<div align="center">

**⭐ If this helped you, consider giving it a star!**

Made with ❤️ by [Gustavo Perdomo](https://github.com/gperdomor)

</div>
