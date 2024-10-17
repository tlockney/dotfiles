# My Dotfiles

Based on [this helpful guide](https://www.atlassian.com/git/tutorials/dotfiles) from Atlassian.

## Installation

```sh
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
git clone --bare git@github.com:tlockney/dotfiles.git $HOME/.cfg
config checkout
```

If you get errors because of existing files, run:
```sh
mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}
```

Delete `.config-backup` once you've verified nothing important will be lost.

## Tips

 - Shouldn't need to ever do this again, but to be safe, sharing the steps to create this repo:

```sh
git init --bare $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
```

 - Get all currently tracked files:

```sh
(cd $HOME; config ls-files)
```

 - Run 1password secret injection on all `.op_tpl` files:

```sh
for file in $(cd $HOME; config ls-files | grep '.op_tpl'); do
  out=${file%%.op_tpl}
  op inject -i $HOME/$file -o $HOME/$out
done
```
