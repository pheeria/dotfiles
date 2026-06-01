#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

readonly GITHUB="https://github.com"
readonly PACK="$HOME/.vim/pack"

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "mac" ;;
    Linux)  echo "linux" ;;
    *)      echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
  esac
}

install_packages_mac() {
  if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew bundle
}

install_packages_linux() {
  sudo apt-get update
  sudo apt-get install -y curl fzf git nodejs npm python3 python3-pip ripgrep stow vim
}

link_dotfiles() {
  local pkg
  for pkg in "$@"; do
    stow --restow "$pkg"
  done
}

ensure_runtime_dirs() {
  mkdir -p "$HOME/.vim/undodir"
}

clone_plugin() {
  local slug="$1" dest="$2" branch="${3:-}"
  mkdir -p "$(dirname "$dest")"

  if [[ -d "$dest/.git" ]]; then
    echo "Updating $slug"
    git -C "$dest" pull --ff-only || {
      echo "Failed to update $dest; resolve conflicts in that directory and retry." >&2
      exit 1
    }
  elif [[ -n "$branch" ]]; then
    echo "Cloning $slug (branch $branch)"
    git clone --branch "$branch" --single-branch "$GITHUB/$slug.git" "$dest"
  else
    echo "Cloning $slug"
    git clone "$GITHUB/$slug.git" "$dest"
  fi
}

install_plugins() {
  local visual="$PACK/visual/start"
  local tpope="$PACK/tpope/start"
  local junegunn="$PACK/junegunn/start"
  local plugins="$PACK/plugins/start"

  clone_plugin rakr/vim-one               "$visual/one"
  clone_plugin arcticicestudio/nord-vim   "$visual/nord"
  clone_plugin embark-theme/vim           "$visual/embark"
  clone_plugin rose-pine/vim              "$visual/rose-pine"
  clone_plugin leafgarland/typescript-vim "$visual/typescript"
  clone_plugin pangloss/vim-javascript    "$visual/javascript"
  clone_plugin MaxMEllon/vim-jsx-pretty   "$visual/jsx"

  clone_plugin tpope/vim-commentary       "$tpope/commentary"
  clone_plugin tpope/vim-fugitive         "$tpope/fugitive"
  clone_plugin tpope/vim-projectionist    "$tpope/projectionist"
  clone_plugin tpope/vim-repeat           "$tpope/repeat"
  clone_plugin tpope/vim-sleuth           "$tpope/sleuth"
  clone_plugin tpope/vim-surround         "$tpope/surround"
  clone_plugin tpope/vim-unimpaired       "$tpope/unimpaired"
  clone_plugin tpope/vim-vinegar          "$tpope/vinegar"

  clone_plugin junegunn/fzf.vim           "$junegunn/fzf"
  clone_plugin junegunn/goyo.vim          "$junegunn/goyo"
  clone_plugin junegunn/limelight.vim     "$junegunn/limelight"

  clone_plugin neoclide/coc.nvim          "$plugins/coc" release
  clone_plugin plasticboy/vim-markdown    "$plugins/markdown"
  clone_plugin reedes/vim-pencil          "$plugins/pencil"
  clone_plugin vim-test/vim-test          "$plugins/test"
  clone_plugin vimwiki/vimwiki            "$plugins/wiki"
}

main() {
  local os
  os="$(detect_os)"

  case "$os" in
    mac)
      install_packages_mac
      link_dotfiles ghostty git zsh vim nvim misc
      ;;
    linux)
      install_packages_linux
      link_dotfiles git vim
      ;;
  esac

  ensure_runtime_dirs
  install_plugins
}

main "$@"
