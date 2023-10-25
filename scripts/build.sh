#!/usr/bin/env bash

#### vendor_config-example
####
#### Written by Stephan Wendel aka KwadFan <me@stephanwe.de>
#### Copyright 2023
#### https://github.com/KwadFan/vendor_config-example
####
#### This File is distributed under GPLv3
####

#### Description: This file is used to compile firmware and
####              copying to its appropriate folder
####              This will also stop/restart klipper
####              The script expects one argument in form
####              of the config folder name, e.g.
####              build.sh btt-skrpico-v1.0
####              For ease of use add in Makefile! See Makefile for Details.

# shellcheck enable=require-variable-braces

# Exit on errors
set -Ee

## Debug
# set -x

### MAIN
main() {
    local mcu_board title
    mcu_board="${1}"
    title="Ahoi! Firmware Build Helper of ${PWD#/*config/} ..."
    ### import core library
    # shellcheck source=lib/core.sh
    . scripts/lib/core.sh

    printf "%s\n" "${title}"

    if [[ $# -eq 0 ]]; then
        printf "ERROR: Too few arguments! Exiting!\n"
        printf "Please provide a mcu config name! Exiting!\n"
        exit 1
    fi

    if [[ $# -gt 1 ]]; then
        printf "ERROR: Too many arguments! Exiting!\n"
        exit 1
    fi

    if [[ ! -f "${PWD}/firmware_configs/${mcu_board}/config" ]]; then
        printf "ERROR: Configuration file for %s does not exist! Exiting!\n" "${mcu_board}"
        exit 1
    fi

    printf "Trying to compile firmware for %s ...\n" "${mcu_board}"

    ### Ask for sudo!
    ask_for_sudo

    ### Stop klipper first!
    stop_klipper

    ### Clean up, from previous builds
    clean_previous_builds

    ### Copy config
    copy_config "${mcu_board}"

    ### build firmware
    build_firmware "${mcu_board}"

    ### copy firmware
    copy_firmware "${mcu_board}"

    ### Restart klipper service
    restart_klipper

    # ### Done message
    printf "Compile of %s firmware was successful...\n" "${mcu_board}"

    exit 0
}
### Helper func
get_firmware_file_path() {
    find ~/klipper/out -name "*.bin" -o -name "*.uf2" -o -name "*.elf.hex"
}

copy_firmware() {
    cp -v "$(get_firmware_file_path)" "${PWD}/firmware_configs/${1}/"
}

#### MAIN
main "${@}"
