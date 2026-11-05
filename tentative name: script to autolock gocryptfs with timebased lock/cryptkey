#!/usr/bin/python3

## Use gocryptfs automatic password changer and store new password into keyde

## Module Import
import os
from pathlib import Path
import subprocess
import sys
import argparse
import color as log
import shutil

if os.getuid() == 0:
    print("script run by sudo ")
## depedency check to required for this script
if not shutil.which("gocryptfs"):
    print("gocryptfs not installed in system")
    log.log_info("gocryptfs is installing...")
    subprocess.run(
        ["sudo", "apt", "update", "-y"],
        check=True,
        timeout=90,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    subprocess.run(
        ["sudo", "apt", "install", "gocryptfs", "-y"],
        check=True,
        stderr=subprocess.DEVNULL,
    )
try:
    __import__("pexpect")
except ModuleNotFoundError:
    subprocess.run(["sudo", "apt", "install", "python3-pexpect"], check=True)
# subprocess.run(["pip", "install", "pexpect"], check=True)

import pexpect  # third party module

# -------------------------------------------------------------------------
## Path configuration
pass_script = Path.home() / "bin" / "pass"
secfile = Path.home() / "Documents" / "secure.file"
cipher_dir = secfile / "Zin"
newp = secfile / "newpass"
oldp = secfile / "recentpass"
locked_file = secfile / "recentpass.enc"
# -------------------------------------------------------------------------

# flag generated
parse = argparse.ArgumentParser(
    usage="""%(prog)s [options]
   or: %(prog)s -t [duration]
      give duration only when use -t to timebased lock password""",
    description="Bootstrap script and to automate encryption task",
    formatter_class=argparse.RawTextHelpFormatter,
)
parse.add_argument("-c", "--change", action="store_true", help="to change password")
parse.add_argument(
    "-t", "--timelock", action="store_true", help="to lock based on time"
)
parse.add_argument(
    "-u", "--timeunlock", action="store_true", help="to unlock encrypted password"
)
parse.add_argument(
    "-w",
    "--watch",
    action="store_true",
    help="to show the time count of unlock file remaining time",
)
parse.add_argument(
    "date_time",
    nargs="?",
    help="""to set encryption in password (date,time, and day):\nfor date with time '<date time>': '2026-12-02 15:30:00'\nFor duration <number>d,h,m,s: 2m | 30s | 5d | 17:30:00""",
)
get_parse = parse.parse_args()

## TODO: Turn into function all the code which repeat in this source code more than 1 time


## module 1
def copy_in_clipboard(pathofpass):
    choose = input("Would you like to copy new password directly [y/n]: ")
    if choose == "y":
        subprocess.run(["clip-c", pathofpass], check=True, timeout=5)


def generate_password(func):
    def wrapper():
        try:
            with open(newp, "w") as file_create:
                subprocess.run(
                    [pass_script, 18],
                    check=True,
                    stdout=file_create,
                    stderr=subprocess.DEVNULL,
                )
                log.log_ok("password genrated in pass")
        except subprocess.CalledProcessError:
            log.log_err("Checkout out source code something wrong")
            sys.exit(1)
        except OSError:
            log.log_err("Unexpected error my different OS than expected")
            sys.exit(1)
        return func()

    return wrapper


def encryption_pass_file():
    pass


def decrypt_pass_file():
    pass


def watch_encryption_remaining_time():
    pass


if get_parse.change:
    # genrate new password
    try:
        with open(newp, "w") as fc:
            subprocess.run(
                [pass_script, "16"],
                check=True,
                stdout=fc,
                stderr=subprocess.DEVNULL,
                encoding="utf-8",
                timeout=10,
            )
    except subprocess.CalledProcessError:
        log.log_err("something is wrong review source code password genrating part")
        sys.exit(1)

    except subprocess.TimeoutExpired:
        log.log_err("Time excceed for generating password")
        sys.exit(1)
    except Exception as e:
        log.log_err(f"An Unexpected error occur: {e}")
        sys.exit(1)

    else:
        log.log_ok(f"new password generated in {newp.name} file")

    # Read password
    try:
        with open(newp, "r") as np:
            new_pass = np.read().strip()

        with open(oldp, "r") as op:
            old_pass = op.read().strip()
    except Exception as e:
        log.log_err(f"An Unexpected error to read password: {e}")
        sys.exit(1)

    ### Change password using gocryptfs
    try:
        child = pexpect.spawn(f"gocryptfs -passwd {cipher_dir}", encoding="utf-8")
        child.expect("Password:")
        child.sendline(old_pass)

        child.expect("Please enter your new password.")
        child.expect("Password:")
        child.sendline(new_pass)

        child.expect("Repeat:")
        child.sendline(new_pass)
        child.interact()
        try:
            subprocess.run(["cp", newp, oldp], check=True, timeout=3)
        except subprocess.CalledProcessError:
            log.log_err("old password not update")
            sys.exit(1)

    except KeyboardInterrupt:
        log.log_warn("You Cancel program forcefully")
    except Exception as e:
        log.log_err(f"Unexpected Error {e}")
        sys.exit(1)
    else:
        log.log_ok("password successfuly changed!")
        copy_in_clipboard(newp)
if get_parse.timelock:
    try:
        if newp.exists():
            newp.unlink()
        subprocess.run(
            ["tlescr", "encrypt", oldp, "--at", get_parse.date_time],
            check=True,
            timeout=20,
        )
        oldp.unlink()
    except subprocess.CalledProcessError:
        log.log_err("Something went wrong!")
    except TypeError:
        log.log_err(
            f"to lock it's keys required to give positional argument for more info\nuse {sys.argv[0]} --help"
        )
    else:
        log.log_ok(f"{oldp.name} successfuly got locked")
if get_parse.timeunlock:
    try:
        if oldp.exists():
            log.log_warn("Password already unlocked")
            copy_in_clipboard(oldp)
        else:
            subprocess.run(["tlescr", "decrypt", locked_file], check=True, timeout=40)
            locked_file.unlink()
            copy_in_clipboard(oldp)
    except subprocess.CalledProcessError:
        log.log_info("Try again!")
if get_parse.watch:
    try:
        if not locked_file.exists():
            log.log_err("File is not locked!")
        else:
            subprocess.run(["tlescr", "watch", locked_file], check=True)
    except subprocess.CalledProcessError:
        log.log_ok("countdown cancelled")
