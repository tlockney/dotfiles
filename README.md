# My Dotfiles

## Prerequisites

### MacOS

```sh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install tmux
```

### Linux

```sh
sudo apt install zsh tmux
chsh -s /usr/bin/zsh
```

## Installation

```sh
mkdir -p ~/bin
curl -fLo ~/bin/yadm https://github.com/yadm-dev/yadm/raw/master/yadm && chmod a+x ~/bin/yadm
~/bin/yadm clone https://github.com/tlockney/dotfiles.git
```

## Tips

 - Get all currently tracked files:

```sh
yadm ls-files
```

 - Run 1password secret injection on all `.op_tpl` files:

```sh
for file in $(cd $HOME; yadm ls-files | grep '.op_tpl'); do
  out=${file%%.op_tpl}
  op inject -i $HOME/$file -o $HOME/$out
done
```
