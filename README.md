# tngranados dotfiles

These are my dotfiles and configurations.

## Setup

First step is to [install Homebrew](https://brew.sh):

```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew tap Homebrew/bundle
```

Then, clone the repository and install all of the dependencies and tools:

```zsh
git clone https://github.com/tngranados/dotfiles.git
cd dotfiles
brew bundle
```

After all dependencies are installed, you can run `stow` from the dotfiles directory to link the files:

```zsh
stow -t $HOME -d $HOME/dotfiles/config .
```

Now, restart the shell or run `source /Users/tngranados/.zshrc` to reload the settings.

To setup the basic macOS configuration, run:

```zsh
./setup-mac.sh
```
