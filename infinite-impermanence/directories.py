#!/usr/bin/env python3
import json
import logging
import shutil
import sys
from pathlib import Path

log = logging.getLogger("ii-directories")
logging.basicConfig(level=logging.DEBUG)

if len(sys.argv) != 2:
	log.error("Usage: ii-directories <config-path>.")
	sys.exit(1)

with open(sys.argv[1]) as f:
	config = json.loads(f.read())

root = Path("/")

existing = dict()
def mkdirs(path, bound, user, group, mode, isbound=False):
	if bound not in existing and not bound.exists():
		log.debug(f"Bound {bound} doesn't exist: creating it as root.")
		mkdirs(bound, root, "root", "root", 0o755, True)

	if bound == path:
		log.debug(f"Path {path} is its own bound. Ignoring...")
		return

	parents = list(reversed(path.parents))[len(bound.parents) + 1 :] + [path]
	for parent in parents:
		actual = (user, group, mode)
		if parent in existing:
			expected = existing[parent]
			if expected == actual:
				log.debug(f"Path {parent} already handled, skipping...")
				continue
			else:
				fmt = lambda x: (x[0], x[1], f"{x[2]:o}")
				log.error(f"Contradictory permissions for parent {parent}: {fmt(expected)} vs {fmt(actual)}")
				sys.exit(1)
		else:
			existing[parent] = (user, group, mode)

		if not parent.exists():
			log.debug(f"Creating {parent} with mode {mode:o}.")
			parent.mkdir(mode=mode)
		else:
			log.debug(f"Path {parent} already exists. Setting its mode to {mode:o}.")
			parent.chmod(mode=mode)

		log.debug(f"Setting the user ({user}) & group ({group}) for {parent}.")
		shutil.chown(parent, user, group)

directories = sorted(config, key=lambda d: d["path"])
for directory in directories:
	bound = Path(directory["bound"])
	path = Path(directory["path"])

	parents = list(reversed(path.parents))
	additional = parents[len(bound.parents) :]
	if path != bound and (not additional or additional[0] != bound):
		log.error(f"Invalid bound: {bound} is not a prefix of {path}.")
		sys.exit(1)

	mode = int(directory["mode"], 8)
	mkdirs(path, bound, directory["user"], directory["group"], mode)
