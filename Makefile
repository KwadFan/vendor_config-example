#### vendor_config-example
####
#### Written by Stephan Wendel aka KwadFan <me@stephanwe.de>
#### Copyright 2023
#### https://github.com/KwadFan/vendor_config-example
####
#### This File is distributed under GPLv3
####

#### Self-Documenting Makefile
#### This is based on https://gellardo.github.io/blog/posts/2021-06-10-self-documenting-makefile/

.DEFAULT_GOAL := help
.PHONY: help

all: ## Builds all firmwares present in firmware_configs
	@printf "This will take a while ... Please be patient!\n"
	@bash -c 'scripts/build.sh all'

clean: ## Run clean and distclean inside klipper directory.
	@printf "Cleaning previous builds in ~/klipper ...\n"
	@bash -c 'cd ~/klipper && make clean && make distclean'

menuconfig: ## Run klipper's menuconfig.
	@bash -c 'cd ~/klipper && make menuconfig'

btt-skrmini-e3-v2: ## Compiles Firmware for BTT SKR Mini E3 V2 (USB Variant).
	@bash -c 'scripts/build.sh btt-skrmini-e3-v2'

btt-skrpico-v1.0: ## Compiles Firmware for BTT SKR pico V1.0.
	@bash -c 'scripts/build.sh btt-skrpico-v1.0'

linux-host-mcu: ## Compiles and installs new linux-host-mcu.
	@printf "This will take a while ... Please be patient!\n"
	@bash -c 'scripts/linux-host-mcu.sh'

uninstall-linux-host: ## Uninstalls linux-host-mcu (klipper_mcu) completly.
	@printf "This will take a while ... Please be patient!\n"
	@bash -c 'scripts/uninstall-linux-host.sh'

update: ## Tries to pull latest updates from repository.
	@printf "Fetch and pull from remote repository ...\n"
	@git fetch && git pull

list-serial: ## List serial devices (by-id)
	@printf "List connected serial devices (by-id) ...\n\n"
	@find /dev/serial/by-id -type l -print

help: ## Shows this help.
	@printf "vendor_config helper\n"
	@printf "Usage:\n\n"
	@grep -E '^[0-9a-zA-Z._-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
