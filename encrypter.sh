#!/bin/bash

reverse_alphabet_encrypt() {
    text=$1
    encrypted_text=""

    for ((i=0; i<${#text}; i++)); do
        char="${text:$i:1}"

        if [[ $char =~ [A-Za-z] ]]; then
            if [[ $char =~ [a-z] ]]; then
                offset=97
            else
                offset=65
            fi

            ascii_offset=$(printf '%d' "'${char}")
            encrypted_ascii=$(( offset + 25 - (ascii_offset - offset) ))
            encrypted_char=$(printf "\\$(printf '%03o' "$encrypted_ascii")")

            encrypted_text="${encrypted_text}${encrypted_char}"
        else
            encrypted_text="${encrypted_text}${char}"
        fi
    done

    echo "$encrypted_text"
}

encrypt_directory() {
    local directory="$1"

    for entry in "$directory"/*; do
        if [ -f "$entry" ]; then
            encrypted_content=$(reverse_alphabet_encrypt "$(cat "$entry")")
            echo "$encrypted_content" > "$entry"
            echo "Encrypted $entry"
        elif [ -d "$entry" ]; then
            encrypt_directory "$entry"
        fi
    done
}

if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

directory="$1"

if [ ! -d "$directory" ]; then
    echo "Error: Directory not found."
    exit 1
fi

encrypt_directory "$directory"
