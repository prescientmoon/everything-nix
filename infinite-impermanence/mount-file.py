#!/usr/bin/env python3
import logging
import sys
import subprocess
from pathlib import Path

log = logging.getLogger("ii-files")
logging.basicConfig(level=logging.DEBUG)

if len(sys.argv) != 4:
	log.error("Usage: ii-files <source> <mount-point> <mode>.")
	sys.exit(1)
source, target, mode = *map(Path, sys.argv[1:3]), int(sys.argv[3], 8)

if target.is_symlink() and target.resolve() == source:
	log.info(f"{target} already links to {source}, ignoring.")
elif target.is_mount():
	log.info(f"Mount already exists at {target}, ignoring.")
elif target.exists():
	log.error(f"A file already exists at {target}.")
	sys.exit(1)
elif source.exists():
	log.debug(f"Mounting {source} at {target}.")
	target.touch(mode=mode)
	subprocess.run(args=["mount", "-o", "bind", source, target], check=True)
else:
	log.debug(f"Linking to {source} at {target}.")
	target.symlink_to(source)
