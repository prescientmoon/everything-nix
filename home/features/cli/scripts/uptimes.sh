print_uptime() {
  local HOST=$1
  local EMOJI=$2

  # -n: do not echo a newline
  echo -n "$EMOJI $HOST: "

  # The output of `uptime` looks like this:
  # `18:40:54  up 1 day  0:51,  0 users,  load average: 0.79, 0.68, 0.69`,
  # so we use awk to trim it down to the parts we care about.
  #
  # For awk:
  # -F: splits the input by a string
  ssh adrielus@$HOST uptime \
    | awk -F "up" '{print $2}' \
    | awk -F " " '{print $1, $2}'
}

echo "Uptimes:"
print_uptime "tethys" "🔥"
print_uptime "lapetus" "⛵"
