# Makego

[![License](https://img.shields.io/github/license/bufbuild/makego?color=blue)](https://github.com/bufbuild/makego/blob/main/LICENSE)
[![Release](https://img.shields.io/github/v/release/bufbuild/makego?include_prereleases)](https://github.com/bufbuild/makego/releases)
[![CI](https://github.com/bufbuild/makego/workflows/ci/badge.svg)](https://github.com/bufbuild/makego/actions?workflow=ci)
[![Coverage](https://img.shields.io/codecov/c/github/bufbuild/makego/main)](https://codecov.io/gh/bufbuild/makego)

Makego is our Makefile setup for our Golang projects. This repository also functions as a template
repository for our Golang projects that use makego.

Makego supports our development workflow, which includes Golang, Docker, and Protobuf primarily. All
projects should result in `make` working out of the box, as long as the system has Golang >=1.13
installed, and Docker installed if Docker is used. All other dependences (except for a few that we
need to document that most systems will have, such as `bash`, `curl`, and `git`) are installed by makego
automatically and cached on a per-project basis, including all Golang module downloads.

Makego allows updating from this main (or your forked main) automatically, only copying the files
you need.

## Notice

Makego is primarily OSS as we use it in our OSS projects. Makego will likely have many breaking
changes, and **we do not provide support for it in any form**. You're obviously welcome
to fork it and/or use components of it, however - the `MAKEGO_REMOTE` variable controls the remote location
for `make updatemakego` and `make copytomakego`.

If you do use this, you should get familiar with the actual Makefiles contained in this project.

## Status

Very alpha. This will change a bunch. The documentation is incomplete as well.

## Example

[Buf](https://github.com/bufbuild/buf) uses this, and should be treated as the gold-standard example
for makego usage.

## Layout

The following are controlled by makego, and should not be edited directly:

- [make/go](make/go) - This is the "actual" makego library. This contains the Makefiles and scripts
  that compromise makego's functionality.
- [.codecov.yml](codecov.yml) - The autogenerated [Codecov](https://codecov.io) configuration. If
  you do not include [make/go/codecov.mk](make/go/codecov.mk), you should delete this file for your
  new Golang project.
- [.dockerignore](.dockerignore) - The autogenerated [Docker](https://www.docker.com) ignore
  file. If you do not include [make/go/docker.mk](make/go/docker.mk), you should delete this file
  for your new Golang project.
- [.gitignore](.gitignore) The autogenerated git ignore file.
- [go.mod](go.mod), [go.sum](go.sum) - The Golang module files. These are autogenerated.

Additionally, makego expects the following if Docker is used:

- [Dockerfile.workspace](Dockerfile.workspace) the Dockerfile for development of your Golang
  repository. If you include [make/go/docker.mk](make/go/docker.mk), this file should be present.

Otherwise, you're free to choose your own layout, however you should generally do the following:

- Have a file `make/PROJECT/all.mk` such as [make/foo/all.mk](make/foo/all.mk) that defines the
  setup for your project. This should be the only file included in your [Makefile](Makefile).
- Put your main packages in [cmd](cmd). For example, for a binary named `foo`, you should have
  [cmd/foo](cmd/foo), and add `cmd/foo` to `GO_BINS` such as in [make/foo/all.mk](make/foo/all.mk).
- If using Docker, put a Dockerfile per main package as [Dockerfile.foo](Dockerfile.foo).
  Then add `foo` to `DOCKER_BINS` such as in [make/foo/all.mk](make/foo/all.mk).
- Put your Protobuf files in [proto](proto), where `proto` is the root. Then set `PROTO_PATH` to
  `proto`, such as in [make/foo/all.mk](make/foo/all.mk).
- Put generated files in any subdirectory named `gen`. Makego treats `gen` directories as special,
  primarily by not linting them or using them for code coverage.

Other files of relevance:

- [.github](.github) - This is for GitHub Actions primarily, there is an example action at
  [.github/workflows/ci.yaml](.github/workflows/ci.yaml).
- [.envrc](.envrc) - This is for [direnv](https://direnv.net), which makego supports. This
  generally should not be edited, however.
- [LICENSE](LICENSE) - Our license. Replace with your own license.
- [Makefile](Makefile) - The main Makefile. See below for setup.
- [README.md](README.md) - This readme.
- `.env` - This directory contains your individual environment, if you want. You can back this
  up to with `make envbackup` and restore with `make envrestore`. The special file `.env/env.sh`
  will be included with `make direnv`, which direnv calls via [.envrc](.envrc).
- `.tmp` - This directory is used for temporary files such as coverage files and makego temporary
  clones.

## New Project Setup

Assuming your actual remote is `github.com/eng/hello`:

```bash
git clone https://github.com/bufbuild/makego hello
cd ./hello
rm -rf .git
git init
git remote add origin https://github.com/eng/hello
```

Move `make/foo` to `make/PROJECT`:

```bash
mv make/foo make/hello
```

Then edit the [Makefile](Makefile):

```make
# You can put make/go somewhere else if you want but we would not recommend it, however it
# should work as all Makefile in make/go use this variable to know where things are
MAKEGO := make/go
# Change to your fork. Do not use ours.
MAKEGO_REMOTE := https://github.com/eng/makego.git
# Your project name
PROJECT := hello
# The Golang module
GO_MODULE := github.com/eng/makego
# The Docker organization. Optimally this is your Docker Hub organization, but makego
# does not currently interact with Docker Hub.
DOCKER_ORG := eng
# The Docker project name, generally the same as PROJECT. The Docker image
# $(DOCKER_ORG)/$(DOCKER_PROJECT)-workspace will be created.
DOCKER_PROJECT := hello

# This changes from make/foo/all.mk to make/hello/all.mk
include make/hello/all.mk
```


Update everything and make sure everything builds:

```bash
# This also calls make generate and make all
make upgrade
```

Figure out the specific files you want (see "Basic Concepts" below), and only include
those files in `make/hello/all.mk`. When you're sure you are done, run `make updatemakego`
to delete unnecessary files.

```bash
# CONFIRM=1 is just for protection
# If you later want to restore all the files, you can do so by adding ALL=1 to this command
make updatemakego CONFIRM=1
```

Then, delete everything in this readme except potentially the badge links at the top (but if
you keep the badge links, update them for your repository). Also update the LICENSE for your use.

## Basic concepts

All projects should have a `make/PROJECT/all.mk` file that defines your actual setup. This
includes files from `make/go` that you need, as well as any custom build commands See
[make/buf/all.mk](https://github.com/bufbuild/buf/blob/main/make/buf/all.mk) for a
real-world example.

This file should all or some of these files, depending on what you need:

- [make/go/bootstrap.mk](make/go/bootstrap.mk) - This always needs to be the first file
  included. This defines functions that the rest of the files use.
- [make/go/go.mk](make/go/go.mk) - This defines Golang functionality. All projects should
  generally include this.
- [make/go/codecov.mk](make/go/codecov.mk) - This adds Codecov support. Only include if you
  use Codecov. If you do not use Codecov, you can delete the `.codecov.yml` file.
- [make/go/docker.mk](make/go/docker.mk) - This defines Docker functionality. Only
  include if you want to use Docker. If you do not use Docker, you can delete the `.dockerignore`
  file and any Dockerfiles.
- [make/go/protoc_gen_.*.mk](make/go). This supports generating files for individual plugins. This
  will likely go away after the [Buf Image Registry](https://buf.build/docs/roadmap) is live.

All other files are automatically included.

## Development commands

We are not documenting all development commands, however some important ones of note:

- `make all` - This is the default goal, and runs linting and testing.
- `make ci` - This is the goal for CI, and downloads deps, and runs linting, testing, and code coverage.
  Note that deps are downloaded automatically on a per-target basis, so the intial dep download really
  shouldn't be needed.
- `make generate` - Do all generation.
- `make lint` - Do all linting.
- `make build` - Go build.
- `make test` - Go test.
- `make cover` - Go code coverage.
- `make install` - Install all Go binaries defined by `GO_BINS`.
- `make dockermakeworkspace` - This will run `make all` by default inside the Docker container
  defined by `Docker.workspace`. You can edit the Makefile target with `DOCKERMAKETARGET`.
- `make dockerbuild` - Build all Docker images defined by `DOCKER_BINS`.
- `make updatemakego` - Update from makego main.

## Variables

Makego is controlled by various environment variables. This list may get out of date, however
as of this writing, this is what is required, settable, and settable at runtime.

### Required

These variables should be defined in your Makefile and are required.

- `MAKEGO` - The location of the `make/go` directory. Generally you should have this as `make/go`,
  however we did make it settable so you can put the files somewhere else.
- `MAKEGO_REMOTE` - The remote location for makego. You should point this at your fork. The
  make target `make copytomakego` will copy your current files to makego in a temporary clone. This
  allows you to edit in individual projects and then easily push updates. If you never want to do
  this, don't run `make copytomakego`, however note that doing so won't mess anything up directly -
  you still need to manually push (the commands are printed out by `make copytomakego` on success).
- `PROJECT` - Your project name. This is used for many things such as your config and cache
  locations.
- `GO_MODULE` - Your Golang module name.

If you use Docker, the following are also required.

- `DOCKER_ORG` - The Docker organization. Optimally this is your Docker Hub organization, but makego
  does not currently interact with Docker Hub.
- `DOCKER_PROJECT` - The Docker project name, generally the same as `PROJECT`. The Docker image
  `$(DOCKER_ORG)/$(DOCKER_PROJECT)-workspace` will be created.

If you use Protobuf, the following are also required.

- `PROTO_PATH` - The path to the root of your Protobuf files. This should generally be `proto` if
  you put your Protobuf files in `proto`, such as in [Buf](https://github.com/bufbuild/buf/tree/main/proto).
- `PROTOC_GEN_.*_OUT` - The output for each plugin, such as `PROTOC_GEN_GO_OUT`.

### Settable

These variables are settable in your Makefiles, but should be static, i.e. these are for
project-specific settings and not intended to be set on the command line.

- `FILE_IGNORES` - The relative paths to files to add to `.dockerignore` and `.gitignore`. By
  default, makego will add `.env`, `.tmp`. and any Golang binaries.
  Note if you set this, you should do so by including the current value ie `FILE_IGNORES := $(FILE_IGNORES) .build/`.
- `CACHE_BASE` - By default, makego caches to `~/.cache/$(PROJECT)`. Set this to change that.
- `GO_BINS` - The relative paths to your Golang main packages, For example `cmd/foo`.
  Note if you set this, you should do so by including the current value ie `GO_BINS := $(GO_BINS) cmd/bar`.
- `GO_GET_PKGS` - Extra packages to get when running `make upgrade`. The various `protoc`
  plugin files set this, and for example [make/buf/all.mk](https://github.com/bufbuild/buf/blob/main/make/buf/all.mk)
  adds `master` for [github.com/jhump/protoreflect](https://github.com/jhump/protoreflect).
  Note if you set this, you should do so by including the current value ie `GO_GET_PKGS := $(GO_GET_PKGS) github.com/foo/bar@v1.0.0`.
- `GO_LINT_IGNORES` - Extra `grep` ignores for linting.
  Note if you set this, you should do so by including the current value ie `GO_LINT_IGNORES := $(GO_LINT_IGNORES) \/foobar\/`.
- `DOCKER_BINS` - This sets any Dockerfiles that are to be built. There should be a matching
  `Dockerfile.binaryname` for each value.
  Note if you set this, you should do so by including the current value ie `DOCKER_BINS := $(DOCKER_BINS) bar`.
- `PROTOC_GEN_.*_OPT` - This sets options for each plugin (except for `protoc-gen-validate`), such
  as `PROTOC_GEN_GO_OPT := plugins=grpc`.
- `.*_VERSION` - This sets the version for dependencies, such as `ERRCHECK_VERSION := e14f8d59a22d460d56c5ee92507cd94c78fbf274`. We update these once in a while, but you can set your own as well to make sure your own
  builds are deterministic. See the `dep_.*` files for the individual variables.

### Runtime

These variables are meant to be set when invoking make targets on the command line.

- `CONFIRM` - This is required to be set when running `make updatemakego`. This is to protect
  against updating when not intended.
- `ALL` - This results in all makego files being downloaded when running `make updatemakego`
  instead of just the ones that you current have included.
- `DOCKERMAKETARGET` - This changes the recursive make target for `make dockermakeworkspace` from
  `all` to this value.
- `GOPKGS` - This controls what packages to build for Go commands. By default, this is `./...`. If
  you only wanted to test `./internal/foo/...` for example, you could run `make test GOPKGS=./internal/foo/...`
- `COVEROPEN` - This will result in the `cover.html` file being automatically opened after `make
  cover` is run, for example `make cover COVEROPEN=1.
