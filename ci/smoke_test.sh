#!/usr/bin/env bash

set -eo pipefail

function echoerr {
    >&2 echo "$@"
}

function print_usage {
    echoerr "Usage: $0 [--img <IMG_NAME>]"
}

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

P4C_IMG=antoninbas/p4c-lite
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --img)
    P4C_IMG=$2
    shift 2
    ;;
    -h|--help)
    print_usage
    exit 0
    ;;
    *)    # unknown option
    echoerr "Unknown option $1"
    exit 1
    ;;
esac
done

tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
trap "rm -rf $tmp_dir" EXIT

TEST_PROG="loopback_v1model.p4"

cp $THIS_DIR/p4src/$TEST_PROG $tmp_dir

echoerr "Testing p4test"
docker run --rm -v $tmp_dir:/p4src -t antoninbas/p4c-lite p4test /p4src/$TEST_PROG
echoerr "Testing p4c-bm2-ss"
docker run --rm -v $tmp_dir:/p4src -t antoninbas/p4c-lite p4c-bm2-ss /p4src/$TEST_PROG
echoerr "Testing p4c"
docker run --rm -v $tmp_dir:/p4src -t antoninbas/p4c-lite p4c /p4src/$TEST_PROG
echoerr "Testing p4c-lite.sh"
$THIS_DIR/../p4c-lite.sh $tmp_dir/$TEST_PROG
