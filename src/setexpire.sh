fn_setexpire() {
    if [ -z "$KEYID" ]; then
        redprint "Must give the keyid"
        exit 1;
    fi

    # Set up trap to ensure settings are restored before exiting
    current_traps=$(trap)
    trap 'fn_cleanup' EXIT HUP INT TERM

    fn_read_container_password
    fn_open_container

    MASTER_ID=$(gpg --quiet --homedir=$MOUNT_PATH --list-keys --with-colons \
        | grep "^pub:" \
        | awk -F: '{print $5}')

    MASTER_FPR=$(gpg --quiet --homedir=$MOUNT_PATH --list-keys --with-colons \
    | grep "fpr" \
    | awk -v id=$MASTER_ID -F: '{ if ($10~id) print $10}')

    KEY_FPR=$(gpg --quiet --homedir=$MOUNT_PATH --list-keys --with-colons \
    | grep "fpr" \
    | awk -v id=$KEYID -F: '{ if ($10~id) print $10}')

    gpg --quiet --homedir=$MOUNT_PATH --quick-set-expire ${MASTER_FPR} 10y ${KEY_FPR}
}
