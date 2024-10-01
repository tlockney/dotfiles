# Home Setup

Based on [this helpful guide](https://www.atlassian.com/git/tutorials/dotfiles) from Atlassian.

## Tips

Init config:

```sh
git init --bare $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no

```

Get all currently tracked files:

```sh
config ls-tree -r main --name-only
```

Run 1password secret injection on all `.op_tpl` files:

```sh
for file in $(config ls-tree -r main --name-only | grep '.op_tpl'); do
  out=${file%%.op_tpl}
  op inject -i $HOME/$file -o $HOME/$out
done
```
