parser_definition_listkeys() {
    setup REST plus:true help:usage abbr:true -- \
        "Usage: ${2##*/} [options...] [arguments...]" ''
    msg -- 'List available subkeys in the keyring' ''
    disp :usage -h --help
}
