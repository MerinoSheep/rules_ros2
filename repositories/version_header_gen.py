"""Render a version.h header for a ROS package; see version_header.bzl."""
import argparse
import sys
from xml.etree import ElementTree


def main(argv):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--package-xml', required=True)
    parser.add_argument('--template', required=True)
    parser.add_argument(
        '--prefix',
        required=True,
        help='Macro prefix, e.g. RCLCPP or AMENT_INDEX_CPP.',
    )
    parser.add_argument('--output', required=True)
    args = parser.parse_args(argv)

    version = ElementTree.parse(args.package_xml).getroot().findtext('version')
    if version is None:
        sys.exit(f'no <version> tag in {args.package_xml}')
    parts = version.strip().split('.')
    if len(parts) != 3:
        sys.exit(
            f'expected MAJOR.MINOR.PATCH in {args.package_xml}, got {version!r}'
        )
    major, minor, patch = parts

    with open(args.template) as f:
        text = f.read()
    substitutions = {
        '@PREFIX@': args.prefix,
        '@VERSION@': version,
        '@MAJOR@': major,
        '@MINOR@': minor,
        '@PATCH@': patch,
    }
    for key, value in substitutions.items():
        text = text.replace(key, value)

    with open(args.output, 'w') as f:
        f.write(text)


if __name__ == '__main__':
    main(sys.argv[1:])
