#!/usr/bin/env bash

#### vendor_config-example
####
#### Written by Stephan Wendel aka KwadFan <me@stephanwe.de>
#### Copyright 2023
#### https://github.com/KwadFan/vendor_config-example
####
#### This File is distributed under GPLv3
####

#### Description: This file is used to compile linux-host-mcu firmware and
####              installing the service if not done yet
####              This will also restart klipper if needed

# shellcheck enable=require-variable-braces

# Exit on errors
set -Ee

## Debug
# set -x

### Ask for sudo!
printf "Some actions require 'sudo' permissions!\n"
printf "Please type in your sudo password if asked!\n"
#### workaround, sudo password will be stored during session
sudo printf "\n"

### Stop klipper first!
if systemctl is-active klipper.service ;then
    printf "Trying to stop 'klipper.service' ...\n"
    sudo systemctl stop klipper.service
else
    printf "Klipper service seems not running, continue...\n"
fi
### Clean up, from previous builds

### build firmware

printf "Hellloooo foo!\n"

exit 0
