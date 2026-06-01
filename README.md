# WIM : IDE-like Vim / Neovim Configuration

> *Based on [wolandark/wim](https://github.com/wolandark/wim) - modernized 2025*

WIM turns Vim or Neovim into a full-featured, IDE-like editor without abandoning the Vim philosophy. It layers LSP completion, fuzzy finding, a floating terminal, distraction-free writing, and a rich statusline on top of a carefully tuned set of core options - all in a single, well-commented `.vimrc`.

---

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Plugin Overview](#plugin-overview)
- [General Options](#general-options)
- [Key Mappings](#key-mappings)
  - [Leader & Basics](#leader--basics)
  - [Window & Split Navigation](#window--split-navigation)
  - [Tab Navigation](#tab-navigation)
  - [File & Buffer](#file--buffer)
  - [Editing Helpers](#editing-helpers)
  - [Spell Check](#spell-check)
  - [Terminal](#terminal)
  - [Floaterm](#floaterm)
  - [Coc.nvim (LSP)](#cocnvim-lsp)
  - [UltiSnips](#ultisnips)
  - [EasyMotion](#easymotion)
- [Plugin Configuration](#plugin-configuration)
  - [Lightline](#lightline)
  - [Netrw](#netrw)
  - [Startify](#startify)
  - [Tagbar](#tagbar)
  - [VimWiki](#vimwiki)
  - [clever-f](#clever-f)
- [Abbreviations](#abbreviations)
- [Custom Commands](#custom-commands)
- [Theme & Colors](#theme--colors)

---

## Requirements

- Vim 8.1+ or Neovim 0.5+
- `curl` (for bootstrapping vim-plug)
- A [Nerd Font](https://www.nerdfonts.com/) - FiraCode Nerd Font is set by default
- `figlet` and `boxes` - for the Startify ASCII banner
- `ctags` - for Tagbar
- Node.js - required by coc.nvim
- Optional: `ranger` or `vifm` for the floaterm file-manager shortcuts

---

## Installation

```bash
# 1. Back up your existing config
cp ~/.vimrc ~/.vimrc.bak          # Vim
cp ~/.config/nvim/init.vim ~/.config/nvim/init.vim.bak   # Neovim

# 2. Copy wim's vimrc into place
cp wim.vimrc ~/.vimrc             # Vim
cp wim.vimrc ~/.config/nvim/init.vim   # Neovim

# 3. Open Vim - vim-plug auto-installs itself, then installs all plugins
vim
```

vim-plug is bootstrapped automatically on first launch via `curl`. After plugins install, restart Vim once to load everything cleanly.

---

## Plugin Overview

| Category | Plugin | Purpose |
|---|---|---|
| Git | vim-fugitive | Full Git integration (:Git, :Gdiff, :Gblame, …) |
| Editing | vim-surround | Add/change/delete surrounding pairs |
| Editing | vim-commentary | Toggle comments with `gcc` / `gc{motion}` |
| Editing | vim-repeat | Makes plugin actions repeatable with `.` |
| Editing | vim-eunuch | Shell commands: `:Rename` `:Move` `:Delete` `:Chmod` |
| Editing | auto-pairs | Auto-close brackets, quotes, and parens |
| Motion | vim-easymotion | Hop anywhere visible with a 2-keystroke label |
| Motion | clever-f.vim | Smarter `f`/`t` - press again to repeat |
| Fuzzy Find | fzf + fzf.vim | Files, buffers, history, colors, maps pickers |
| Completion | coc.nvim | LSP client + popup completion engine |
| Snippets | UltiSnips | Snippet engine |
| Snippets | vim-snippets | Community snippet library |
| UI | lightline.vim | Statusline with word count, mode, path |
| UI | vim-startify | Start screen with bookmarks, recent files, sessions |
| UI | vim-floaterm | Floating / split terminal windows |
| UI | goyo.vim | Distraction-free writing mode |
| UI | vim-peekaboo | Preview registers before pasting |
| Colors | base16-vim | Base16 colorscheme collection |
| Colors | catppuccin/vim | Catppuccin colorscheme (available, not active) |
| Colors | nvim-colorizer.lua | Inline hex/rgb color preview (Neovim only) |
| Alignment | tabular | Align text by delimiter with `:Tabularize` |
| Tags | tagbar | Sidebar showing ctags for current file |
| Filetype | vim-sxhkdrc | Syntax highlighting for sxhkd configs |
| Filetype | vimwiki | Personal wiki with diary and links |
| Filetype | MatchTagAlways | Always highlight matching HTML/XML tags |
| Misc | traces.vim | Live substitution preview while typing `:s/…` |
| Misc | vim-auto-save | Optional per-buffer auto-save |
| Misc | sparkup | Expand CSS-selector abbreviations into HTML |
| Misc | loremipsum | `:Loremipsum` inserts placeholder text |
| Misc | vim-simple-emoji | Insert emoji by name |

---

## General Options

| Option | Value | Effect |
|---|---|---|
| `encoding` | utf-8 | Always use UTF-8 |
| `hidden` | on | Keep buffers alive when abandoned |
| `autoread` | on | Auto-reload files changed on disk |
| `autowrite` | on | Auto-write before `:make`, `:next`, etc. |
| `noswapfile` | - | No swap files created |
| `undofile` | on | Persistent undo stored in `~/.vimhis` |
| `undolevels` | 5000 | Up to 5000 undo steps per file |
| `expandtab` | on | Tabs expand to spaces |
| `shiftwidth` / `tabstop` | 4 | 4-space indentation |
| `relativenumber` + `number` | on | Relative numbers + absolute on current line |
| `signcolumn` | yes | Always-visible sign column (no layout jumping) |
| `colorcolumn` | 80 | Visual guide at column 80 |
| `scrolloff` | 6 | Keep 6 lines visible above/below cursor |
| `sidescrolloff` | 4 | Keep 4 columns visible left/right |
| `splitbelow` / `splitright` | on | New splits open below and to the right |
| `whichwrap` | `<,>,h,l` | Arrow keys and `h`/`l` wrap across line ends |
| `foldmethod` | indent | Indent-based folding |
| `wildmode` | longest:full,full | Enhanced command-line completion cycling |
| `path+=**` | - | Recursive file search for `:find` |
| `clipboard` | unnamedplus,unnamed | Yank/paste synced with system clipboard |
| `lazyredraw` | on | Don't redraw during macros (faster) |
| `noerrorbells` / `novisualbell` | - | Completely silent |
| `autochdir` | on | CWD follows the current file |
| `updatetime` | 300 | Faster CursorHold (helps coc diagnostics) |
| `cmdheight` | 2 | Taller command area for coc messages |
| `conceallevel` | 0 | Never hide/conceal text |
| `termbidi` | on | Bi-directional text (Arabic/Hebrew support) |
| `guifont` | FiraCode Nerd Font 12 | GUI font |
| `guicursor blinkon0` | - | Cursor blink disabled |
| `BufReadPost` autocmd | - | Cursor returns to last position on file open |

---

## Key Mappings

> **Leader key:** `<Space>`

### Leader & Basics

| Key | Mode | Action |
|---|---|---|
| `<Space>` | - | Leader key |
| `;` | Normal | Enter command mode (maps to `:`) |
| `jj` | Insert | Escape to normal mode |
| `<C-m>` | Normal | Jump to middle of current line |
| `<Esc>` | Normal | Clear search highlights |

### Window & Split Navigation

| Key | Mode | Action |
|---|---|---|
| `<C-h/j/k/l>` | Normal | Move between splits |
| `<C-Left/Down/Up/Right>` | Normal | Move between splits (arrow keys) |
| `<S-Left/Right>` | Normal | Resize vertical split ±5 columns |
| `<S-Up/Down>` | Normal | Resize horizontal split ±5 rows |
| `<leader>R` | Normal | Rotate windows (`<C-w>R`) |
| `<A-h/j/k/l>` | Insert | Move cursor without leaving insert mode |
| `<A-b/w>` | Insert | Jump word backward/forward in insert mode |

### Tab Navigation

| Key | Mode | Action |
|---|---|---|
| `<M-Left>` / `<M-h>` | Normal | Previous tab |
| `<M-Right>` / `<M-l>` | Normal | Next tab |
| `<leader>1` – `<leader>9` | Normal | Jump directly to tab 1–9 |
| `<leader>0` | Normal | Jump to last tab |
| `<leader>T` | Normal | Open new tab |
| `<leader>x` | Normal | Close current tab |
| `<leader>tm` | Normal | Move tab (`:tabmove`) |

### File & Buffer

| Key | Mode | Action |
|---|---|---|
| `<leader>w` | Normal | Save file (`:w!`) |
| `<leader>op` | Normal | Source current file |
| `<leader>mk` | Normal | Save view (`:mkview`) |
| `<leader>b` | Normal | Open Buffers picker (fzf) |
| `<leader>s` | Normal | Open Files picker (fzf) |
| `<leader>W` | Normal | Open Windows picker (fzf) |
| `<leader>H` | Normal | Open History picker (fzf) |
| `<leader>Hc` | Normal | Open command history picker |
| `<leader>M` | Normal | Open Maps picker (fzf) |
| `<leader>c` | Normal | Open Colors picker (fzf) |
| `<leader>i` | Normal | Open Startify dashboard |
| `<leader>e` | Normal | Toggle coc-explorer file tree |

### Editing Helpers

| Key | Mode | Action |
|---|---|---|
| `<leader>d` | Normal | Delete duplicate lines |
| `<leader>S` | Normal | Add empty line above and below current line |
| `<leader>[` | Normal | Insert empty line above |
| `<leader>]` | Normal | Insert empty line below |
| `<leader>k` | Normal/Visual | Move line / selection up |
| `<leader>j` | Normal/Visual | Move line / selection down |
| `<leader>u` | Normal | Move current line above the one before it |
| `<leader>h` | Normal | Make file executable (`:Chmod +x`) |
| `<leader>\` | Normal | Wrap current line in a toilet/figlet border banner |
| `bs` | Normal | Insert `#!/bin/bash` shebang |
| `be` | Normal | Insert `#!/usr/bin/env bash` shebang |
| `br` | Normal | Insert `<br>` tag |

### Spell Check

| Key | Mode | Action |
|---|---|---|
| `<F6>` | Normal | Toggle spell check (en_us) |
| `<leader>z` | Normal | Auto-fix word under cursor (`1z=`) |
| `<leader>l` | Normal | Auto-fix next 16 misspelled words |

Misspelled words are highlighted in red via `SpellBad`.

### Terminal

| Key | Mode | Action |
|---|---|---|
| `<leader>'` | Normal | Open terminal in bottom split (12 lines tall) |
| `<C-j>` | Terminal | Exit terminal mode, move to split below |
| `<C-k>` | Terminal | Exit terminal mode, move to split above |
| `<Esc>` | Terminal | Exit terminal mode |

Shell is set to `/bin/bash`. Terminal split is full-width, 12 lines tall.

### Floaterm

| Key | Mode | Action |
|---|---|---|
| `<leader>t` | Normal | Toggle floating terminal |
| `<leader>v` | Normal | Open vifm in floaterm |
| `<leader>r` | Normal | Open ranger in floaterm |

Floaterm occupies 40% screen height × 85% screen width. It stays open when focus leaves it.

### Coc.nvim (LSP)

| Key | Mode | Action |
|---|---|---|
| `<Tab>` | Insert | Cycle forward through completion popup |
| `<S-Tab>` | Insert | Cycle backward through completion popup |
| `<CR>` | Insert | Confirm completion selection |
| `gd` | Normal | Go to definition |
| `gy` | Normal | Go to type definition |
| `gr` | Normal | List references |
| `gi` | Normal | Go to implementation |
| `<leader>rn` | Normal | Rename symbol under cursor |
| `[g` / `]g` | Normal | Jump to previous / next diagnostic |
| `K` | Normal | Show hover documentation |

### UltiSnips

| Key | Mode | Action |
|---|---|---|
| `<C-j>` | Insert | Expand snippet / jump forward in snippet |
| `<C-k>` | Insert | Jump backward in snippet |
| `<C-PageDown>` | Insert | List available snippets |

### EasyMotion

| Key | Action |
|---|---|
| `fy` | Jump to any character across all windows |
| `fl` | Jump to any line across all windows |
| `ml` | Bidirectional line jump |
| `fw` | Jump to any word across all windows |
| `s` | Two-character jump across all windows |
| `<leader>f` | Forward word jump |
| `<leader>m` | Bidirectional word jump |

---

## Plugin Configuration

### Lightline

Statusline layout:

- **Left:** mode | readonly | full filepath | modified flag
- **Right:** line/total lines | percentage | word count | filetype

Uses Powerline Nerd Font separators (``, ``, ``, ``). A custom `WordCount()` function displays the live word count of the current buffer.

### Netrw

| Setting | Value | Effect |
|---|---|---|
| `netrw_liststyle` | 3 | Tree-style directory listing |
| `netrw_winsize` | 15 | Panel takes 15% of screen width |
| `netrw_banner` | 0 | Banner hidden |
| `netrw_browse_split` | 4 | Open files in previous window |
| `netrw_list_hide` | dotfiles pattern | Dotfiles hidden by default |
| `netrw_keepdir` | 0 | CWD tracks netrw's directory |

`%` in the netrw buffer creates a new file via `:touch` in the current directory. The netrw panel (and quickfix) auto-closes if it becomes the last window.

### Startify

- ASCII art "Vim" header rendered via `figlet -f roman | boxes -d parchment`
- Footer: *"Once you get in, there is no getting out."*
- Bookmarks: `~/.config/i3/config`, `~/.bashrc`, `~/.vimrc`
- Lists shown: Bookmarks → Recent files → Sessions → Commands

### Tagbar

- `autofocus` and `autoupdate` enabled - Tagbar focuses and refreshes automatically
- Custom ctags type for VimWiki headers via `~/vwtags.py`

### VimWiki

- Wiki root: `~/vimwiki/`
- `vimwiki_global_ext = 0` - VimWiki only applies to files inside its root, not all `.wiki` files

### clever-f

- Case-insensitive by default
- Works across lines (`across_no_line = 0`)
- Matching character highlighted via `StatuslineTermNC`

---

## Abbreviations

These expand automatically in insert mode:

| Abbreviation | Expands to |
|---|---|
| `tea` | ☕ |
| `ptr` | ▶ |
| `cbe` | ▄ |
| `cbe2` | ■ |
| `okk` | ✓ |
| `str` | ★ |

---

## Custom Commands

| Command | Action |
|---|---|
| `:Ra` | Launch ranger in shell |
| `:Vi` | Launch vifm in shell |
| `:Na` | Open a new tab (alias for `:tabnew`) |

---

## Theme & Colors

- **Active colorscheme:** `base16-gruvbox-dark-hard` (dark background)
- **True color** enabled via `termguicolors` when the terminal supports it
- **Column 80 marker** styled to `#242424`
- **GUI font:** FiraCode Nerd Font 12
- Cursor blink is disabled globally

**Also available (not active by default):**

- `catppuccin` - swap in with `:colorscheme catppuccin_mocha` (or any catppuccin variant)
- Any other `base16-*` scheme from the base16-vim collection - browse them with `<leader>c`

For Neovim, `nvim-colorizer.lua` renders inline color previews for hex and RGB values directly in the buffer.

---

## HTML Skeleton

New `.html` files automatically load `~/.vim/skeleton.xml` as a starting template via a `BufNewFile` autocmd.

HTML indentation is configured for scripts, styles, attributes, and common inline tags (`html`, `body`, `head`, `tbody`).

---

## Auto-save

Auto-save is **off by default**. Enable it per-buffer with:

```vim
:AutoSaveToggle
```

---

## License

See the original project at [https://github.com/wolandark/wim](https://github.com/wolandark/wim).
