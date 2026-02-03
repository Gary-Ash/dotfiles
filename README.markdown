# Dotfiles

Personal macOS configuration files and setup automation.

## Quick Start

```bash
cd ~/Downloads/dotfiles
./bootstrap.sh
```

The bootstrap script will:
- Install Homebrew (if not present)
- Install packages from the Brewfile
- Copy dotfiles to your home directory
- Configure zsh as the default shell
- Install Ruby gems and Python packages
- Set up the ZDOTDIR environment variable

## Repository Structure

```
dotfiles/
├── bootstrap.sh          # Main setup script
├── home/                 # Files synced to ~/
│   ├── .claude/          # Claude Code configuration
│   ├── .claude.json      # Claude Code project settings
│   ├── .config/          # XDG configuration directory
│   │   ├── zsh/          # Zsh configuration
│   │   ├── git/          # Git config, ignore, attributes
│   │   ├── ghostty/      # Ghostty terminal config
│   │   ├── bat/          # Bat (cat replacement) config
│   │   ├── eza/          # Eza (ls replacement) config
│   │   ├── gh/           # GitHub CLI config
│   │   └── ...           # Code formatters (swiftformat, perltidy, etc.)
│   ├── .lldbinit         # LLDB debugger config
│   ├── .hushlogin        # Suppress login banner
│   └── .ssh/             # SSH configuration
├── brew/                 # Homebrew configuration
│   ├── Brewfile          # Homebrew packages and casks
│   ├── gems.txt          # Ruby gems to install
│   └── python-packages.txt
├── preferences/          # macOS application preferences
│   ├── com.apple.dt.Xcode.plist
│   ├── com.apple.Terminal.plist
│   └── com.apple.applescript.plist
├── BBEdit/               # BBEdit application support
│   ├── Clippings/
│   ├── Color Schemes/
│   ├── Scripts/
│   └── Text Filters/
├── xcode/                # Xcode configuration
│   └── UserData/
│       ├── CodeSnippets/
│       ├── FontAndColorThemes/
│       └── KeyBindings/
├── keyboard-maestro/     # Keyboard Maestro macros
│   └── Library.kmmacros
└── shortcuts/            # macOS Shortcuts
    ├── Clear Downloads Folder.shortcut
    └── OCD.shortcut
```

## Homebrew Packages

Key packages installed via Brewfile:

| Category | Packages |
|----------|----------|
| Shell | zsh, bash, zsh-autosuggestions, zsh-completions |
| Git | git, gh, git-delta, git-lfs |
| Search | ripgrep, fzf |
| File Utilities | bat, eza, jq |
| Languages | python@3.14, node, rbenv |
| Swift/Xcode | swiftformat, swiftlint, periphery |
| Formatters | shfmt, shellcheck, perltidy, uncrustify |
| Navigation | zoxide |

## Shell Configuration

Zsh is configured with:
- `ZDOTDIR` set to `~/.config/zsh` (XDG compliant)
- Autosuggestions and completions via Homebrew
- Custom prompt and aliases in `.zshrc`

## Applications Configured

- **BBEdit** - Text editor with custom scripts, clippings, and color schemes
- **Xcode** - Code snippets, themes, and keybindings
- **Ghostty** - Terminal emulator configuration
- **Keyboard Maestro** - Automation macros
- **Claude Code** - AI assistant configuration with MCP servers and custom skills

## Author

Gary Ash <gary.ash@icloud.com>

## License

MIT License - see [LICENSE.markdown](LICENSE.markdown) for details.
