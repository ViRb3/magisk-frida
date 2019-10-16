#!/user/bin/env python3
#
# MagiskFrida build process
#
# 1. Checks if project has a tag that matches frida tag
#    Yes -> continue
#    No  -> must tag
# 2. Checks if last commit doesn't have frida tag and is titled 'release'
#    Yes -> must tag
#    No  -> continue
# If tagging, writes new tag to 'NEW_TAG.txt' and builds
# Otherwise, does nothing and builds with placeholder tag
# 3. Deployment will execute only if 'NEW_TAG.txt' is present
#
# NOTE: Requires git
#

import build
import os
import sys
import subprocess

from util import *
import build


def main():
    last_frida_tag = get_last_frida_tag()
    last_project_tag = get_last_project_tag()
    last_commit_tag = get_last_commit_tag()
    new_project_tag = "0"

    if last_frida_tag != strip_revision(last_project_tag) \
        or (last_frida_tag != strip_revision(last_commit_tag)
            and get_commit_message().lower() == "release"):

        new_project_tag = get_next_revision(last_frida_tag)
        print(f"Update needed to {new_project_tag}")

        # for use by deployment
        with open("NEW_TAG.txt", "w") as the_file:
            the_file.write(new_project_tag)
    else:
        print("All good!")

    build.do_build(last_frida_tag, new_project_tag)


if __name__ == "__main__":
    main()
