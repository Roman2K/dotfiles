function gist
  set -l d $OPT/gist
  ruby -I $d/lib $d/bin/gist $argv
end

