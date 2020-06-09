# euler_rules :abacus:
[![CI Status](https://github.com/dmadisetti/euler_rules/workflows/bazel-test/badge.svg)](https://github.com/dmadisetti/euler_rules)

## About

`euler_rules` is a Bazel library for quickly iterating one's way through
Project Euler problems. Using a [repository of verified
answers](https://github.com/davidcorbin/euler-offline), you can test, run, and
verify your problems. It should just work out of the box:


We also provide some nice helpers to make development even easier. Want to see
this code in use? Check out my [haskell Project Euler
repository](https://github.com/dmadisetti/painfulhaskell).

## Commerical Use
Commercial use is not allowed, as Project Euler questions are licensed under
[Non-Commercial Creative Commons](https://projecteuler.net/copyright), which
come from our data source dependency
[euler-offline](https://github.com/davidcorbin/euler-offline) by David Corbin.

## Usage

This project exposes the `euler_test` rule, which will compare your code
against known answers. The easiest way to get started is by including the
following in your `WORKSPACE` file:

```starlark
http_archive(
    name = "euler",
    strip_prefix = "euler-1.0",
    urls = ["https://github.com/dmadisetti/euler_rules/archive/v1.0.tar.gz"],
)

load("@euler//:euler.bzl", "euler_repositories", "euler_test")

euler_repositories()
```

To test one of your solutions, put the following in your `BUILD` file:

```starlark
load(
    "@euler//:euler.bzl",
    "euler_test",
)

py_binary(
    name = "my_brilliant_python_solution_for_7",
    srcs = ["my_brilliant_python_solution_for_7.py"], # This is your code!
)

euler_test(
    name = "euler_7_test", # A name for you to keep track of the problem attempt.
    problem = 7, # The problem number you're solving. in this case we're doing 7
    solution = ":my_brilliant_python_solution_for_7", # It doesn't have to be a python solution, it just needs to be executable.
)
```

Now when you run `bazel test :euler_7_test`, you can determine whether you got the correct answer or not.

The best way to wrap your head around this might be by heading over to the
[example
directory](https://github.com/dmadisetti/euler_rules/tree/master/examples). In
addition to python, there are haskell examples.

## Scripts

A few helper scripts are provided. `bazel run @euler/examine <problem>` Will
show you the text for a given problem. `bazel run @euler/stub --haskell
<problem>` will create a commented code stub for your use. The best way to
use this is with redirection, e.g. `bazel run @euler/stub --python 137 > problem_137.py`.
