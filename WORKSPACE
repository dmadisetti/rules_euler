workspace(name = "euler")

# Load the repository rule to download an http archive.
load(
    "@bazel_tools//tools/build_defs/repo:http.bzl",
    "http_archive",
)

http_archive(
    name = "bazel_skylib",
    strip_prefix = "bazel-skylib-560d7b2359aecb066d81041cb532b82d7354561b",
    urls = ["https://github.com/bazelbuild/bazel-skylib/archive/560d7b2359aecb066d81041cb532b82d7354561b.tar.gz"],
    sha256 = "0cf18d7ba964b6a4ef4b21d471e3541cd22f7594512d172274d86647a87a2ffe",
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

load("//:euler.bzl", "euler_repositories", "euler_test")

euler_repositories()
