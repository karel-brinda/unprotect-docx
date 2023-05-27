#! /usr/bin/env bash

set -e
set -o pipefail
set -u
#set -f

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(dirname $0)
readonly -a ARGS=("$@")
readonly NARGS="$#"

C='\033[0;33m'
NC='\033[0m'

msg() {
	set +x
	echo
	echo -e "${C}=================================================${NC}"
	echo -e "${C}$@${NC}"
	echo -e "${C}=================================================${NC}"
	echo
	set -x
}

if [[ $NARGS -ne 2 ]]; then
	>&2 echo "usage: $PROGNAME protected.docx unprotected.docx"
	exit 1
fi

x="$1"
y="$2"
d=$(mktemp -d)

set -x
msg "||           $PROGNAME                 ||"
msg "Step 1: creating a tmp dir:\n        \"$d\""

cp "$x" "$d/a.docx"

(
	cd "$d"
	mkdir a
	msg "Step 2: unzipping the content of \"$x\" into\n        \"$d/a\""
	unzip -d a a.docx

	msg "Step 3: modifying the content"


	msg "Step 4: re-zipping the content of\n         \"$d/a\"\n        into \"$y\""
	(
		cd a
		zip ../b.docx $(find .)
	)
)


cp "$d/b.docx" "$y"

msg Finished 🎉
