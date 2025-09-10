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
sudo apt install zsh tmux git
chsh -s /usr/bin/zsh
```

## Installation

```sh
mkdir -p ~/.local/bin
curl -fLo ~/.local/bin/yadm https://github.com/yadm-dev/yadm/raw/master/yadm && chmod a+x ~/.local/bin/yadm
~/.local/bin/yadm clone https://github.com/tlockney/dotfiles.git
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

## Using Claude Code (or similar tools) to work on these files

Since yadm places all the files in situ, it's unlikely going to be a good idea to
run `claude` in your home directory. Here's how to make this manageable.

1. Run `yadm worktree add -b claude-updates ~/src/personal/yadm-dotfiles`
2. `cd ~/src/personal/yadm-dotfiles`
3. Run `claude` and ask it to make whatever changes you deem appropriate.
4. `git commit -a -m "claude made some changes"`
5. yadm merge claude-updates

If you want to keep the `claude-updates` directory around, just be sure to run
`git merge main` before doing anything so it has the latest version of the code.
