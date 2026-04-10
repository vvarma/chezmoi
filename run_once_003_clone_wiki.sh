#!/bin/bash -euo pipefail

repo_parent="${HOME}/work/vvarma"
repo_dir="${repo_parent}/wiki"
repo_url="git@github.com:vvarma/wiki.git"

mkdir -p "${repo_parent}"

if [[ -e "${repo_dir}" ]]; then
  echo "Skipping wiki clone because path already exists: ${repo_dir}"
  exit 0
fi

git clone "${repo_url}" "${repo_dir}"
