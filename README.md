# tngranados dotfiles

These are my dotfiles and configurations.

## Setup

First step is to [install Homebrew](https://brew.sh):

```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew tap Homebrew/bundle
```

After setting up the ssh keys, clone the repository and install all of the dependencies and tools:

```zsh
git clone git@github.com:tngranados/dotfiles.git
cd dotfiles
brew bundle
```

After all dependencies are installed, you can run `stow` from the dotfiles directory to link the files:

```zsh
stow -t $HOME -d $HOME/dotfiles/config .
```

Note, some of the files in this repo are encrypted with `git-crypt`, in order to decrypt them, run:

```zsh
git-crypt unlock /path/to/key
```

Now, restart the shell or run `source /Users/tngranados/.zshrc` to reload the settings.

To setup the basic macOS configuration, first grant the Terminal full disk access (System Preferences -> Privacy -> Full Disk Access), then run:

```zsh
./setup-mac.sh
```

## How to find out defaults commands

In order to figure out the `defaults` commands to change settings in an app, we need to first find out its bundle identifier:

```zsh
mdls -name kMDItemCFBundleIdentifier -r /Applications/AppName.app
```

Then, read the existing defaults with:

```zsh
defaults read <bundle_identifier>
```

Change the settings through the UI, then run the command again and check the differences to see which values to change.
