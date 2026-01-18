#!/usr/bin/env python3
import logging
import sys
import requests
import sopsy

log = logging.getLogger("migadux")
logging.basicConfig(level=logging.INFO)


# {{{ Get command line arguments
if len(sys.argv) < 4:
  log.error("Usage: migadux <dry-run|sync> <domain> <sops-file>")
  sys.exit(1)

(command, domain, sopsFile) = sys.argv[1:]

if command not in ["dry-run", "sync"]:
  log.error(f"Invalid command: {command}")
  sys.exit(1)
# }}}
# {{{ Secret gathering
secrets = sopsy.Sops(sopsFile)


def getSecret(name):
  secret = secrets.get(name)
  if secret is None:
    log.error(f"{name} secret is missing")
    sys.exit(1)
  return secret


username = getSecret("MIGADU_USERNAME")
apiKey = getSecret("MIGADU_API_KEY")
aliasList = getSecret("MIGADU_ALIAS_LIST").strip()
# }}}
# {{{ Local alias collection
localAliases = []
for line in aliasList.split("\n"):
  words = []
  for word in line.split(" "):
    if word != "":
      words.append(word)

  if len(words) != 2:
    log.error(f'Line does not contain a from-to pair: "{line}"')
    sys.exit(1)

  localAliases.append(tuple(words))


def listGetAlias(name):
  for source, dest in localAliases:
    if source == name:
      return f"{dest}@{domain}"


# }}}
# {{{ Remote alias management
res = requests.get(
  f"https://api.migadu.com/v1/domains/{domain}/aliases", auth=(username, apiKey)
)
res.raise_for_status()
res = res.json()


def migaduGetAlias(name):
  for alias in res["address_aliases"]:
    if alias["local_part"] == name:
      # NOTE: we don't currently support multiple destinations
      return alias["destinations"][0]


def migaduCreateAlias(source, dest):
  res = requests.post(
    f"https://api.migadu.com/v1/domains/{domain}/aliases",
    auth=(username, apiKey),
    data={"local_part": source, "destinations": dest},
  )
  res.raise_for_status()


def migaduDeleteAlias(source):
  res = requests.delete(
    f"https://api.migadu.com/v1/domains/{domain}/aliases/{source}",
    auth=(username, apiKey),
  )
  res.raise_for_status()


def migaduUpdateAlias(source, dest):
  res = requests.put(
    f"https://api.migadu.com/v1/domains/{domain}/aliases/{source}",
    auth=(username, apiKey),
    data={"destinations": dest},
  )
  res.raise_for_status()


# }}}
# {{{ Alias list merging
allAliases = set()

for alias in res["address_aliases"]:
  allAliases.add(alias["local_part"])
for source, dest in localAliases:
  if f"{dest}@{domain}" != listGetAlias(source):
    log.error(f"Duplicate alias: {dest}")
    sys.exit(1)
  allAliases.add(source)
# }}}
# {{{ Perform the diff
changes = 0
for alias in allAliases:
  localDest = listGetAlias(alias)
  remoteDest = migaduGetAlias(alias)
  assert localDest is not None or remoteDest is not None  # Sanity check

  if localDest is None:
    changes += 1
    print(f"Remove: {alias} -> {remoteDest}")
    if command == "sync":
      migaduDeleteAlias(alias)
  elif remoteDest is None:
    changes += 1
    print(f"Add: {alias} -> {localDest}")
    if command == "sync":
      migaduCreateAlias(alias, localDest)
  elif localDest != remoteDest:
    changes += 1
    print(f"Change {alias}: {remoteDest} -> {localDest}")
    if command == "sync":
      migaduUpdateAlias(alias, localDest)

if changes == 0:
  print("No changes found")
elif changes == 1:
  print("1 change found")
else:
  print(f"{changes} changes found")
# }}}
