#!/usr/bin/env bash
#
# # Thanks udhos https://github.com/udhos/update-golang
#
# set -e
#
# release_list=https://golang.org/dl/
# source=https://storage.googleapis.com/golang
# release=1.16.4 # just the default. the script detects the latest available release.
#
# msg() {
# 	echo >&2 "$me": "$*"
# }
#
# has_cmd() {
# 	hash "$1" 2>/dev/null
# }
#
# exclude_beta() {
# 	grep -v -E 'go[0-9\.]+(beta|rc)'
# }
#
# scan_versions() {
# 	local fetch="$*"
# 	if has_cmd jq; then
# 		local rl="$release_list?mode=json"
# 		msg "parsing with jq from $rl"
# 		$fetch "$rl" | jq -r '.[].files[].version' | sort | uniq | exclude_beta | sed -e 's/go//' | sort -V
# 	else
# 		$fetch "$release_list" | exclude_beta | grep -E -o 'go[0-9\.]+' | grep -E -o '[0-9]\.[0-9]+(\.[0-9]+)?' | sort -V | uniq
# 	fi
# }
#
# find_latest() {
# 	local last=
# 	local fetch=
# 	if has_cmd wget; then
# 		fetch="wget -qO-"
# 	elif has_cmd curl; then
# 		fetch="curl --silent"
# 	fi
# 	last=$(scan_versions "$fetch" | tail -1)
# 	if echo "$last" | grep -q -E '[0-9]\.[0-9]+(\.[0-9]+)?'; then
# 		release=$last
# 	fi
# }
#
# find_latest
#
# wget ${release_list}go${release}.linux-amd64.tar.gz
#
# rm -rf /usr/local/go && tar -C /usr/local -xzf go${release}.linux-amd64.tar.gz
#
# rm -rf go${release}.linux-amd64.tar.gz
#
# echo "=>> Go update to ${release}"

version=$(go tool dist version)
release=$(wget -qO- "https://golang.org/VERSION?m=text")

if [[ $version == "$release" ]]; then
    echo "The local Go version ${release} is up-to-date."
    exit 0
else
    echo "The local Go version is ${version}. A new release ${release} is available."
fi

release_file="${release}.linux-amd64.tar.gz"

tmp=$(mktemp -d)
cd $tmp || exit 1

echo "Downloading https://go.dev/dl/$release_file ..." 
curl -OL https://go.dev/dl/$release_file

rm -f ${HOME}/apps/go 2>/dev/null

tar -C ${HOME}/apps -xzf $release_file
rm -rf $tmp

mv ${HOME}/apps/go ${HOME}/apps/$release
ln -sf ${HOME}/apps/$release ${HOME}/apps/go

version=$(go tool dist version)
echo "Now, local Go version is $version"
