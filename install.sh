#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

readonly GITHUB="https://github.com"

install_packages_mac() {
  if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew bundle
}

install_packages_linux() {
  sudo apt-get update
  sudo apt-get install -y curl fzf git jq nodejs npm python3 python3-pip ripgrep stow vim
}

backup_conflicts() {
  local pkg="$1" file rel target
  while IFS= read -r -d '' file; do
    rel="${file#$pkg/}"
    target="$HOME/$rel"
    if [[ -f "$target" && ! -L "$target" ]]; then
      echo "Backing up $target -> $target.predotfiles" >&2
      mv "$target" "$target.predotfiles"
    fi
  done < <(git ls-files -z -- "$pkg")
}

link_dotfiles() {
  local pkg
  for pkg in "$@"; do
    backup_conflicts "$pkg"
    stow --target="$HOME" --dir="$PWD" --no-folding --restow "$pkg"
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
      echo "Failed to update $dest; investigate and resolve before retrying." >&2
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
  local plugins="$HOME/.vim/pack/plugins/start"

  clone_plugin rakr/vim-one               "$plugins/one"
  clone_plugin arcticicestudio/nord-vim   "$plugins/nord"
  clone_plugin leafgarland/typescript-vim "$plugins/typescript"
  clone_plugin pangloss/vim-javascript    "$plugins/javascript"
  clone_plugin MaxMEllon/vim-jsx-pretty   "$plugins/jsx"
  clone_plugin drsooch/gruber-darker-vim  "$plugins/gruber-darker"

  clone_plugin tpope/vim-commentary       "$plugins/commentary"
  clone_plugin tpope/vim-fugitive         "$plugins/fugitive"
  clone_plugin tpope/vim-projectionist    "$plugins/projectionist"
  clone_plugin tpope/vim-repeat           "$plugins/repeat"
  clone_plugin tpope/vim-sleuth           "$plugins/sleuth"
  clone_plugin tpope/vim-surround         "$plugins/surround"
  clone_plugin tpope/vim-unimpaired       "$plugins/unimpaired"
  clone_plugin tpope/vim-vinegar          "$plugins/vinegar"

  clone_plugin junegunn/fzf.vim           "$plugins/fzf"
  clone_plugin junegunn/goyo.vim          "$plugins/goyo"
  clone_plugin junegunn/limelight.vim     "$plugins/limelight"

  clone_plugin plasticboy/vim-markdown    "$plugins/markdown"
  clone_plugin reedes/vim-pencil          "$plugins/pencil"
  clone_plugin vim-test/vim-test          "$plugins/test"
  clone_plugin vimwiki/vimwiki            "$plugins/wiki"
  clone_plugin neoclide/coc.nvim          "$plugins/coc" release
  clone_plugin embark-theme/vim           "$plugins/embark"
  clone_plugin rose-pine/vim              "$plugins/rose-pine"
}

install_terminfo() {
  local src="terminfo/xterm-ghostty.src"
  if command -v tic >/dev/null 2>&1 && [[ -f "$src" ]]; then
    tic -x "$src"
  fi
}

install_codespaces_vscode() {
  local src="$PWD/misc/Library/Application Support/Code/User/settings.json"
  local dir="$HOME/.vscode-remote/data/Machine"
  local target="$dir/settings.json"

  mkdir -p "$dir"
  if [[ -f "$target" ]]; then
    local tmp; tmp=$(mktemp)
    jq -s '.[0] * .[1]' "$target" "$src" > "$tmp"
    mv "$tmp" "$target"
  else
    cp "$src" "$target"
  fi
}

generate_helptags() {
  local doc
  for doc in "$HOME/.vim/pack/plugins/start"/*/doc; do
    [[ -d "$doc" ]] || continue
    vim -u NONE -es -c "helptags $doc" -c q
  done
}

main() {
  case "$(uname -s)" in
    Darwin)
      install_packages_mac
      link_dotfiles ghostty git zsh vim nvim misc
      ;;
    Linux)
      install_packages_linux
      link_dotfiles git vim zsh
      if [[ -n "${CODESPACES:-}" ]]; then
        install_codespaces_vscode
      fi
      ;;
    *)
      echo "Unsupported OS: $(uname -s)" >&2
      exit 1
      ;;
  esac

  ensure_runtime_dirs
  install_terminfo
  install_plugins
  generate_helptags
}

main
