#!/bin/bash
set -eux

#SUBMODULE_REPO
#TARGET_REPO
#SUBMODULE_LOCATION

if ! test -d "${SUBMODULE_SOURCE}" && git -C "${SUBMODULE_SOURCE}" rev-parse
then
  printf 'SUBMODULE_SOURCE not specified or invalid\n' >&2
  exit 1
fi

if ! test -d "${TARGET_REPO}" && git -C "${TARGET_REPO}" rev-parse
then
  printf 'TARGET_REPO not specified or invalid\n' >&2
  exit 1
fi

if ! test -d "${TARGET_REPO}/${SUBMODULE_LOCATION}" && git -C "${TARGET_REPO}/${SUBMODULE_LOCATION}" rev-parse
then
  printf 'SUBMODULE_LOCATION not specified or invalid\n' >&2
  exit 1
fi

COMMIT_MESSAGE=${COMMIT_MESSAGE:-"Updated $(basename `git -C ${SUBMODULE_REPO} rev-parse --show-toplevel`) submodule"}
COMMIT_AUTHOR=${COMMIT_AUTHOR:-"concourse"}
COMMIT_EMAIL=${COMMIT_EMAIL:-"lennart@madmanfred.com"}


# Test if the submodule is already up to date
EVEN="[ $(git -C "${SUBMODULE_SOURCE}" rev-parse HEAD) = $(git -C "${TARGET_REPO}/${SUBMODULE_LOCATION}" rev-parse HEAD) ]"
if $EVEN
then
  printf 'Submodule is already up to date\n'
  exit 0
fi

git config --global user.name $COMMIT_AUTHOR
git config --global user.email $COMMIT_EMAIL
git -C "${TARGET_REPO}/${SUBMODULE_LOCATION}" pull --ff-only "$(pwd)/${SUBMODULE_SOURCE}" master
git -C "${TARGET_REPO}" add "${SUBMODULE_LOCATION}"
#COMMIT_DATE=$(git -C "${SUBMODULE_SOURCE}" show -s --format=%ct HEAD)
#GIT_COMMITTER_DATE=${COMMIT_DATE} git -C "${TARGET_REPO}" commit --date ${COMMIT_DATE} -m "${COMMIT_MESSAGE}"
git -C "${TARGET_REPO}" commit -m "${COMMIT_MESSAGE}"
