#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

DEFAULT_FILE=${DEFAULT_FILE:-"external/euler_offline/project_euler_problems.txt"}
if [ $# -eq 1 ]; then
  ACTION="${DEFAULT_ACTION}";
  PROBLEM_FILE=$DEFAULT_FILE
  PROBLEM=${1:--1};
elif [ $# -eq 2 ]; then
  PROBLEM_FILE=$DEFAULT_FILE
  ACTION=${1}; shift
  if [ ${ACTION:0:2} != "--" ]; then
    PROBLEM_FILE=$ACTION
    ACTION=--parse
  fi
  PROBLEM=${1:--1};
elif [ $# -eq 3 ]; then
  ACTION=${1:---parse}; shift
  PROBLEM=${1:--1}; shift
  PROBLEM_FILE=${1:-$DEFAULT_FILE};
else
  echo -e "\e[31mError.. \e[0m Incorrect usage"
  echo -e ${USAGE:-"No Usage provided.."}
  exit 1
fi
