# tngranados dotfiles

Clone repository and use `make` for further instructions.

```zsh
git clone https://github.com/tngranados/dotfiles.git
cd dotfiles
make
```

If not cloned in `~/dotfiles` you need to setup a `$DOTFILES` variable with its path.

You can include your own zsh files in `$DOTFILES/local/zsh` and they will be loaded automatically.

## Dependencies

To install all of the dependencies run:

```zsh
brew tap homebrew/cask-fonts
brew install --cask font-iosevka
brew install git git-delta bat ripgrep fzf nvim gh fd tldr httpie lazygit jq zoxide entr imagemagick difftastic sox wezterm ncdu eza
```

### To add a new zsh plugin:

1. Add the gitsubmodule to ./zsh

```zsh
git submodule add <remote_url> ./zsh/<plugin_folder>
```

2. Update Makefile's install-core function to link the `.zsh` file to local

```makefile
@printf "Setting up <plugin_name>..."
@[ ! -f $(PWD)/local/zsh/<plugin_name>.plugin.zsh ] && ln -s $(PWD)/zsh/<plugin_folder/<plugin_name>.plugin.zsh $(PWD)/local/zsh/<plugin_name>.plugin.zsh && printf "done\n" || printf "already done\n"
```

### To remove a zsh plugin

1. Delete the relevant line from the .gitmodules file
2. Delete the relevant section from .git/config
3. Run `git rm --cached ./zsh/<plugin_folder>`
4. Update Makefile's install-core function to remove relevant section
5. Commit and delete the now untracked submodule files
