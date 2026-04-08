#!/usr/bin/env python3
"""
HTML post-processor for PDF output.
Wraps every 2 organizations in a <div class="page-pair"> container
so Chrome --print-to-pdf can break on those boundaries.

Usage:
    python3 add-pdf-pagebreaks.py <html-file>
File is modified in-place.
"""
import re
import sys


def add_page_breaks(html_path: str) -> None:
    with open(html_path, encoding="utf-8") as f:
        html = f.read()

    # ---- find where org body starts (## 0-9 {#numbers}) ----
    split_match = re.search(r'(?=<h2[^>]*\bid="numbers")', html)
    if not split_match:
        sys.exit("ERROR: could not find section id='numbers'")

    pre_html = html[:split_match.start()]
    org_html  = html[split_match.start():]

    # ---- split org_html at every <h3 opening tag ----
    # parts[0] = everything before first org h3 (the h2 alphabet headings etc.)
    # parts[1..] = one segment per org, each starting with its <h3>
    parts = re.split(r"(?=<h3\b)", org_html)
    header_part = parts[0]
    org_parts   = parts[1:]

    print(f"  organizations : {len(org_parts)}")

    # ---- build new body: group orgs in pairs inside wrapper divs ----
    pairs = []
    for i in range(0, len(org_parts), 2):
        chunk = "".join(org_parts[i:i+2])
        pairs.append(chunk)

    # Wrap each pair; last pair gets no trailing break
    pair_html = []
    for i, pair in enumerate(pairs):
        is_last = (i == len(pairs) - 1)
        style = (
            'class="page-pair"'
            if is_last
            else 'class="page-pair" style="break-after: page; page-break-after: always;"'
        )
        pair_html.append(f'<div {style}>\n{pair}\n</div>\n')

    print(f"  page pairs    : {len(pairs)}")

    new_html = pre_html + header_part + "".join(pair_html)

    with open(html_path, "w", encoding="utf-8") as f:
        f.write(new_html)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(f"Usage: {sys.argv[0]} <html-file>")
    add_page_breaks(sys.argv[1])
