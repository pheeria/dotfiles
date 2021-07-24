# Dotfiles

1. Installs Brew
2. Fixes "Home" and "End" buttons for macOS
3. Installs and configures Vim, Neovim, OhMyZsh, iTerm2 and git

## Set System Preferences

### Keyboard
1. Remap CapsLock to Escape `System Preferences -> Keyboard -> Modifier Keys`
2. Set `Input Sources` to `Kazakh` and `ABC - Extended`

### Monitor
1. Turn OFF `Font smoothing` in `System Preferences -> General`
2. For Big Sur:
```shell
defaults -currentHost write -g AppleFontSmoothing -int 0
```
3. In `System Preferences -> Display` set `Resolution: Scaled` and select the middle choice

[Source - nikitonsky](https://tonsky.me/blog/monitors/)

## iTerm
1. General -> Preferences -> Load Preferences from a custom folder

## Fonts
1. [Hermit](https://github.com/pcaro90/hermit)
2. [Cascadia Code](https://github.com/microsoft/cascadia-code)

## How to update Vim?

```sh
git clone https://github.com/vim/vim.git
cd vim/src
make
sudo make install
```

Create a symbolic link for `vi`
```sh
sudo ln -s /usr/local/bin/vim /usr/local/bin/vi
```

[Source](https://medium.com/swlh/vim-is-vulnerable-update-vim-on-macos-66402e5ab46a)

### Vim Tricks

- Ignore sudo protection while saving
```vim
:w !sudo tee %
```

- Output external command's result in Vim
```vim
:.! date
```

Command history
```
q:
```

Open a URL (note the slash at the end)
```shell
vim https://stackoverflow.com/
```

### Profiling

[From Stack Overflow](https://stackoverflow.com/a/12216578)

```vim
:profile start profile.log
:profile func *
:profile file *
" At this point do slow actions
:profile pause
:noautocmd qall!
```

