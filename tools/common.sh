ROOT=$(dirname "$BASH_SOURCE")/..

ROOT=$(ruby -e "puts File.expand_path(ARGV[0])" "$ROOT") || {
  echo "Missing 'ruby'" >&2
  exit 1
}
