#!/usr/bin/env bash

{DEBUG}
set -o errexit
set -o nounset
set -o pipefail

main() {
  local output
  local runner
  local parser
  local root

  runner="{SOLUTION}"
  parser="{PARSER}"
  root="{ROOT}/"

  if [ ! -f $runner ]; then
    runner=${runner#${root}}
  fi

  if [ ! -f $parser ]; then
    parser=${parser#${root}}
  fi

  solution="$($parser --answer {PROBLEM} {PROBLEM_FILE})" || (echo $solution && exit 1)

  export HELLO="HELLO!"

  set +o errexit
  output="$($runner {CUSTOM_ARGS})"
  attempt="$( echo -n $output | md5sum - | awk '{ print $1 }')"
  if [ "$solution" == "$attempt" ]; then
    echo -e "\e[32mSuccess!\e[0m Matching hash was $attempt ($output)"
    exit 0;
  fi
  status=$?
  set -o errexit

  echo -e "\e[31mFailure...\e[0m "`
          `"Correct hash was $solution, "`
          `"attempt yielded $attempt ($output)";
  exit 1
}

[[ $_ != $0 ]] &&  main "$@"
