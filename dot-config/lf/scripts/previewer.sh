#!/usr/bin/env bash

draw() {
  kitty +kitten icat --silent --stdin no --transfer-mode file --place "${w}x${h}@${x}x${y}" "${1}" </dev/null >/dev/tty

  if [[ $(file -Lb --mime-type "${1}") == "image/jpeg" && ${cleanup} == 1 ]]; then
    rm "${1}"
  fi

  exit 1
}

file="$1"
w="$2"
h="$3"
x="$4"
y="$5"

cleanup=0

case "$(file -Lb --mime-type "$file")" in
image/*)
  draw "$file"
  ;;
application/pdf)
  output="${file// /_}"
  output=$(basename "${output%.*}")
  output="$HOME/tmp/$output"
  if ! pdftoppm -f 1 -l 1 \
    -scale-to-x 1920 \
    -scale-to-y -1 \
    -singlefile \
    -jpeg -tiffcompression jpeg \
    -- "${file}" "${output}"; then
    echo "Error converting PDF to JPEG" >&1
    exit 1
  fi
  cleanup=1
  draw "${output}.jpg"
  ;;
video/*)
  # vidthumb is from here:
  # https://raw.githubusercontent.com/duganchen/kitty-pistol-previewer/main/vidthumb
  draw "$(vidthumb "$file")"
  ;;
esac

bat "$file"
