#!/usr/bin/env bash

PREFIX="."
SUFFIX=""

if [ -d bazel-testlogs ]; then
  PREFIX="cat bazel-testlogs/"
  SUFFIX="/test.log"
fi

failed () {
  echo "Failed..."
  echo "${1}"
  exit 1
}
passed () {
  echo "Success!"
}

fail="failed || exit 1"

dofind () {
  ${PREFIX}/${1}${SUFFIX} | grep ${2} > /dev/null || \
    failed "Could not find ${1} for ${2}" && passed
}

dontfind () {
  ${PREFIX}/${1}${SUFFIX} | grep ${2} && \
    failed "Found ${2} in ${1}" || passed
}

dofind good_euler Success
dontfind good_euler Failure
dontfind good_euler "Hmmm.."

dofind bad_euler Failure
dontfind bad_euler Success
dontfind bad_euler "Hmmm.."

dofind missing_euler "Hmmm.."
dontfind missing_euler Failure
dontfind missing_euler Success
