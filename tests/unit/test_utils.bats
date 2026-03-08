#!/usr/bin/env bats

load '../helpers/test_utils'
load '../helpers/mock_commands'

setup() {
    setup_test_env
    MODULE_DIR="$BATS_TEST_DIRNAME/../../src"
    source "$MODULE_DIR/core/loader.sh"
    require core/colors
    require core/utils
}

@test "is_installed returns true for installed package" {
    pacman() { [[ "$2" == "vim" ]] && return 0 || return 1; }
    export -f pacman
    
    run is_installed "vim"
    assert_success
}

@test "is_installed returns false for not installed package" {
    pacman() { return 1; }
    export -f pacman
    
    run is_installed "nonexistent"
    assert_failure
}

@test "get_package_source returns repo for repo package" {
    pacman() { [[ "$1" == "-Si" ]] && return 0; }
    export -f pacman
    
    run get_package_source "vim"
    assert_success
    [ "$output" = "repo" ]
}

@test "get_package_source returns aur for AUR package" {
    pacman() { return 1; }
    export -f pacman
    
    run get_package_source "yay"
    assert_success
    [ "$output" = "aur" ]
}

@test "format_package_line shows installed marker for installed package" {
    run format_package_line "vim" "repo" "1"
    assert_success
    assert_contains "$output" "[I]"
    assert_contains "$output" "vim"
}

@test "format_package_line shows not installed marker" {
    run format_package_line "vim" "repo" "0"
    assert_success
    assert_contains "$output" "[_]"
    assert_contains "$output" "vim"
}

@test "format_package_line shows repo label" {
    run format_package_line "vim" "repo" "0"
    assert_success
    assert_contains "$output" "[Rep]"
}

@test "format_package_line shows AUR label" {
    run format_package_line "yay" "aur" "0"
    assert_success
    assert_contains "$output" "[AUR]"
}
