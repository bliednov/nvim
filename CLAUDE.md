# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration using lazy.nvim as the plugin manager. The configuration is written in Lua.

## Code Style

Lua files are formatted with stylua. Configuration in `.stylua.toml`:
- Indent: 2 spaces
- Quotes: single preferred
- No call parentheses
- Column width: 160

## Commits

This project uses [Conventional Commits](https://www.conventionalcommits.org/). Commit messages should follow the format: `type: description` (e.g., `feat: add telescope keybindings`, `fix: correct LSP configuration`).

## Architecture

- `init.lua` - Entry point. Sets leader key (Space), bootstraps lazy.nvim, loads plugins from `lua/plugins/`
- `lua/settings.lua` - Vim options (tabs=4 spaces, persistent undo in `~/.vim/undodir`, etc.)
- `lua/remap.lua` - Global keymaps and user commands (`FormatDisable`, `FormatEnable`)
- `lua/plugins/` - Individual plugin specs (one file per plugin or group)

## Key Plugins

- **LSP**: nvim-lspconfig + mason.nvim for auto-installation. Configured servers: lua_ls, ts_ls, gopls, rust_analyzer, pylsp, html, tailwindcss, eslint, astro
- **Formatting**: conform.nvim with format-on-save (stylua for Lua, prettierd/prettier for JS/TS/JSON/YAML/HTML/CSS, goimports+golines for Go)
- **Completion**: nvim-cmp with LSP source
- **Fuzzy finding**: telescope.nvim with fzf-native
- **File explorer**: neo-tree.nvim
- **Treesitter**: nvim-treesitter with auto-install
