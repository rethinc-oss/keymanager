fn_init() {
    echo "PARAM: $NAME"
    echo "PARAM: $EMAIL"

    redprint "TEST"

    i=0
    while [ $# -gt 0 ] && i=$((i + 1)); do
        echo "$i: $1"
        shift
    done
}
