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
├── bootstrap.sh              # Main setup script
├── home/                     # Files synced to ~/
│   ├── .claude/              # Claude Code configuration
│   │   ├── CLAUDE.md         # Claude Code project instructions
│   │   ├── mcp.json          # MCP server configuration
│   │   ├── settings.json     # Claude Code settings
│   │   ├── plugins/          # Installed plugins and marketplace skills
│   │   └── skills/           # Custom Claude Code skills
│   │       ├── bash-skill/
│   │       ├── cpp-skill/
│   │       ├── file-header-skill/
│   │       ├── git-commit-skill/
│   │       ├── github-cli-claude-skill/
│   │       ├── perl-skill/
│   │       └── python3-skill/
│   ├── .claude.json          # Claude Code project settings
│   ├── .config/              # XDG configuration directory
│   │   ├── agents/           # Agent skills (Swift Concurrency, SwiftUI)
│   │   ├── zsh/              # Zsh configuration
│   │   ├── gh/               # GitHub CLI config
│   │   ├── gh-dash/          # GitHub Dashboard config
│   │   ├── ghostty/          # Ghostty terminal config
│   │   ├── bat/              # Bat (cat replacement) config
│   │   ├── eza/              # Eza (ls replacement) config
│   │   ├── diffnav/          # Diff navigation config
│   │   ├── television/       # Television (tv) fuzzy finder config
│   │   ├── sourcekit-lsp/    # SourceKit-LSP configuration
│   │   ├── pycodestyle       # Python code style config
│   │   └── rgrc.conf         # Ripgrep configuration
│   ├── .gitconfig            # Git configuration
│   ├── .hushlogin            # Suppress login banner
│   ├── .pdbrc                # Python debugger config
│   └── .ssh/                 # SSH configuration
├── brew/                     # Homebrew configuration
│   ├── Brewfile              # Homebrew packages and casks
│   ├── gems.txt              # Ruby gems to install
│   └── python-packages.txt
├── preferences/              # macOS application preferences
│   ├── com.apple.dt.Xcode.plist
│   ├── com.apple.Terminal.plist
│   └── com.apple.applescript.plist
├── Script Libraries/         # AppleScript libraries
│   ├── BBEditLibrary.scpt
│   └── HashTable.scpt
├── BBEdit/                   # BBEdit application support
│   ├── Attachment Scripts/
│   ├── Clippings/
│   ├── Color Schemes/
│   ├── Completion Data/
│   ├── Custom Keywords/
│   ├── Language Modules/
│   ├── Language Servers/
│   ├── Menu Scripts/
│   ├── Packages/
│   ├── Preview CSS/
│   ├── Scripts/
│   ├── Setup/
│   ├── Startup Items/
│   ├── Stationery/
│   ├── Text Filters/
│   └── Workspaces/
├── xcode/                    # Xcode configuration
│   ├── Templates/
│   │   └── Project Templates/
│   │       └── Multiplatform/
│   │           ├── Multiplatform UI Test Module.xctemplate
│   │           └── Multiplatform Unit Test Module.xctemplate
│   └── UserData/
│       ├── CodeSnippets/
│       ├── FontAndColorThemes/
│       └── KeyBindings/
├── keyboard-maestro/         # Keyboard Maestro macros
│   └── Library.kmmacros
└── shortcuts/                # macOS Shortcuts
    ├── Clear Downloads Folder.shortcut
    └── OCD.shortcut
```

## Homebrew Packages

Key packages installed via Brewfile:

| Category | Packages |
|----------|----------|
| Shell | zsh, bash, zsh-autosuggestions, zsh-completions, zshdb |
| Git | git, gh, git-delta, git-lfs, github-mcp-server |
| Search | ripgrep, fd, television, diffnav |
| File Utilities | bat, eza, jq, rename, imagemagick |
| Languages | python@3.14, node, rbenv |
| Build | cmake |
| Swift/Xcode | swiftformat, swiftlint, periphery |
| Formatters | shfmt, shellcheck, perltidy, uncrustify |
| Testing | bats-core |
| Navigation | zoxide |

## Shell Configuration

Zsh is configured with:
- `ZDOTDIR` set to `~/.config/zsh` (XDG compliant)
- Autosuggestions and completions via Homebrew
- Custom prompt and aliases in `.zshrc`

## Applications Configured

- **BBEdit** - Text editor with clippings, color schemes, scripts, language modules, and text filters
- **Xcode** - Code snippets, themes, keybindings, and custom project templates
- **Ghostty** - Terminal emulator configuration
- **Keyboard Maestro** - Automation macros
- **Claude Code** - AI assistant with MCP servers, custom skills (Bash, C++, Perl, Python, Git commit, GitHub CLI, file headers), and marketplace plugins (Swift Concurrency, SwiftUI)

## Author

Gary Ash <gary.ash@icloud.com>

## License

MIT License - see [LICENSE.markdown](LICENSE.markdown) for details.
