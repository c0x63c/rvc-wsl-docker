#!/bin/bash

set -Eeuo pipefail
declare -A MOUNTS

# mount folders
MOUNTS["/RVC-WebUI/logs"]="/logs"

for to_path in "${!MOUNTS[@]}"; do
  set -Eeuo pipefail
  from_path="${MOUNTS[${to_path}]}"
  if [ ! -f "$from_path" ]; then
    mkdir -vp "$from_path"
  fi
  if [ -d "$to_path" ]; then
    to_path_file="${to_path}/*"
    ls $to_path_file >/dev/null 2>&1 
    if [ $? -eq 0 ]; then 
      to_path_file="${to_path}/*"
      cp -f -p -r $to_path_file $from_path
    fi
  fi 
  rm -rf "${to_path}"
  mkdir -vp "$(dirname "${to_path}")"
  ln -sT "${from_path}" "${to_path}"
  echo Mounted $(basename "${from_path}")
done

exec "$@"
