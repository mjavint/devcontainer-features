# wkhtmltopdf

This feature installs [wkhtmltopdf](https://wkhtmltopdf.org/), a command line tool for rendering HTML into PDF and images.

## Example Usage

```json
"features": {
    "ghcr.io/user/repo/wkhtmltopdf:1": {
        "version": "0.12.6.1"
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select the version to install | string | 0.12.6 |

## Supported Platforms

The feature should work on any Linux platform that supports apt package manager. It automatically detects the platform and installs the appropriate package for:

- Ubuntu 20.04, 22.04, 23.04, and later versions
- Debian 11 (Bullseye), 12 (Bookworm), and later versions
- Other Debian-based distributions (will use the closest matching package)

Not supported on macOS or Windows.

## OS Support

This feature is tested and supported on:

- Ubuntu
- Debian

## Limitations

- The script only supports Linux-based systems using the apt package manager
- macOS and Windows are not supported through this installation method
