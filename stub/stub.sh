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

tmp_py () {
  echo "#!/usr/bin/env python"
  echo -e '""" Project Euler'
  parse
  echo '"""'
  echo -e "\n"
  echo "def main():"
  echo "  pass"
  echo -e "\n"
  echo 'if __name__ == "__main__":'
  echo "  print(main())"
}

tmp_hs () {
  echo -e '{- Project Euler'
  parse
  echo '-}'
  echo -e "\n"
  echo "main :: IO ()"
  echo 'main = undefined'
}

stub () {
  if [ $ACTION == "--python" ]; then
    tmp_py
  fi

  if [ $ACTION == "--haskell" ]; then
    tmp_hs
  fi
}

[[ ${BASH_SOURCE[0]} == $0 ]] && {
  DEFAULT_ACTION="--python"
  USAGE="Expected: @euler//stub [--python|--haskell] PROBLEM [PROBLEM_FILE]"
  source ${PREFIX}/examine/examine
  source ${PREFIX}/common/common.sh
  stub "$@"
}
