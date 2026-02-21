"""
https://realpython.com/python-xml-parser/
"""

import json
import pathlib
from xml.etree import ElementTree

HERE = pathlib.Path(__file__).parent
XML_PATH = pathlib.Path(
    "D:/Databases/Stack Overflow"
)  # TODO: Parameterise on this


def parse_xml_to_jsonl(
    xml_file: pathlib.Path,
    jsonl_file: pathlib.Path,
) -> None:
    """
    Parse an XML file and write its contents to a JSON Lines file.
    """

    print(f"Parsing {xml_file.name}...")
    document = ElementTree.parse(xml_file)  # noqa: S314
    with open(jsonl_file, "w+") as f:
        f.writelines(
            json.dumps(child.attrib) + "\n" for child in document.getroot()
        )


def main() -> None:
    """
    Parse the XML files into JSON.

    This takes **forever**.
    """
    paths = [
        (XML_PATH / "Badges.xml", HERE / "badges.jsonl"),
        (XML_PATH / "Comments.xml", HERE / "comments.jsonl"),
        (XML_PATH / "PostLinks.xml", HERE / "post_links.jsonl"),
        (XML_PATH / "Posts.xml", HERE / "posts.jsonl"),
        (XML_PATH / "Tags.xml", HERE / "tags.jsonl"),
        (XML_PATH / "Users.xml", HERE / "users.jsonl"),
        (XML_PATH / "Votes.xml", HERE / "votes.jsonl"),
    ]
    for xml_file, jsonl_file in paths:
        parse_xml_to_jsonl(xml_file, jsonl_file)


if __name__ == "__main__":
    main()
