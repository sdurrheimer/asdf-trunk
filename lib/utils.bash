#!/usr/bin/env bash

set -euo pipefail

TOOL_NAME="trunk"
TOOL_TEST="trunk --version"

DOWNLOAD_URL="https://trunk.io/releases"
LATEST_FILE="https://trunk.io/releases/latest"
MINIMUM_MACOS_VERSION="10.15"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

lawk() {
	awk 'BEGIN{ORS="";}{gsub(/\r/, "", $0)}'"${1}" "${@:2}"
}

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_all_versions() {
	# Trunk.io doesn't allow to list all available versions, but here is the latest one
	curl "${curl_opts[@]}" -X GET "${LATEST_FILE}" | lawk '/version:/{print $2; exit;}'
}

download_release() {
	local version filename os arch url
	version="$1"
	filename="$2"
	os="$3"
	arch="$4"

	url="$DOWNLOAD_URL/${version}/trunk-${version}-${os}-${arch}.tar.gz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}

check_darwin_version() {
	local osx_version
	osx_version="$(sw_vers -productVersion)"

	# trunk-ignore-begin(shellcheck/SC2312): the == will fail if anything inside the $() fails
	if [[ "$(printf "%s\n%s\n" "${MINIMUM_MACOS_VERSION}" "${osx_version}" |
		sort --version-sort |
		head -n 1)" == "${MINIMUM_MACOS_VERSION}"* ]]; then
		return
	fi
	# trunk-ignore-end(shellcheck/SC2312)

	fail "Trunk requires at least MacOS ${MINIMUM_MACOS_VERSION}" \
		"(yours is ${osx_version}). See https://docs.trunk.io for more info."
}

check_platform() {
	local os arch platform
	os="$1"
	arch="$2"
	platform="$os-$arch"

	if [[ ${platform} == "darwin-x86_64" || ${platform} == "darwin-arm64" ]]; then
		check_darwin_version
	elif [[ ${platform} == "linux-x86_64" || ${platform} == "linux-arm64" || ${platform} == "windows-x86_64" || ${platform} == "mingw-x86_64" ]]; then
		:
	else
		fail "Trunk is only supported on Linux (x64_64, arm64), MacOS (x86_64, arm64), and Windows (x86_64)." \
			"See https://docs.trunk.io for more info."
	fi
}
