# Dotfiles

1. Installs Brew
2. Fixes "Home" and "End" buttons for macOS
3. Adds global git config
4. Installs and configures Vim

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

