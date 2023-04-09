//# rdorin dotfiles, borrowed from https://github.com/ChristianChiarulli/Machfiles
# dotfiles

![machfiles image](./machfiles.png)

## Setup

You should have `git` and `homebrew` installed. If you want to install my programs, you can do that by executing the `install.sh` after cloning the repository.
```bash
~/dotfiles/install.sh
```

## Installing

You will need `git` and GNU `stow`

Clone into your `$HOME` directory

```bash
git clone git@github.com:rdorin/dotfiles.git ~/dotfiles
```

Run `stow` to symlink everything or just select what you want

```bash
stow */ # Everything (the '/' ignores the README)
```

```bash
stow zsh # Just my zsh config
```
