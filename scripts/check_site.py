#!/usr/bin/env python3
"""Checks a built site: internal links resolve, generated pages are complete. Usage: check_site.py <hugo output dir>"""
import re
import sys
from pathlib import Path

root = Path(sys.argv[1])
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
        target = root / url.lstrip("/")
        check(target.is_file() or (target / "index.html").is_file(), f"{f.relative_to(root)}: broken link {url}")

settings = page("configuration/kodi-settings")
check(settings.count("<code>") > 100, "kodi-settings: too few settings rendered")
check(not re.search(r"(<tr><td>|<th colspan=\"5\">|<h2>)\d{5}<", settings), "kodi-settings: unresolved string id in labels")

flags = page("configuration/command-line")
check(len(re.findall(r"<td><code>-[a-z]\w+</code>", flags)) > 10, "command-line: too few flags rendered")
check("<code>-remoteHost</code>" in flags, "command-line: -remoteHost flag is missing")

for name in ("elementum", "burst", "context"):
    notes = page(f"release-notes/{name}")
    check(len(re.findall(r'<h3 id="v?\d', notes)) > 2, f"release-notes/{name}: no version headings")
    check(not re.search(r"\[/?(B|I|COLOR)\b", notes), f"release-notes/{name}: Kodi formatting tags left")

print("\n".join(errors) or "Site OK")
sys.exit(1 if errors else 0)
