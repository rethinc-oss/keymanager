parser_definition_setexpire() {
    setup REST plus:true help:usage abbr:true -- \
        "Usage: ${2##*/} [options...] [arguments...]" ''
    msg -- 'Set the expiration date for the given subkey' ''
    msg -- 'Options:'
    param KEYID -k --keyid -- "the keyid to set the expiration for"
    param KEYEXPIRE -e --expire -- "the expire expression for the key"
    disp :usage -h --help
}
