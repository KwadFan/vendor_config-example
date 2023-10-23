#!/usr/bin/env bash

#### vendor_config-example
####
#### Written by Stephan Wendel aka KwadFan <me@stephanwe.de>
#### Copyright 2023
#### https://github.com/KwadFan/vendor_config-example
####
#### This File is distributed under GPLv3
####

#### Description: This file is intended to remove klipper_mcu completly.
####              This will also stop related services.

# shellcheck enable=require-variable-braces

# Exit on errors
set -Ee

## Debug
# set -x

### MAIN
main() {

    ### Import core library
    # shellcheck source=lib/core.sh
    . scripts/lib/core.sh

    printf "Trying to uninstall klipper_mcu and the acccording service ...\n"

    ### Ask for sudo!
    ask_for_sudo

    ### Stop klipper first!
    stop_klipper

    ### Stop klipper_mcu first!
    stop_klipper_mcu

    ### Remove linux-host-mcu binary (/usr/local/bin/klipper_mcu)
    remove_linux_host_mcu

    ### Disable klipper_mcu service
    disable_linux_host_mcu_service

    ### Uninstall systemd service file
    remove_linux_host_mcu_service

    ### Restart klipper service
    restart_klipper

    ### Done message
    printf "Uninstall of linux-host-mcu done!\nGood bye...\n"

    exit 0
}


### Helper funcs

stop_klipper_mcu() {
    if systemctl is-active --quiet klipper_mcu.service ;then
        printf "Trying to stop 'klipper_mcu.service' ...\n"
        sudo systemctl stop klipper_mcu.service
    else
        printf "Klipper_mcu service seems not running, continue...\n"
    fi
}

remove_linux_host_mcu() {
    printf "Trying to uninstall linux-host-mcu ...\n"
    sudo rm -fv /usr/local/bin/klipper_mcu
}

disable_linux_host_mcu_service() {
    if [[ -f /etc/systemd/system/klipper-mcu.service ]] \
    && [[ "$(systemctl is-enabled klipper-mcu.service)" == "enabled" ]]; then
        printf "Trying to disable klipper-mcu.service ...\n"
        sudo systemctl disable klipper-mcu.service
    else
        printf "Service 'klipper-mcu.service' seems already disabled ...\n"
    fi
}

remove_linux_host_mcu_service() {
    printf "Trying to uninstall service file ...\n"
    if [[ -f /etc/systemd/system/klipper-mcu.service ]]; then
        sudo rm -fv /etc/systemd/system/klipper-mcu.service
    else
        printf "Service seems not to be already installed... Skipped!\n"
    fi
}


#### MAIN
main
