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
