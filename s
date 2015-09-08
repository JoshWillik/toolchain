#! /usr/bin/env bash
set -u
set -e

if [ -z "${1+foo}" ]; then
	echo "Usage: add-script <name>"
	exit
fi

script_type=${2:-bash}
dir=~/.toolchain

if [ ! -f $dir/$1 ]; then
	touch $dir/$1
	echo "#! /usr/bin/env $script_type" > $dir/$1
	chmod +x $dir/$1
fi

$EDITOR $dir/$1

git add --all
git commit -a
git push origin master
