#!/usr/bin/env python3
"""
Markdown pre-processor for docx output.
Inserts a raw OpenXML page break after every 2 organizations.

Usage:
    python3 add-docx-pagebreaks.py <input.md> <output.md>
"""
import re
import sys

PAGE_BREAK = """
```{=openxml}
<w:p><w:r><w:br w:type="page"/></w:r></w:p>
```

"""


def process(src_path: str, dst_path: str) -> None:
    with open(src_path, encoding="utf-8") as f:
        content = f.read()

    # Split at every ### heading that starts an organization entry.
    # The org section begins after the "## 本編" / alphabet section markers.
    # We detect org ### entries by finding the first ### after "## 0-9"
    marker = re.search(r'^## 0-9', content, re.MULTILINE)
    if not marker:
        sys.exit("ERROR: could not find '## 0-9' section in markdown")

    pre = content[:marker.start()]
    org_section = content[marker.start():]

    # Split on each ### heading
    parts = re.split(r"(?=^### )", org_section, flags=re.MULTILINE)
    header = parts[0]   # "## 0-9\n\n### 52°North..." — first org is parts[1]
    orgs = parts[1:]

    print(f"  organizations : {len(orgs)}")

    chunks = []
    for i, org in enumerate(orgs):
        chunks.append(org)
        # After every 2nd org, insert page break (but not at the very end)
        if (i + 1) % 2 == 0 and (i + 1) < len(orgs):
            chunks.append(PAGE_BREAK)

    print(f"  page breaks   : {sum(1 for c in chunks if '=openxml' in c)}")

    result = pre + header + "".join(chunks)

    with open(dst_path, encoding="utf-8", mode="w") as f:
        f.write(result)

    print(f"  written to    : {dst_path}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit(f"Usage: {sys.argv[0]} <input.md> <output.md>")
    process(sys.argv[1], sys.argv[2])
