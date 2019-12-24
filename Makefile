.PHONY: help
help: ## Display this help section
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-38s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
.DEFAULT_GOAL := help

.PHONY: update
update: ## Updates dotfiles
	@echo "Updating repo..."
	@git pull
	@(ENV="" $(MAKE) install-externals --no-print-directory)

.PHONY: install
install:
	@echo "Use either 'install-mac' or 'install-linux'"

.PHONY: install-mac
install-mac: ## Installs core and mac specific dotfiles
	@(ENV="" $(MAKE) install-externals --no-print-directory)
	@(ENV="" $(MAKE) install-core --no-print-directory)
	@echo "Setting up .gitconfig in the home directory..."
	@ln -s $(PWD)/gitconfig.mac $(HOME)/.gitconfig
	@[ ! -f $(PWD)/local/zsh/mac.zsh ] && ln -s $(PWD)/zsh/mac.zsh $(PWD)/local/zsh/mac.zsh

.PHONY: install-linux
install-linux: ## Installs core and linux specific dotfiles
	@(ENV="" $(MAKE) install-externals --no-print-directory)
	@(ENV="" $(MAKE) install-core --no-print-directory)
	@echo "Setting up .gitconfig in the home directory..."
	@ln -s $(PWD)/gitconfig.linux $(HOME)/.gitconfig
	@[ ! -f $(PWD)/local/zsh/linux.zsh ] && ln -s $(PWD)/zsh/linux.zsh $(PWD)/local/zsh/linux.zsh

.PHONY: clean-local
clean-local:
	@rm -rf $(PWD)/local/*.bak $(PWD)/local/zsh/zprofile.zsh $(PWD)/local/zsh/zsh-better-npm-completion.plugin.zsh $(PWD)/local/zsh/zsh-history-substring-search.zsh $(PWD)/local/zsh/geometry.zsh $(PWD)/local/zsh/fast-syntax-highlighting.zsh $(PWD)/local/zsh/linux.zsh $(PWD)/local/zsh/mac.zsh 2> /dev/null

.PHONY: install-core
install-core:
	@echo "Installing..."
	@mkdir -p "$(PWD)/local"
	@mkdir -p "$(PWD)/local/zsh"
	@[ ! -f $(PWD)/local/zsh/zprofile.zsh ] && touch $(PWD)/local/zsh/zprofile.zsh
	@echo "Backing up the current .zshrc..."
	@[ -f $(HOME)/.zshrc ] && mv $(HOME)/.zshrc $(PWD)/local/zshrc.bak
	@echo "Creating .zshrc in the home directory..."
	@ln -s $(PWD)/zshrc $(HOME)/.zshrc
	@echo "Setting up prompt theme..."
	@[ ! -f $(PWD)/local/zsh/geometry.zsh ] && ln -s $(PWD)/zsh/geometry/geometry.zsh $(PWD)/local/zsh/geometry.zsh
	@echo "Setting up syntax highlightning..."
	@[ ! -f $(PWD)/local/zsh/fast-syntax-highlighting.zsh ] && echo "source $(PWD)/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" > $(PWD)/local/zsh/fast-syntax-highlighting.zsh
	@echo "Setting up history search..."
	@[ ! -f $(PWD)/local/zsh/zsh-history-substring-search.zsh ] && ln -s $(PWD)/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh $(PWD)/local/zsh/zsh-history-substring-search.zsh
	@echo "Setting up npm completion..."
	@[ ! -f $(PWD)/local/zsh/zsh-better-npm-completion.plugin.zsh ] && ln -s $(PWD)/zsh/zsh-better-npm-completion/zsh-better-npm-completion.plugin.zsh $(PWD)/local/zsh/zsh-better-npm-completion.plugin.zsh
	@echo "Backing up the current .gitconfig..."
	@[ -f $(HOME)/.gitconfig ] && mv $(HOME)/.gitconfig $(PWD)/local/gitconfig.bak

.PHONY: install-externals
install-externals:
	@echo "Updating external libraries..."
	@git submodule update --init
