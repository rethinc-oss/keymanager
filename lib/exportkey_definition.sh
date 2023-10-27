parser_definition_exportkey() {
    setup REST plus:true help:usage abbr:true -- \
        "Usage: ${2##*/} [options...] [arguments...]" ''
    msg -- 'Export public and private components of a subkey' ''
    msg -- 'Options:'
    param KEYID -k --keyid -- "the keyid for the subkey to export"
    disp :usage -h --help
}
