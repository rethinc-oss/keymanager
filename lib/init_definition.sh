parser_definition_init() {
    setup REST plus:true help:usage abbr:true -- \
        "Usage: ${2##*/} [options...] [arguments...]" ''
    msg -- 'Initialize a new encrypted GPG homedir and create the master key' ''
    msg -- 'Options:'
    param NAME -n --name -- "name for the master key"
    param EMAIL -e --email -- "email for the master key"
    disp :usage -h --help
}
