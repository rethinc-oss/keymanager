# shellcheck disable=SC1083
parser_definition() {
    setup REST help:usage abbr:true -- \
        "Usage: ${2##*/} [command] [options...] [arguments...]"
    msg -- '' 'Options:'
    disp :usage -h --help
    disp VERSION --version

    msg -- '' 'Commands: '
    msg -- 'Use command -h for a command help.'
    cmd init -- "Initialize a new encrypted GPG homedir and create the master key."
    cmd addkey -- "Add a new subkey to the keyring."

    msg -- '' "Examples:
    
    init 
    $SCRIPT_NAME init --name 'Max Muster' --email 'm.muster@example.com'
    Display the version:
    $SCRIPT_NAME --version
    Display help:
    $SCRIPT_NAME -h | --help
"
}
