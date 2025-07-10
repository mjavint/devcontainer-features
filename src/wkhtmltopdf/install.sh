#!/usr/bin/env bash

set -e

# Clean up
rm -rf /var/lib/apt/lists/*
WKHTMLTOPDF_VERSION="${VERSION:-"0.12.6"}"

architecture="$(uname -m)"
os="$(uname -s)"

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Ensure apt is in non-interactive to avoid prompts
export DEBIAN_FRONTEND=noninteractive

# Determine the appropriate architecture for wkhtmltopdf
case ${architecture} in
    x86_64 | amd64)
        arch_suffix="amd64"
        ;;
    aarch64 | arm64)
        arch_suffix="arm64"
        ;;
    i386 | i486 | i686)
        arch_suffix="i386"
        ;;
    *)
        echo "(!) Architecture ${architecture} unsupported"
        exit 1
        ;;
esac

# Determine the OS and set up the download URL
case "${os}" in
    Linux*)
        # Install dependencies
        apt_get_update() {
            if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
                echo "Running apt-get update..."
                apt-get update -y
            fi
        }

        # Checks if packages are installed and installs them if not
        check_packages() {
            if ! dpkg -s "$@" > /dev/null 2>&1; then
                apt_get_update
                apt-get -y install --no-install-recommends "$@"
            fi
        }

        # Install dependencies
        check_packages ca-certificates curl fontconfig libxrender1 libfontconfig1 libxext6 libx11-6 wget

        # Download and install wkhtmltopdf
        echo "Installing wkhtmltopdf ${WKHTMLTOPDF_VERSION}..."

        # Set the URL based on the version and architecture
        if [ "${arch_suffix}" = "arm64" ]; then
            # ARM64 builds are only available through a specific source
            wget -q -O wkhtmltox.deb https://github.com/wkhtmltopdf/packaging/releases/download/${WKHTMLTOPDF_VERSION}-2/wkhtmltox_${WKHTMLTOPDF_VERSION}-2.bullseye_arm64.deb
        else
            # Standard x86_64/i386 builds
            wget -q -O wkhtmltox.deb https://github.com/wkhtmltopdf/packaging/releases/download/${WKHTMLTOPDF_VERSION}-2/wkhtmltox_${WKHTMLTOPDF_VERSION}-2.bullseye_${arch_suffix}.deb
        fi

        # Install the package
        apt-get install -y ./wkhtmltox.deb
        rm wkhtmltox.deb
        ;;

    Darwin*)
        echo "MacOS installation is not supported through this script."
        echo "Please use Homebrew: brew install wkhtmltopdf"
        exit 1
        ;;

    *)
        echo "(!) OS ${os} unsupported"
        exit 1
        ;;
esac

# Clean up
rm -rf /var/lib/apt/lists/*

# Verify installation
wkhtmltopdf --version

echo "Done!"
