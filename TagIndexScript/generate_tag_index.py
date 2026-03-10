"""
generate_tag_index.py

Reads the data about an issue (e.g. ZeroPointFive.txt) extracts unique tags from each entry, and produces an HTML tag-index page.

Usage:
    python generate_tag_index.py ZeroPointFive.txt
    # Output written to TagIndex.html
"""

import json
import sys
from collections import defaultdict
from urllib.parse import quote


def load_entries(filepath: str):
    """Return (issue_number, entries) where entries is a list of raw lists."""
    with open(filepath, encoding="utf-8") as fh:
        lines = [line.strip() for line in fh if line.strip()]

    rows = [json.loads(line) for line in lines]

    if not rows:
        raise ValueError("Input file is empty.")

    # First row is issue metadata: [issue number, quote of the week, quote author]
    issue_number = rows[0][0]
    entries = rows[1:]
    return issue_number, entries


def build_tag_index(issue_number: str, entries: list):
    """
    Returns a dict: { tag_name: [ {type, title, author, url}, ... ] }
    FanArt entries are skipped.
    """
    tag_map: dict[str, list] = defaultdict(list)

    for entry in entries:
        entry_type = entry[0]   # e.g. "Comics", "Articles"
        if entry_type == "FanArt":
            continue # FanArt is just one page, I'm not sure if an index is that useful for it rn so I'm skipping.

        title    = entry[1]
        author   = entry[2].strip()
        raw_tags = entry[4].lower()

        # Build the URL: base/Issue{num}/{type}/{title-encoded}.html
        # TODO: For Jeran - you may want to change this to a relative path!!!
        encoded_title = quote(title)
        url = (
            f"https://neopianpost.neocities.org"
            f"/Issue{issue_number}/{entry_type}/{encoded_title}.html"
        )

        info = {
            "type":   entry_type,
            "title":  title,
            "author": author,
            "url":    url,
        }

        for tag in [t.strip() for t in raw_tags.split(",") if t.strip()]:
            tag_map[tag].append(info)

    return tag_map


def escape_html(text: str) -> str:
    return (
        text
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace('"', "&quot;")
        .replace("'", "&#39;")
    )


def build_tag_table_html(tag_map: dict) -> str:
    """Render one HTML <table> block per tag."""
    blocks = []

    for tag in sorted(tag_map.keys(), key=str.lower):
        entries = tag_map[tag]

        rows_html = []
        for e in entries:
            rows_html.append(
                '<tr>'
                '<td class="lightBG" width="15%" style="padding:3px 6px;">'
                + escape_html(e["type"]) +
                '</td>'
                '<td width="45%" style="padding:3px 6px;">'
                '<a href="' + escape_html(e["url"]) + '">' + escape_html(e["title"]) + '</a>'
                '</td>'
                '<td width="40%" style="padding:3px 6px;">'
                + escape_html(e["author"]) +
                '</td>'
                '</tr>'
            )

        block = (
            '\n<table cellpadding="2" cellspacing="0" border="0" width="100%">\n'
            '  <tbody>\n'
            '    <tr>\n'
            '      <td colspan="3" class="darkBG" style="padding:4px 6px;">\n'
            '        <h3>' + escape_html(tag) + '</h3>\n'
            '      </td>\n'
            '    </tr>\n'
            '    <tr>\n'
            '      <td class="darkBG" style="padding:2px 6px;"><strong>Type</strong></td>\n'
            '      <td class="darkBG" style="padding:2px 6px;"><strong>Title</strong></td>\n'
            '      <td class="darkBG" style="padding:2px 6px;"><strong>Author</strong></td>\n'
            '    </tr>\n'
            '    ' + ''.join(rows_html) + '\n'
            '  </tbody>\n'
            '</table>\n'
            '<br>'
        )
        blocks.append(block)

    return "\n".join(blocks)


TEMPLATE_FILE = "TagIndexTemplate.html"


def generate_page(issue_number: str, tag_map: dict) -> str:
    with open(TEMPLATE_FILE, encoding="utf-8") as fh:
        template = fh.read()
    # Use plain str.replace to avoid conflicts with CSS curly braces
    template = template.replace("{issue_number}", escape_html(issue_number))
    template = template.replace("{tag_tables}", build_tag_table_html(tag_map))
    return template


def main():
    if len(sys.argv) < 2:
        print("Usage: python generate_tag_index.py <path_to_ZeroPointFive.txt>")
        sys.exit(1)

    filepath = sys.argv[1]
    issue_number, entries = load_entries(filepath)
    print(f"Issue number : {issue_number}")
    print(f"Entries found: {len(entries)}")

    tag_map = build_tag_index(issue_number, entries)
    print(f"Unique tags  : {len(tag_map)}")
    for tag in sorted(tag_map.keys(), key=str.lower):
        print(f"  [{tag}] — {len(tag_map[tag])} entry/entries")

    html = generate_page(issue_number, tag_map)

    out_path = "TagIndex.html"
    with open(out_path, "w", encoding="utf-8") as fh:
        fh.write(html)

    print(f"\nOutput written to: {out_path}")


if __name__ == "__main__":
    main()
