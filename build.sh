#!/bin/bash

tflag=false
nflag=false

function print_usage {
  echo -e "Usage: $0 <options>\nOptions:\n\t-h, --help\t print this help\n\t-t, --tag\t SOURCE image tag version\n\t-n, --name\t New image name\n\t-b, --build\t New image tag build"
  exit 1
}

PARSED_OPTIONS=$(getopt -n "$0" -o ht:n:b: --long "help,tag:,name:,build:" -- "$@")

[ $? -ne 0 ] && print_usage
 
[ $# -eq 0 ] && print_usage

eval set -- "$PARSED_OPTIONS"

while true
do
  case "$1" in
    -h|--help)
        print_usage
        shift;;

    -t|--tag)
        TAG_VERSION=$2; tflag=true; shift 2;;

    -n|--name)
        DOCKER_NAME=$2; nflag=true; shift 2;;

    -b|--build)
        TAG_BUILD=$2; shift 2;;

    --)
        shift
        break;;
  esac
done

if ! $tflag || ! $nflag
then
  print_usage
fi

cat Dockerfile.template | sed -e "s/TAG_VERSION/$TAG_VERSION/g" > Dockerfile

if [ ! -z ${TAG_BUILD} ]
then
  TAG_BUILD=":${TAG_BUILD}"
fi

docker build --build-arg version=${TAG_VERSION:1} -t ${DOCKER_NAME}${TAG_BUILD} .
