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

    ### Ask for sudo!
    ask_for_sudo

    ### Stop klipper first!
    stop_klipper

    ### Clean up, from previous builds
    clean_previous_builds

    case "${mcu_board}" in
        all)
            multi_mcu_build
            ;;
        *)
            single_mcu_build "${mcu_board}"
            ### Done message
            printf "Compile of %s firmware was successful...\n" "${mcu_board}"
            ;;
    esac

    ### Restart klipper service
    restart_klipper

    exit 0
}

### Helper func
single_mcu_build() {
    if [[ ! -f "${PWD}/firmware_configs/${1}/config" ]]; then
        printf "ERROR: Configuration file for %s does not exist! Exiting!\n" "${1}"
        exit 1
    fi

    printf "Trying to compile firmware for %s ...\n" "${1}"

    ### Copy config
    copy_config "${mcu_board}"

    ### build firmware
    build_firmware "${mcu_board}"

    ### copy firmware
    copy_firmware "${mcu_board}"
}

multi_mcu_build() {
    local -a mcu_boards
    echo ""$(get_firmware_configs)"

    #mapfile -t mcu_boards <<< "$(get_firmware_configs)"

}

get_firmware_file_path() {
    find ~/klipper/out -name "klipper.bin" \
        -o -name "klipper.uf2" \
        -o -name "klipper.elf.hex"
}

copy_firmware() {
    cp -v "$(get_firmware_file_path)" "${PWD}/firmware_configs/${1}/"
}

get_firmware_configs() {
    find "${PWD}"/firmware_configs -mindepth 1 -maxdepth 1 \
        -type -d -not -path "linux-mcu-host"
}

#### MAIN
main "${@}"
