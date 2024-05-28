#!/usr/bin/env bash
gh repo list --limit 200 --json name,description,url,sshUrl,owner,visibility,isArchived,isFork \
  | jq > ./repos.json
