# Copilot instructions

## Repository overview

This repository contains independent, user-invoked Bash utilities for Linux and
Termux. There is no shared application, package manager, build system, or
automated test suite; each executable is a self-contained script with its own
interactive prompts and external command dependencies.

- `cloud` provides a menu for either creating a Cloudflare Tunnel for local
  SSH or connecting to a tunnel URL through an SSH `ProxyCommand`. It may
  attempt to install `cloudflared` using `apt` or Termux `pkg`.
- `quickurl` publishes a selected local protocol and port through
  `cloudflared`, using the first address returned by `hostname -I`.
- `ssh-set` checks for `ssh`/`sshd`, offers SSH key generation, and appends a
  host entry to `$HOME/.ssh/config`.
- `bedtime` records interactive `sleep` or `wake` entries in CSV files under
  `$HOME/storage`.
- `demo` is a plain text placeholder and is not an executable utility.

The scripts intentionally operate through the current user's environment
(`$HOME`, local network interfaces, SSH configuration, and installed system
commands). Avoid introducing a shared framework or package abstraction unless
the repository's scope changes substantially.

## Build, test, and lint commands

There is no build command or project test runner. The baseline validation is
Bash syntax checking:

```bash
# Check every executable script
for script in bedtime cloud quickurl ssh-set; do
  bash -n "$script" || exit 1
done

# Check one script only
bash -n ./cloud
```

If ShellCheck is installed locally, lint the scripts with:

```bash
shellcheck bedtime cloud quickurl ssh-set
```

ShellCheck is not currently installed in the development environment and there
is no repository ShellCheck configuration. Runtime testing is interactive and
can change SSH configuration, create CSV files, open tunnels, or install
packages, so do not invoke those paths as part of routine validation without
the required environment and an explicit need.

The scripts are tracked as executable files. Preserve that executable bit when
editing or adding runnable utilities; they can be run directly, for example:

```bash
./bedtime
./cloud
./quickurl
./ssh-set
```

## Architecture and execution flow

Each script owns its complete control flow: initialize environment-specific
variables, prompt with `read`, call system/network tools, and exit. There are
no imports, functions shared between files, configuration files in the
repository, or argument-parsing conventions common to all scripts.

The main integration point is the host environment:

- Cloudflare-based scripts depend on `cloudflared`; `cloud` additionally uses
  SSH with a Cloudflare access proxy.
- SSH setup writes to the user's home directory and can install OpenSSH on
  Debian-like systems or Termux.
- The bedtime tracker assumes `$HOME/storage` exists (commonly Termux shared
  storage) and maintains separate sleep and wake CSV files.

Keep changes localized to the script whose behavior is being changed. If a
new utility is added, document its purpose and required commands in
`README.md`, make it executable, and include it in the syntax-check command
above.

## Code conventions specific to this repository

- Use Bash (`#!/bin/bash`) rather than POSIX `sh`; the scripts use Bash
  features such as `[[ ... ]]`, functions, and shell options.
- Interactive menus and prompts are the primary interface. Preserve the
  existing prompt-driven flow unless explicitly converting a script to support
  non-interactive use.
- Support both Debian-like Linux and Termux where installation logic already
  does so. Keep package-manager fallbacks explicit (`apt`/`sudo apt` versus
  `pkg`) and do not silently replace a failed dependency installation with
  success behavior.
- Treat external tools as runtime dependencies and check for them before use
  when the script already follows that pattern. Network operations and package
  installation should remain opt-in runtime behavior, not part of syntax or
  lint validation.
- Preserve the current data formats and locations: bedtime records use
  comma-separated `Date, Time, Day` rows in
  `$HOME/storage/.bedtime.csv` and `$HOME/storage/.waketime.csv`; SSH entries
  target `$HOME/.ssh/config`.
- Keep user-entered values quoted when passing paths, hostnames, usernames, and
  URLs to commands. Be especially careful around SSH options, `ProxyCommand`,
  shell prompts, and values interpolated into configuration text.
- Preserve the simple script style and existing executable permissions; avoid
  adding dependencies or repository-wide tooling for a single utility.
