#!/usr/bin/env bash

set -eo pipefail

function echoerr {
    >&2 echo "$@"
}

_usage="Usage: $0 [--img <IMG_NAME>] [-pull] [--out <OUT_DIR>] [--target <BACKEND>] [--arch <ARCH>] [--std <VERSION>] <P4 source>

        --img              Docker image to use (default: antoninbas/p4c-lite)
        --pull             Pull latest version of provided Docker image
        --out, -o          Output directory for compilation artifacts (default is to create a temporary directory)
        --target, -b       P4c backend to use (default: bmv2)
        --arch, -a         P4 architecture (default: v1model)
        --std              P4 language version (default: p4_16)
        --help, -h         Print this message and exit

This script will mount the directory of the provided P4 source file to the
Docker container. If the source file includes some other files which are not
part of the same directory or if it includes some other files using their
absolute path, the build will fail."

function print_usage {
    echoerr "$_usage"
}

function print_help {
    echoerr "Try '$0 --help' for more information."
}

P4_SRC=""
IMG_NAME="antoninbas/p4c-lite"
DO_IMG_PULL=false
OUT_DIR=$(mktemp -d -t p4c-out-XXXXXXXXXX)
P4C_BACKEND="bmv2"
P4C_ARCH="v1model"
P4C_STD="p4_16"

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --img)
    IMG_NAME="$2"
    shift 2
    ;;
    --pull)
    DO_IMG_PULL=true
    shift
    ;;
    -o|--out)
    OUT_DIR="$2"
    shift 2
    ;;
    -b|--target)
    P4C_BACKEND="$2"
    shift 2
    ;;
    -a|--arch)
    P4C_ARCH="$2"
    shift 2
    ;;
    --std)
    P4C_STD="$2"
    shift 2
    ;;
    -h|--help)
    print_usage
    exit 0
    ;;
    *)
    P4_SRC="$key"
    shift
    ;;
esac
done

if [ -z "$P4_SRC" ]; then
    echoerr "No P4 source file was provided"
    print_help
    exit 1
fi

if ! [ -f "$P4_SRC" ]; then
    echoerr "'$P4_SRC' is not a valid file"
    print_help
    exit 1
fi

if "$DO_IMG_PULL"; then
    echoerr "Pulling latest '$IMG_NAME' image"
    docker pull "$IMG_NAME" > /dev/null
fi

echoerr "Compiling '$P4_SRC' and placing output under '$OUT_DIR'"

P4_SRC_DIR="$(cd "$(dirname "$P4_SRC")"; pwd -P)"

P4C_ARGS="-b $P4C_BACKEND -a $P4C_ARCH --std $P4C_STD --p4runtime-files /out/p4info.pb.txt -o /out"

docker run --rm -u "$(id -u):$(id -g)" \
       -v "$P4_SRC_DIR:/in" \
       -v "$OUT_DIR:/out" \
       -w /in \
       "$IMG_NAME" p4c $P4C_ARGS $(basename "$P4_SRC")
