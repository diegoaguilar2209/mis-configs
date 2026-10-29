#!/usr/bin/env bash
# Copy stdin to the system clipboard. Used by the copy-mode bindings in tmux.conf (y, Enter, Y, D, A, C-j).
# WSL: Windows clipboard (UTF-8 safe). Linux: wl-copy or xclip. macOS: pbcopy. Otherwise: OSC 52 via the terminal.
set -u
buf=$(cat)

if command -v clip.exe >/dev/null 2>&1; then
  if command -v iconv >/dev/null 2>&1; then
    printf '%s' "$buf" | iconv -f utf-8 -t utf-16le | clip.exe
  else
    printf '%s' "$buf" | clip.exe
  fi
elif [[ -n "${WAYLAND_DISPLAY:-}" ]] && command -v wl-copy >/dev/null 2>&1; then
  printf '%s' "$buf" | wl-copy
elif [[ -n "${DISPLAY:-}" ]] && command -v xclip >/dev/null 2>&1; then
  printf '%s' "$buf" | xclip -selection clipboard
elif command -v pbcopy >/dev/null 2>&1; then
  printf '%s' "$buf" | pbcopy
else
  # OSC 52: the terminal (Windows Terminal, iTerm2, WezTerm...) puts it on the clipboard, also over SSH
  b64=$(printf '%s' "$buf" | base64 | tr -d '\n')
  tty=$(tmux display-message -p '#{client_tty}' 2>/dev/null || echo /dev/tty)
  printf '\033]52;c;%s\a' "$b64" > "$tty"
fi
