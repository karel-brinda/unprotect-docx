#! /usr/bin/env bash

set -e
set -o pipefail
set -u
#set -f

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(dirname $0)
readonly -a ARGS=("$@")
readonly NARGS="$#"

if [[ $NARGS -ne 2 ]]; then
	>&2 echo "usage: $PROGNAME protected.docx unprotected.docx"
	exit 1
fi

x="$1"
y="$2"
d=$(mktemp -d)

echo "tmp dir: $d"

cp "$x" "$d/a.docx"

(
	cd "$d"
	mkdir a
	unzip -d a a.docx


	(
		cd a
		zip ../b.docx $(find .)
	)
)


cp "$d/b.docx" "$y"
