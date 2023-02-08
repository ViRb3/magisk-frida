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
# If tagging, writes new tag to NEW_TAG and builds
# Otherwise, does nothing and builds with placeholder tag
# 3. Deployment will execute only if NEW_TAG is present
#
# NOTE: Requires git
#

import build
import util
import os


def main():
    last_frida_tag = util.get_last_frida_tag()
    last_project_tag = util.get_last_project_tag()
    last_commit_tag = util.get_last_commit_tag()
    new_project_tag = "0"

    if last_frida_tag != util.strip_revision(last_project_tag) \
        or (last_frida_tag != util.strip_revision(last_commit_tag)
            and util.get_commit_message().lower() == "release"):

        new_project_tag = util.get_next_revision(last_frida_tag)
        print(f"Update needed to {new_project_tag}")

        # Assign our environmental variables so we can write update.json
        env_file = os.getenv("GITHUB_ENV")
        env_contents = f"""
NEW_TAG={new_project_tag}
VERSION_CODE={new_project_tag.replace(".", "").replace("-", "")}
THIS_REPOSITORY={os.getenv("GITHUB_REPOSITORY") if os.getenv("GITHUB_REPOSITORY") else ""}
"""
        
        with open(env_file, "a") as env:
            env.write(env_contents)
    else:
        print("All good!")
        
    build.do_build(last_frida_tag, new_project_tag)


if __name__ == "__main__":
    main()
