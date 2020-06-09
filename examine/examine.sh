#!/usr/bin/env bash
PREFIX="."
if [ $(basename `pwd`) != "euler" ]; then
  if [[ -z "$(echo `pwd` | grep bazel-out)" ]]; then
    echo "Refrain from running '@euler/stub/stub.sh' directly."
    exit 1;
  else
    PREFIX="external/euler"
  fi
fi

parse () {
  problem="$(sed -n -e "/^Problem ${PROBLEM}$/,/^Problem/ p" ${PROBLEM_FILE} | \
    head -n -1 || '')"

  if [ -z "$problem" ]; then
    echo -e "\e[33mHmmm.. \e[0m It doesn't look like this problem exists. "`
            `"If the problem does exist, please add it here: "`
            `"'https://github.com/davidcorbin/euler-offline'. Good luck :)";
    exit 1;
  fi

  echo "$problem"
}

answer () {
  solution=$(parse) || (echo $solution && exit 1)
  result=$(echo $solution | grep -oP "(?<=Answer: ).+" || "");
  if [ $(echo -n $result | wc -c) -ne 32 ]; then
    echo -e "\e[33mWoops! \e[0m Solution unknown. "`
            `"If your answer is correct, please contribute here: "`
            `"'https://github.com/davidcorbin/euler-offline'. Good luck :)";
    exit 1;
  fi
  echo "$result"
}

examine () {
  if [ "$ACTION" == "--parse" ]; then
    parse
  fi

  if [ "$ACTION" == "--answer" ]; then
    answer
  fi
}

[[ ${BASH_SOURCE[0]} == $0 ]] && {
  USAGE="Expected: @euler//examine [--parse|--answer] PROBLEM [PROBLEM_FILE]"
  DEFAULT_ACTION="--parse"
  source ${PREFIX}/common/common.sh
  examine "$@"
}
