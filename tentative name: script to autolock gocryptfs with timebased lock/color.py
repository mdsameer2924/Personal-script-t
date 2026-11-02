import sys

# ANSI Colors
GREEN = "\033[92m"
CYAN = "\033[96m"
YELLOW = "\033[93m"
RED = "\033[91m"
RESET = "\033[0m"


def log_ok(msg):
    print(f"{GREEN}[ OK ]{RESET} {msg}")


def log_info(msg):
    print(f"{CYAN}[ .. ]{RESET} {msg}")


def log_warn(msg):
    print(f"{YELLOW}[WARN]{RESET} {msg}", file=sys.stderr)


def log_err(msg):
    print(f"{RED}[FAIL]{RESET} {msg}", file=sys.stderr)


def die(msg):
    log_err(msg)
    sys.exit(1)


if __name__ == "__main__":
    # Example usage:
    log_info("Checking environment...")
    log_ok("System ready.")
    log_err("System Corrupted")

    die("Kiya leekhu")
