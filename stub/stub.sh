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

tmp_test () {
  echo "euler_test(
    name = \"${NAME}_test\",
    problem = $PROBLEM,
    solution = \":$NAME\",
)"
}

tmp_py () {
  P=$(parse) || (echo $P && exit 1)
  echo -n "#!/usr/bin/env python
\"\"\" Project Euler
$P
\"\"\"


def main():
    pass


if __name__ == \"__main__\":
    print(main())"
}

tmp_build_py () {
  echo "
py_binary(
    name = \"$NAME\",
    srcs = [\"$NAME.py\"],
)

$(tmp_test)"
}

tmp_hs () {
  P=$(parse) || (echo $P && exit 1)
  echo -n "{- Project Euler
$P
-}


main :: IO ()
main = undefined"
}

tmp_build_hs () {
  echo "
haskell_binary(
    name = \"$NAME\",
    srcs = [\"$NAME.hs\"],
    deps = [:base],
)

$(tmp_test)"
}

stub () {
  if [ $ACTION == "--python" ]; then
    if [[ $BUILD -eq 1 ]]; then
      tmp_build_py
    else
      tmp_py
    fi
  fi

  if [ $ACTION == "--haskell" ]; then
    if [[ $BUILD -eq 1 ]]; then
      tmp_build_hs
    else
      tmp_hs
    fi
  fi
}

[[ ${BASH_SOURCE[0]} == $0 ]] && {
  DEFAULT_ACTION="--python"
  USAGE="Expected: @euler//stub [b name]? [--python|--haskell] PROBLEM [PROBLEM_FILE]"
  BUILD=0
  if [[ "$1" == "b" ]]; then
    shift;
    NAME=$1; shift
    BUILD=1
  fi
  source ${PREFIX}/examine/examine
  source ${PREFIX}/common/common.sh
  stub "$@"
}
