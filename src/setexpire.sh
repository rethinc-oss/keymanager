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

    MASTER_FPR=$(fn_get_master_fpr)
    KEY_FPR=$(fn_get_key_fpr "${KEYID}")

    gpg --quiet --homedir=$MOUNT_PATH --quick-set-expire ${MASTER_FPR} 10y ${KEY_FPR}
}
