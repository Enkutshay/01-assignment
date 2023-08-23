#!/bin/bash

reverse_alphabet_decrypt() {
    text=$1
    decrypted_text=""

    for ((i=0; i<${#text}; i++)); do
        char="${text:$i:1}"

        if [[ $char =~ [A-Za-z] ]]; then
            if [[ $char =~ [a-z] ]]; then
                offset=97
            else
                offset=65
            fi

            ascii_offset=$(printf '%d' "'${char}")
            decrypted_ascii=$(( offset + 25 - (ascii_offset - offset) ))
            decrypted_char=$(printf "\\$(printf '%03o' "$decrypted_ascii")")

            decrypted_text="${decrypted_text}${decrypted_char}"
        else
            decrypted_text="${decrypted_text}${char}"
        fi
    done

    echo "$decrypted_text"
}

decrypt_directory() {
    local directory="$1"

    for entry in "$directory"/*; do
        if [ -f "$entry" ]; then
            decrypted_content=$(reverse_alphabet_decrypt "$(cat "$entry")")
            echo "$decrypted_content" > "$entry"
            echo "Dcerypted $entry"
        elif [ -d "$entry" ]; then
            decrypt_directory "$entry"
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

decrypt_directory "$directory"
