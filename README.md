# My Dotfiles

Based on [this helpful guide](https://www.atlassian.com/git/tutorials/dotfiles) from Atlassian.

## Installation

```sh
mkdir -p ~/bin
curl -fLo ~/bin/yadm https://github.com/yadm-dev/yadm/raw/master/yadm && chmod a+x ~/bin/yadm
~/bin/yadm clone git@github.com:tlockney/dotfiles.git
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
