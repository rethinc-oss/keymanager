fn_exportkey() {
    CALLING_USER=${SUDO_USER:-$USER}

    if [ -z "$KEYID" ]; then
        redprint "Must give the keyid"
        exit 1;
    fi

    # Set up trap to ensure settings are restored before exiting
    current_traps=$(trap)
    trap 'fn_cleanup' EXIT HUP INT TERM

    fn_read_container_password
    fn_open_container

    KEY_FPR=$(fn_get_key_fpr "${KEYID}")

    mkdir -p /tmp/gpghome-temp
    chmod 700 /tmp/gpghome-temp
    TEMPOPERATION=1
    gpg --homedir=$MOUNT_PATH --armor --export ${KEY_FPR}!  > /tmp/gpghome-temp/${KEYID}.pub.asc
    gpg --homedir=$MOUNT_PATH --armor --export-secret-subkeys ${KEY_FPR}!  > /tmp/gpghome-temp/${KEYID}.asc
    gpg --homedir=/tmp/gpghome-temp --import /tmp/gpghome-temp/${KEYID}.pub.asc
    gpg --homedir=/tmp/gpghome-temp --import /tmp/gpghome-temp/${KEYID}.asc
    gpg --homedir=/tmp/gpghome-temp --passwd ${KEYID}!
    gpg --homedir=/tmp/gpghome-temp --armor --export ${KEY_FPR}!  > ./${KEYID}.pub.asc
    gpg --homedir=/tmp/gpghome-temp --armor --export-secret-subkeys ${KEY_FPR}!  > ./${KEYID}.asc
    chown $CALLING_USER:$CALLING_USER ./${KEYID}*.asc
}
