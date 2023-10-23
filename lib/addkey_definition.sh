parser_definition_addkey() {
    setup REST plus:true help:usage abbr:true -- \
        "Usage: ${2##*/} [options...] [arguments...]" ''
    msg -- 'Add a new subkey to the keyring' ''
    msg -- 'Options:'
    param ALGO -a --algorithm pattern:"rsa4096 | ed25519" -- "algorithm of the subkey"
    param USAGE -u --usage pattern:"sign | encrypt" -- "type of the subkey"
    disp :usage -h --help
}
