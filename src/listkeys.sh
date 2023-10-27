

fn_listkeys() {
    # Set up trap to ensure settings are restored before exiting
    current_traps=$(trap)
    trap 'fn_cleanup' EXIT HUP INT TERM

    fn_read_container_password
    fn_open_container

    gpg --quiet --homedir=$MOUNT_PATH --list-keys --with-colons | grep "^sub:" \
        | awk -F: '{
            if ($4==1)
              algo="RSA4096"
            else if ($4==22)
              algo="ED25519"
            else
              algo="UNKNOWN"

            if ($12=="s")
              usage="Signing"
            else if ($12=="e")
              usage="Encryption"
            else
              usage="UNKNOWN"

            print $5,"  ",algo,"  ",usage,"  ",strftime("%F",$7)}' \
        | column --table --table-columns KEYID,ALGO,USAGE,EXPIRATION
}
