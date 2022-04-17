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
brew install git git-delta bat ripgrep fzf nvim gh fd
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

