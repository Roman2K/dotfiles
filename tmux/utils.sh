function join_str() {
  sep=$1
  seplen=${#sep}
  while read l
  do
    echo -n "$l$sep"
  done | sed -E "s/.{$seplen}$//"
}

function truncate_str() {
  maxlen=$1
  str=$2
  [ -n "$maxlen" -a -n "$str" ] || return 1
  if [ ${#str} -gt $maxlen ]
  then
    str=$(sed -E 's/^(.{'$maxlen'}).*/\1/' <<< "$str")
    str=$(sed -e 's/ *$//' <<< "$str")
  fi
  echo "$str"
}
