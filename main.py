#!/user/bin/env python3
#
# MagiskFrida build process
#
# 1. Checks if project has a tag that matches frida tag
#    Yes -> continue
#    No  -> must tag
# 2. Checks if FORCE_RELEASE environment variable is set (GitHub Actions)
#    Yes -> must tag
#    No  -> continue
# If tagging, writes new tag to 'NEW_TAG.txt' and builds
# Otherwise, does nothing and builds with placeholder tag
# 3. Deployment will execute only if 'NEW_TAG.txt' is present
#
# NOTE: Requires git
#

import build
import util
import os


def main():
    last_frida_tag = util.get_last_frida_tag()
    last_project_tag = util.get_last_project_tag()
    new_project_tag = "0"
    
    force_release = os.getenv('FORCE_RELEASE', 'false').lower() == 'true'
    needs_update = last_frida_tag != util.strip_revision(last_project_tag)
    
    if needs_update or force_release:
        new_project_tag = util.get_next_revision(last_frida_tag)
        print(f"Update needed to {new_project_tag}")
        
        if needs_update:
            print(f"Reason: Frida updated from {util.strip_revision(last_project_tag)} to {last_frida_tag}")
        else:
            print("Reason: Force release requested via GitHub Actions")

        # for use by deployment
        with open("NEW_TAG.txt", "w") as the_file:
            the_file.write(new_project_tag)
    else:
        print("All good!")

    build.do_build(last_frida_tag, new_project_tag)


if __name__ == "__main__":
    main()
