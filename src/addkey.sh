

fn_addkey() {
    if [ -z "$ALGO" ]; then
        redprint "Must give the algo"
        exit 1;
    else
        if [ "$ALGO" = "rsa4096" ]; then
            KEY_ALGO=1
        else
            KEY_ALGO=22
        fi
    fi

    if [ -z "$USAGE" ]; then
        redprint "Must give the usage"
        exit 1;
    else
        if [ "$USAGE" = "sign" ]; then
            KEY_USAGE="s"
        else
            KEY_USAGE="e"
        fi
    fi

    # Set up trap to ensure settings are restored before exiting
    current_traps=$(trap)
    trap 'fn_cleanup' EXIT HUP INT TERM

    fn_read_container_password
    fn_open_container

    KEY_PRESENT=$(gpg --quiet --homedir=$MOUNT_PATH --list-keys --with-colons \
      | grep "sub" \
      | awk -v algo=$KEY_ALGO  -v usage=$KEY_USAGE -F: '{if ($4==algo && $12~usage) print "FOUND"}')

    if [ "$KEY_PRESENT" = "FOUND" ]; then
       yellowprint 'Key already present in keyring, skipping...'; exit 1
    else
        MASTER_FPR=$(fn_get_master_fpr)
        gpg --quiet --homedir=$MOUNT_PATH --quick-add-key $MASTER_FPR $ALGO $USAGE 3y
    fi
}
