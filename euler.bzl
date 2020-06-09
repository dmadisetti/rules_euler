"""Rules to load all dependencies of this project."""

load(
    "@bazel_tools//tools/build_defs/repo:http.bzl",
    "http_archive",
)

def euler_repositories():
    # Potentially a bug when the consuming workspace is also called euler.
    # Should check for that here.
    excludes = native.existing_rules().keys()

    euler_offline_version = "339f0131e2bb2bccb55a0b403616a3b12c845be5"
    sha = "5fabcaef38f05749bffa59583f429acf9fcd094cf4938e7f1ca51dbfcc55d048"
    if "euler_offline" not in excludes:
        http_archive(
            name = "euler_offline",
            strip_prefix = "euler-offline-" + euler_offline_version,
            urls = ["https://github.com/davidcorbin/euler-offline/archive/" + euler_offline_version + ".tar.gz"],
            build_file = "@euler//third_party:euler_offline.BUILD",
            sha256 = sha,
        )

def _euler_rule_impl(ctx):
    # All tests should have outputs.
    if hasattr(ctx, "outputs"):
        exe = ctx.outputs.executable
    else:
        exe = ctx.actions.declare_file(
            "euler_runner_%d" % ctx.attr.name,
        )

    ctx.actions.expand_template(
        template = ctx.file._template,
        output = exe,
        substitutions = {
            "{DEBUG}": "set -x" if ctx.attr.dev_debug else "",
            "{SOLUTION}": ctx.executable.solution.path,
            "{PARSER}": ctx.executable._parse_tool.path,
            "{ROOT}": ctx.executable.solution.root.path,
            "{PROBLEM}": "%d" % ctx.attr.problem,
            "{PROBLEM_FILE}": ctx.file._problems.path,
            "{CUSTOM_ARGS}": ctx.attr.parameters,
        },
        is_executable = True,
    )

    runfiles = ctx.runfiles(
        files = ctx.attr.solution.default_runfiles.files.to_list() +
                ctx.attr._common.files.to_list() +
                [ctx.file._problems, ctx.executable.solution, ctx.executable._parse_tool],
    )
    return DefaultInfo(executable = exe, runfiles = runfiles)

euler_test = rule(
    implementation = _euler_rule_impl,
    test = True,
    attrs = {
        "problem": attr.int(doc = "The Project Euler problem number.", mandatory = True),
        "solution": attr.label(doc = "Executable dependency to run.", mandatory = True, executable = True, cfg = "target"),
        "parameters": attr.string(doc = "Parameters to pass to the executable."),
        "_common": attr.label(
            default = Label("//common"),
            cfg = "target",
        ),
        "_parse_tool": attr.label(
            default = Label("//examine"),
            executable = True,
            cfg = "target",
        ),
        "_problems": attr.label(
            default = Label("@euler_offline//:project_euler_problems.txt"),
            allow_single_file = True,
        ),
        "_template": attr.label(
            default = Label("//templates:euler.sh.tpl"),
            allow_single_file = True,
        ),
        "dev_debug": attr.bool(
            doc = "For dev use only. Helps debug issue with running script runner.",
        ),
    },
)
