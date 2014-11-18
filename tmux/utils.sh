join_str() {
  local sep=$1
  local seplen=${#sep}
  while read l; do echo -n "$l$sep"; done \
    | sed -E "s/.{$seplen}$//"
}

truncate_str() {
  [ $# -eq 2 ] || return 1
  local maxlen=$1 str=$2
  sed -E 's/^(.{'$maxlen'}).*/\1/; s/ *$//' <<< "$str"
}
