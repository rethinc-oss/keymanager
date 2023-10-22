fn_init() {
    CALLING_USER=${SUDO_USER:-$USER}

    if [ -z "$NAME" ]; then
        redprint "Must give your name"
        exit 1;
    fi

    if [ -z "$EMAIL" ]; then
        redprint "Must give your email"
        exit 1;
    fi

    # Set up trap to ensure settings are restored before exiting
    current_traps=$(trap)
    trap 'fn_cleanup' EXIT HUP INT TERM

    # Read & cache container password
    fn_read_container_password

    # Create encrypted container, if it not exists
    if [ ! -e $CONTAINER_PATH ]; then
        greenprint "Creating encrypted container file..."
        dd if=/dev/urandom of=$CONTAINER_PATH bs=100M count=1 iflag=fullblock status=none
        chown $CALLING_USER:$CALLING_USER $CONTAINER_PATH
        echo $CONTAINER_PASSWD | cryptsetup --type=luks2 --label='GPGHOME' --pbkdf pbkdf2 --batch-mode luksFormat $CONTAINER_PATH
        echo $CONTAINER_PASSWD | cryptsetup open --type=luks2 $CONTAINER_PATH GPGHOME
        mkfs.ext2 -q /dev/mapper/GPGHOME
        sync; sleep 2
        cryptsetup close GPGHOME
    else
        greenprint "Container file exists, skipping creation..."
    fi

    greenprint "Opening encrypted container file..."
    fn_open_container

    # Create new GPG Masterkey, if it not exists
    if ! gpg --quiet --homedir=$MOUNT_PATH --list-secret-keys --with-colons | read REPLY; then
        greenprint "Generating GPG Masterkey"
        gpg --quiet --homedir=$MOUNT_PATH --quick-gen-key "${NAME} <${EMAIL}>" ed25519 cert 50y
    else
        greenprint "GPG Masterkey exists, skipping creation..."
    fi
}
