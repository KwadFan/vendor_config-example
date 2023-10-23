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
    ### Ask for sudo!
    ask_for_sudo

    ### Stop klipper first!
    stop_klipper

    ### Clean up, from previous builds
    clean_previous_builds

    ### Copy config
    copy_config

    ### build firmware
    build_linux_mcu_fw
    install_linux_host_mcu

    ### Restart klipper service
    restart_klipper

    ### Done message
    printf "Build and Install of linux-host-mcu done!\nGood bye...\n"

    exit 0
}


### Helper funcs

ask_for_sudo() {
    printf "Some actions require 'sudo' permissions!\n"
    printf "Please type in your sudo password if asked!\n"
    #### workaround, sudo password will be stored during session
    sudo printf "\n"
}

clean_previous_builds() {
    if [[ -d ~/klipper ]]; then
        pushd ~/klipper &> /dev/null
        printf "Clean up previous builds ...\n"
        make clean
        make distclean
        popd &> /dev/null
    else
        printf "OOOPS! Something went wrong. Klipper seems not to be installed! Exiting ..."
        restart_klipper
        exit 1
    fi
}

copy_config() {
    printf "Trying to copy linux-host-mcu config file to appropriate location ...\n"
    if [[ -d "${PWD}/firmware_configs/linux-host-mcu" ]]; then
        cp -v "${PWD}/firmware_configs/linux-host-mcu/config" ~/klipper/.config
    else
        printf "OOOPS! Something went wrong. config is missing! Exiting ...\n"
        restart_klipper
        exit 1
    fi
}

stop_klipper() {
    if systemctl is-active --quiet klipper.service ;then
        printf "Trying to stop 'klipper.service' ...\n"
        sudo systemctl stop klipper.service
    else
        printf "Klipper service seems not running, continue...\n"
    fi
}

restart_klipper() {
    if ! systemctl is-active --quiet klipper.service ;then
        printf "Trying to restart 'klipper.service' ...\n"
        sudo systemctl start klipper.service
    fi
}

build_linux_mcu_fw() {
    local cpu_count
    cpu_count="$(nproc)"
    printf "Trying to build linux-host-mcu with %d cpu cores ...\n" "${cpu_count}"
    pushd ~/klipper &> /dev/null
    make -j"${cpu_count}"
    popd &> /dev/null
}

install_linux_host_mcu() {
    printf "Trying to build linux-host-mcu with %d cpu cores ...\n" "${cpu_count}"
    pushd ~/klipper &> /dev/null
    make -j"${cpu_count}"
    popd &> /dev/null
}

#### MAIN
main
