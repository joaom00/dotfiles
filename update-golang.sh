#!/usr/bin/env bash

# Thanks udhos https://github.com/udhos/update-golang

release_list=https://golang.org/dl/
source=https://storage.googleapis.com/golang
release=1.16.4 # just the default. the script detects the latest available release.

msg() {
	echo >&2 "$me": "$*"
}

has_cmd() {
	hash "$1" 2>/dev/null
}

exclude_beta() {
	grep -v -E 'go[0-9\.]+(beta|rc)'
}

scan_versions() {
	local fetch="$*"
	if has_cmd jq; then
		local rl="$release_list?mode=json"
		msg "parsing with jq from $rl"
		$fetch "$rl" | jq -r '.[].files[].version' | sort | uniq | exclude_beta | sed -e 's/go//' | sort -V
	else
		$fetch "$release_list" | exclude_beta | grep -E -o 'go[0-9\.]+' | grep -E -o '[0-9]\.[0-9]+(\.[0-9]+)?' | sort -V | uniq
	fi
}

find_latest() {
	local last=
	local fetch=
	if has_cmd wget; then
		fetch="wget -qO-"
	elif has_cmd curl; then
		fetch="curl --silent"
	fi
	last=$(scan_versions "$fetch" | tail -1)
	if echo "$last" | grep -q -E '[0-9]\.[0-9]+(\.[0-9]+)?'; then
		release=$last
	fi
}

find_latest

wget ${release_list}go${release}.linux-amd64.tar.gz

rm -rf /usr/local/go && tar -C /usr/local -xzf go${release}.linux-amd64.tar.gz

rm -rf go${release}.linux-amd64.tar.gz

echo "=>> Go update to ${release}"
