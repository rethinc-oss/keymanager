# https://stackoverflow.com/a/28393320
read_secret()
{
    # Save settings and disable echo.
    current_tty="$(stty -g)"
    stty -echo

    # Read secret.
    read "$@"

    # Restore settings.
    stty "$current_tty"
    unset current_tty

    # Print a newline because the newline entered by the user after
    # entering the passcode is not echoed. This ensures that the
    # next line of output begins at a new line.
    echo
}

fn_cleanup() {
    yellowprint "Cleaning up:"
    if [ "${current_tty+1}" ]; then
        yellowprint "Restoring tty settings..."
        stty "$current_tty"
        unset current_tty
    fi

    if [ "${TEMPOPERATION+1}" ]; then
        yellowprint "Cleaning up temporary files..."
        gpgconf --homedir /tmp/gpghome-temp --kill gpg-agent; sleep 3
        rm -rf /tmp/gpghome-temp/
        unset TEMPOPERATION
    fi

    yellowprint "Stopping GPG-Agent..."
    gpgconf --homedir ${MOUNT_PATH} --kill gpg-agent; sleep 3

    if mount | grep -q "$MOUNT_PATH"; then
      yellowprint "Unmounting GPGHOME..."
      umount $MOUNT_PATH && rm -rf $MOUNT_PATH
    fi

    if [ -e /dev/mapper/GPGHOME ]; then
        yellowprint "Closing LUKS container..."
        cryptsetup close GPGHOME
    fi
}

fn_read_container_password() {
    if [ ! "${CONTAINER_PASSWD+1}" ]; then
        # Cache container password
        printf "Password for container: "
        read_secret CONTAINER_PASSWD
    fi
}

fn_open_container() {
    if cryptsetup isLuks $CONTAINER_PATH; then
        echo $CONTAINER_PASSWD | cryptsetup open --type=luks2 $CONTAINER_PATH GPGHOME
        mkdir -p $MOUNT_PATH
        mount -t ext2 /dev/mapper/GPGHOME /$MOUNT_PATH
        chmod 700 $MOUNT_PATH
    else
        redprint "The file is not a valid LUKS container."
        exit 1
    fi
}
