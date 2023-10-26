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

### MAIN
main() {

    ### import core library
    # shellcheck source=lib/core.sh
    . scripts/lib/core.sh

    printf "Trying to install klipper_mcu and the acccording service ...\n"

    ### Ask for sudo!
    ask_for_sudo

    ### Stop klipper first!
    stop_klipper

    ### Clean up, from previous builds
    clean_previous_builds

    ### Copy config
    copy_config "linux-host-mcu"

    ### build firmware
    build_firmware "linux-host-mcu"

    ### Install linux-host-mcu binary (/usr/local/bin/klipper_mcu)
    install_linux_host_mcu

    ### Install systemd service file
    install_linux_host_mcu_service

    ### Enable klipper_mcu service
    enable_service klipper-mcu.service

    ### Restart klipper service
    restart_klipper

    ### Done message
    printf "Build and Install of linux-host-mcu done!\nGood bye...\n"

    exit 0
}


### Helper funcs
install_linux_host_mcu() {
    printf "Trying to install linux-host-mcu ...\n"
    pushd ~/klipper &> /dev/null
    make flash
    popd &> /dev/null
}

install_linux_host_mcu_service() {
    printf "Trying to install service file ...\n"
    if [[ -f /etc/systemd/system/klipper-mcu.service ]]; then
        printf "Service seems to be already installed... Skipped!\n"
    else
        pushd ~/klipper &> /dev/null
        sudo cp -v ./scripts/klipper-mcu.service /etc/systemd/system/
        popd &> /dev/null
    fi
}

#### MAIN
main
