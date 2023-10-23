#!/usr/bin/env bash

#### vendor_config-example
####
#### Written by Stephan Wendel aka KwadFan <me@stephanwe.de>
#### Copyright 2023
#### https://github.com/KwadFan/vendor_config-example
####
#### This File is distributed under GPLv3
####

#### Description: This file contains reusable functions
####              To use this 'library' simply import to your script

# shellcheck enable=require-variable-braces

# Exit on errors
set -Ee

## Debug
# set -x

ask_for_sudo() {
    printf "Some actions require 'sudo' permissions!\n"
    printf "Please type in your sudo password if asked!\n"
    #### workaround, sudo password will be stored during session
    sudo printf "\n"
}


## build related
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
    mcu="${1}"
    printf "Trying to copy %s config file to appropriate location ...\n" "${mcu}"
    if [[ -d "${PWD}/firmware_configs/${mcu}" ]]; then
        cp -v "${PWD}/firmware_configs/${mcu}/config" ~/klipper/.config
    else
        printf "OOOPS! Something went wrong. config is missing! Exiting ...\n"
        restart_klipper
        exit 1
    fi
}

## service related
stop_service() {
    local service
    service="${1}"
    if systemctl is-active --quiet "${service}" ;then
        printf "Trying to stop '%s' ...\n" "${service}"
        sudo systemctl stop "${service}"
    else
        printf "Service '%s' seems not running, continue...\n" "${service}"
    fi
}

restart_service() {
    local service
    service="${1}"
    if ! systemctl is-active --quiet "${service}" ;then
        printf "Trying to restart '%s' ...\n" "${service}"
        sudo systemctl start "${service}"
    fi
}

enable_service() {
    local service
    service="${1}"
    if [[ -f /etc/systemd/system/"${service}" ]] \
    || [[ -f /usr/lib/systemd/system/"${service}" ]]; then
        if [[ "$(systemctl is-enabled "${service}")" == "disabled" ]]; then
            printf "Trying to enable %s ...\n" "${service}"
            sudo systemctl enable "${service}"
        else
            printf "Service '%s' already enabled ...\n" "${service}"
        fi
    else
        printf "Service '%s' not found ... EXITING!" "${service}"
        exit 1
    fi
}

## klipper service
stop_klipper() {
    stop_service klipper.service
}

restart_klipper() {
    restart_service klipper.service
}
