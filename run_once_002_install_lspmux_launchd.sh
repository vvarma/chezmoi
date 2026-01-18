#!/bin/bash -euo pipefail

if [[ "${OSTYPE}" != darwin* ]]; then
  echo "Skipping lspmux launchd setup because this is not macOS."
  exit 0
fi

if ! command -v lspmux >/dev/null 2>&1; then
  cargo install lspmux
fi

plist_dir="${HOME}/Library/LaunchAgents"
plist_path="${plist_dir}/org.codeberg.p2502.lspmux.plist"
mkdir -p "${plist_dir}"

lspmux_path="${HOME}/.cargo/bin/lspmux"
username="$(whoami)"

cat >"${plist_path}" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>org.codeberg.p2502.lspmux</string>
    <key>ProgramArguments</key>
    <array>
      <string>${lspmux_path}</string>
      <string>server</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
      <key>PATH</key>
      <string>/opt/homebrew/bin:/opt/homebrew/sbin:/usr/bin:/bin:/usr/sbin:/sbin:${HOME}/.cargo/bin</string>
    </dict>
    <key>StandardOutPath</key>
    <string>/tmp/lspmux.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/lspmux.log</string>
    <key>KeepAlive</key>
    <true/>
    <key>RunAtLoad</key>
    <true/>
    <key>LimitLoadToSessionType</key>
    <array>
      <string>Aqua</string>
      <string>Background</string>
      <string>LoginWindow</string>
      <string>StandardIO</string>
      <string>System</string>
    </array>
    <key>UserName</key>
    <string>${username}</string>
  </dict>
</plist>
EOF

launchctl unload "${plist_path}" >/dev/null 2>&1 || true
launchctl load -w "${plist_path}"
launchctl start org.codeberg.p2502.lspmux
