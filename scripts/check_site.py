#!/usr/bin/env python3
"""Checks a built site: internal links resolve, generated pages are complete.
Usage: check_site.py <hugo output dir> [base path, e.g. /elementum-surge/ when built with a sub-path baseURL]"""
import re
import sys
from pathlib import Path

root = Path(sys.argv[1])
base = sys.argv[2] if len(sys.argv) > 2 else "/"
errors = []


def check(cond, msg):
    if not cond:
        errors.append(msg)


def page(path):
    f = root / path / "index.html"
    check(f.is_file(), f"{path}: page is missing")
    return f.read_text(errors="replace") if f.is_file() else ""


# shortcut: only root-relative links are checked, external links are not fetched
for f in root.rglob("*.html"):
    if f.relative_to(root).parts[0] == "revealjs":  # theme's vendored reveal.js demo files
        continue
    for url in re.findall(r'(?:href|src)="(/(?!/)[^"#?]*)', f.read_text(errors="replace")):
        if not url.startswith(base):
            check(False, f"{f.relative_to(root)}: link outside {base}: {url}")
            continue
        target = root / url[len(base):]
        check(target.is_file() or (target / "index.html").is_file(), f"{f.relative_to(root)}: broken link {url}")

# Linked from the add-ons (settings, README) or moved pages, must keep working after restructuring
for path in ("donate", "context", "contribute/log", "lt2http", "configuration/kodi-settings", "configuration/command-line"):
    page(path)

for path, minimum in (("configuration/elementum/kodi-settings", 100),
                      ("configuration/burst", 100),
                      ("configuration/lt2http/kodi-settings", 40)):
    settings = page(path)
    check(settings.count("<code>") > minimum, f"{path}: too few settings rendered")
    check(not re.search(r"(<tr><td>|<th colspan=\"5\">|<h2[^>]*>)\d{5}<", settings), f"{path}: unresolved string id in labels")
    check(not re.search(r"\[/?(B|I|COLOR)\b|\$ADDON", settings), f"{path}: Kodi formatting tags left")

flags = page("configuration/elementum/command-line")
check(len(re.findall(r"<td><code>-[a-z]\w+</code>", flags)) > 10, "elementum/command-line: too few flags rendered")
check("<code>-remoteHost</code>" in flags, "elementum/command-line: -remoteHost flag is missing")

options = page("configuration/lt2http/command-line")
check(len(re.findall(r"<td><code>--[a-z_]+</code>", options)) > 40, "lt2http/command-line: too few options rendered")
check(re.search(r"<code>--download_storage</code></td><td>string</td><td>memory</td><td>automatic / file / memory</td><td>yes", options),
      "lt2http/command-line: download_storage type, default, values or config file flag is wrong")

for name in ("elementum", "burst", "context", "lt2http"):
    notes = page(f"release-notes/{name}")
    check(len(re.findall(r'<h3 id="v?\d', notes)) > 2, f"release-notes/{name}: no version headings")
    check(not re.search(r"\[/?(B|I|COLOR)\b", notes), f"release-notes/{name}: Kodi formatting tags left")

print("\n".join(errors) or "Site OK")
sys.exit(1 if errors else 0)
