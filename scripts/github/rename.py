#!/usr/bin/env nix-shell
#!nix-shell -p python3 -i python3
import json
import os
import subprocess
import tempfile
import shutil

file_path = './repos.json'
general_org = "temporarymoon" # Get it? Because forks involve many trees, which like, form a canopy or whatever... :/
fork_org = "starlitcanopy"
future_name = "prescientmoon"
current_name = "mateiadrielrafael"

with open(file_path, 'r') as file:
    data = json.load(file)

print(f"Parsed {len(data)} repos")

with tempfile.TemporaryDirectory() as temp_dir:
    print(f"Temporary directory: {temp_dir}")
    for repo in data:
        name = repo["name"]
        url = repo["url"]
        org = fork_org if repo['isFork'] else general_org
        fork = f"{org}/{name}"

        os.chdir(temp_dir)

        if repo["isFork"]:
            subprocess.run(f"gh api repos/{current_name}/{name}/transfer -f new_owner={org}", shell=True)
        else:
            subprocess.run(f"gh repo fork {url} --clone --org {org} --default-branch-only", shell=True)
            os.chdir(f"{temp_dir}/{name}")

            # Create the readme if it doesn't exist
            if not os.path.exists("README.md"):
                with open("README.md", 'w') as file:
                    file.write('')

            # Read the existing content of the readme
            with open("README.md", 'r') as file:
                existing_content = file.read()

            future = f"{future_name}/{name}"

            # Add disclaimer at top
            text_to_prepend = f"# 🚧 This repo has been moved to [{future}](https://github.com/{future}) 🚧\n"

            with open("README.md", 'w') as file:
                file.write(text_to_prepend + existing_content)

            # Commit changes
            subprocess.run("git add .", shell=True)
            subprocess.run("git commit -m 'Added movement notice to readme [skip-ci]'", shell=True)
            subprocess.run("git push", shell=True)

            # Fix visibility and archive repo
            visibility = repo["visibility"]
            if visibility != "public":
                subprocess.run(f"gh repo edit {fork} --visibility {visibility}", shell=True)
            subprocess.run(f"gh repo archive {fork} --yes", shell=True)
            shutil.rmtree(f"{temp_dir}/{name}")

        print(f"Done moving to {fork}")
