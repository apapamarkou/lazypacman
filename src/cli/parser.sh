#!/usr/bin/env bash
# CLI argument parser

# Parse and execute CLI commands
parse_cli() {
    local cmd="$1"
    shift
    
    case "$cmd" in
        install|i)
            cli_install "$@"
            ;;
        remove|r)
            cli_remove "$@"
            ;;
        search|s)
            cli_search "$@" false
            ;;
        search-names-only|sno)
            cli_search "$@" true
            ;;
        info)
            cli_info "$@"
            ;;
        update|u)
            cli_update
            ;;
        clean-orphans|co)
            cli_clean_orphans
            ;;
        help|h|--help|-h)
            show_help
            ;;
        *)
            echo "Unknown command: $cmd"
            echo "Run 'pkg help' for usage information"
            exit 1
            ;;
    esac
}
