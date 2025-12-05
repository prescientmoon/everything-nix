#!/usr/bin/env python
import sqlite3
import json
import sys
import os

if len(sys.argv) != 2:
    print("Usage: patch-db <db_file>")
    sys.exit(1)

db_file_path = sys.argv[1]

try:
    conn = sqlite3.connect(db_file_path)
    cursor = conn.cursor()
except sqlite3.Error as e:
    print(f"Error connecting to SQLite database: {e}", file=sys.stderr)
    sys.exit(1)

# Patch Hikaritsu's stats
cursor.execute(
    f"""
    UPDATE character
    SET 
        frag30=666,
        prog30=666,
        overdrive30=666
    WHERE name='hikari&tairitsu(reunion)'
    """
)

# Patch Lagrange's stats
cursor.execute(
    f"""
    UPDATE character
    SET 
        frag30=727,
        prog30=727,
        overdrive30=727,
        max_level=30,
        is_uncapped=1
    WHERE name='lagrange(aria)'
    """
)

conn.commit()
conn.close()

print("Database updated successfully.")
