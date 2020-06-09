load("@bazel_skylib//lib:unittest.bzl", "analysistest", "asserts")
load("@bazel_skylib//rules:analysis_test.bzl", "analysis_test")
load(":euler.bzl", "euler_test")

def _good_test_impl(ctx):
    env = analysistest.begin(ctx)
    actions = analysistest.target_actions(env)
    action_output = actions[-1].outputs.to_list()[0]
    asserts.equals(env, "test.log", action_output.basename)
    return analysistest.end(env)

def _bad_test_impl(ctx):
    env = analysistest.begin(ctx)

    # expect_failure is not respected.
    # This API seems relatively broken in general.
    return analysistest.end(env)

good_test = analysistest.make(_good_test_impl)
bad_test = analysistest.make(
    _bad_test_impl,
    expect_failure = True,
)

# Macro to setup the test.
def _test_good():
    # Rule under test. Be sure to tag 'manual', as this target should not be
    # built using `:all` except as a dependency of the test.
    native.genrule(
        name = "correct_problem",
        outs = ["correct.sh"],
        local = True,
        cmd =
            ("echo -e '" +
             "#!/usr/bin/env bash\n" +
             "echo 233168' > $@"),
    )
    native.sh_binary(name = "correct_problem-sh", srcs = [":correct_problem"])

    native.genrule(
        name = "wrong_problem",
        outs = ["wrong.sh"],
        local = True,
        cmd =
            ("echo -e '" +
             "#!/usr/bin/env bash\n" +
             "echo 123' > $@"),
    )
    native.sh_binary(name = "wrong_problem-sh", srcs = [":wrong_problem"])

    euler_test(name = "good_euler", problem = 1, solution = ":correct_problem-sh")

    good_test(
        name = "good_test",
        target_under_test = ":good_euler",
    )

    euler_test(name = "bad_euler", problem = 1, solution = ":wrong_problem-sh", tags = ["manual"])
    bad_test(
        name = "bad_test",
        target_under_test = ":bad_euler",
    )

    euler_test(name = "missing_euler", problem = 10000, solution = ":correct_problem-sh", tags = ["manual"])
    bad_test(
        name = "missing_test",
        target_under_test = ":missing_euler",
    )

    native.sh_test(
        name = "rules_test_validator",
        srcs = ["rules_test.sh"],
        data = [":good_euler", ":bad_euler", ":missing_euler"],
    )
    good_test(
        name = "validator",
        target_under_test = ":rules_test_validator",
    )

# Entry point from the BUILD file; macro for running each test case's macro and
# declaring a test suite that wraps them together.
def rules_test_suite(name):
    # Call all test functions and wrap their targets in a suite.
    _test_good()

    native.test_suite(
        name = name,
        tests = [
            ":good_test",
            ":bad_test",
            ":missing_test",
            ":validator",
        ],
    )
