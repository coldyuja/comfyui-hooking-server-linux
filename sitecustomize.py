"""Runtime tweaks for Linux/Docker execution.

Python imports sitecustomize automatically when it is present on sys.path.
This keeps the upstream server.py mostly unchanged while making container
startup safe for headless environments.
"""

import os
import webbrowser


def _disabled_open(*args, **kwargs):
    print("[HEADLESS] Browser auto-open skipped. Set NO_BROWSER=0 to enable it.")
    return False


if os.environ.get("NO_BROWSER", "0") == "1":
    webbrowser.open = _disabled_open
