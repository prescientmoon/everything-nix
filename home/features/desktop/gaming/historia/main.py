#!/usr/bin/env python3
import logging
import sqlite3
import subprocess
import sys
import time

log = logging.getLogger("historia")
logging.basicConfig(level=logging.INFO)


if len(sys.argv) < 4:
  log.error("Usage: historia <db-path> <app-name> <script> [*args]")
  sys.exit(1)

db_file_path, app_name, *args = sys.argv[1:]


# {{{ Database connections
def connect_db():
  try:
    conn = sqlite3.connect(db_file_path)
  except sqlite3.Error as e:
    log.error(f"Error connecting to SQLite database: {e}")
    sys.exit(1)
  return conn


# }}}
# {{{Migrations
migrations = [
  """
  CREATE TABLE timespans (
    app       TEXT NOT NULL,
    start DATETIME NOT NULL,
    end   DATETIME NOT NULL
  );
  PRAGMA user_version=1;
  """
]


def run_migrations():
  with connect_db() as conn:
    user_version = next(conn.execute("PRAGMA user_version"))[0]
    log.info(f"Database version: {user_version}")
    for migration in migrations[user_version:]:
      cur = conn.cursor()
      try:
        log.info(f"Applying migration {user_version}")
        cur.executescript("begin;" + migration)
      except Exception as e:
        log.error(f"Failed migration {user_version}: {e}")
        cur.execute("rollback")
        sys.exit(1)
      else:
        cur.execute("commit")
      user_version += 1


run_migrations()
# }}}

start = int(time.time())

try:
  subprocess.run(args, check=True)
finally:
  end = int(time.time())
  log.info(f"Saving timestamps: {start} -> {end}")

  with connect_db() as conn:
    conn.execute(
      """
      INSERT INTO timespans (app, start, end)
      VALUES (?, ?, ?)
      """,
      (app_name, start, end),
    )
