# Dotfiles

1. Installs Brew
2. Fixes "Home" and "End" buttons for macOS
3. Adds global git config
4. Installs and configures Vim

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

## Fonts
1. [Hermit](https://github.com/pcaro90/hermit)
2. [Cascadia Code](https://github.com/microsoft/cascadia-code)

