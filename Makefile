.PHONY: help
help: ## Display this help section
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-38s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
.DEFAULT_GOAL := help

.PHONY: update
update: ## Updates dotfiles
	@printf "Updating repo...\n"
	@git pull
	@printf "Updating externals... "
	@git submodule update --remote --merge
	@printf "done\n"

.PHONY: install
install: ## Installs core and mac specific dotfiles
	@(ENV="" $(MAKE) install-externals --no-print-directory)
	@(ENV="" $(MAKE) install-core --no-print-directory)
	@printf "Setting up .gitconfig in the home directory... "
	@ln -s $(PWD)/gitconfig $(HOME)/.gitconfig && printf "done\n"
	@printf "Setting up work .gitconfig in the work directory... "
	@mkdir -p "$(HOME)/Developer/work"
	@[ ! -f $(HOME)/Developer/work/.gitconfig ] && ln -s $(PWD)/gitconfig-work $(HOME)/Developer/work/.gitconfig && printf "done\n" || printf "already done\n"
	@printf "Setting up .finicky.js in the home directory... "
	@ln -s $(PWD)/.finicky.js $(HOME)/.finicky.js && printf "done\n"
	@[ ! -f $(PWD)/local/zsh/mac.zsh ] && ln -s $(PWD)/zsh/mac.zsh $(PWD)/local/zsh/mac.zsh || :

.PHONY: clean-local
clean-local:
	@rm -rf $(PWD)/local/*.bak $(PWD)/local/zsh/zprofile.zsh $(PWD)/local/zsh/z.zsh $(PWD)/local/zsh/zsh-better-npm-completion.plugin.zsh $(PWD)/local/zsh/zsh-history-substring-search.zsh $(PWD)/local/zsh/geometry.zsh $(PWD)/local/zsh/fast-syntax-highlighting.zsh $(PWD)/local/zsh/linux.zsh $(PWD)/local/zsh/mac.zsh 2> /dev/null

.PHONY: install-core
install-core:
	@printf "Setting up local configuration... "
	@mkdir -p "$(PWD)/local"
	@mkdir -p "$(PWD)/local/zsh"
	@[ ! -f $(PWD)/local/zsh/zprofile.zsh ] && touch $(PWD)/local/zsh/zprofile.zsh || :
	@printf "done\n"
	@printf "Backing up the current .zshrc... "
	@[ -f $(HOME)/.zshrc ] && mv $(HOME)/.zshrc $(PWD)/local/zshrc.bak && printf "done\n" || printf "already done\n"
	@printf "Creating .zshrc in the home directory... "
	@ln -s $(PWD)/zshrc $(HOME)/.zshrc && printf "done\n"
	@printf "Setting up prompt theme... "
	@[ ! -f $(PWD)/local/zsh/geometry.zsh ] && ln -s $(PWD)/zsh/geometry/geometry.zsh $(PWD)/local/zsh/geometry.zsh && printf "done\n" || printf "already done\n"
	@printf "Setting up syntax highlightning... "
	@[ ! -f $(PWD)/local/zsh/fast-syntax-highlighting.zsh ] && echo "source $(PWD)/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" > $(PWD)/local/zsh/fast-syntax-highlighting.zsh && printf "done\n" || printf "already done\n"
	@printf "Setting up history search... "
	@[ ! -f $(PWD)/local/zsh/zsh-history-substring-search.zsh ] && ln -s $(PWD)/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh $(PWD)/local/zsh/zsh-history-substring-search.zsh && printf "done\n" || printf "already done\n"
	@printf "Setting up npm completion... "
	@[ ! -f $(PWD)/local/zsh/zsh-better-npm-completion.plugin.zsh ] && ln -s $(PWD)/zsh/zsh-better-npm-completion/zsh-better-npm-completion.plugin.zsh $(PWD)/local/zsh/zsh-better-npm-completion.plugin.zsh && printf "done\n" || printf "already done\n"
	@printf "Setting up better zsh vim mode... "
	@[ ! -f $(PWD)/local/zsh/zsh-vim-mode.plugin.zsh ] && ln -s $(PWD)/zsh/zsh-vim-mode/zsh-vim-mode.plugin.zsh $(PWD)/local/zsh/zsh-vim-mode.plugin.zsh && printf "done\n" || printf "already done\n"
	@printf "Setting up z..."
	@[ ! -f $(PWD)/local/zsh/z.sh ] && ln -s $(PWD)/zsh/z/z.sh $(PWD)/local/zsh/z.sh && printf "done\n" || printf "already done\n"
	@printf "Backing up the current .gitattributes... "
	@[ -f $(HOME)/.gitattributes ] && mv $(HOME)/.gitattributes $(PWD)/local/gitattributes.bak && printf "done\n" || printf "already done\n"
	@printf "Setting up .gitattributes in the home directory... "
	@ln -s $(PWD)/gitattributes $(HOME)/.gitattributes && printf "done\n"
	@printf "Backing up the current .gitconfig... "
	@[ -f $(HOME)/.gitconfig ] && mv $(HOME)/.gitconfig $(PWD)/local/gitconfig.bak && printf "done\n" || printf "already done\n"
	@printf "Backing up the current .finicky.js... "
	@[ -f $(HOME)/.finicky.js ] && mv $(HOME)/.finicky.js $(PWD)/local/.finicky.js.bak && printf "done\n" || printf "already done\n"

.PHONY: install-externals
install-externals:
	@printf "Updating external libraries...\n"
	@git submodule update --init
