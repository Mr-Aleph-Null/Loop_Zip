#!/usr/bin/env bash
echo "Make sure that you have placed the Wordlist and ZIP file in the same directory as the script file. Note that the brute force option will just be numeric and very simple"
echo "Do you want to brute-force? 'No' for wordlits [Y,N]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        echo "What is the file name?"
        read file
        zipfile="$file"
        pw=$(fcrackzip -u -l 1-6 -c '1' "$file"| sed -n -e 's/^.*pw == //p')
        unzip -P "$pw" "$file"

        while fcrackzip -u -l 1-6 -c '1' "$zipfile"| sed -n -e 's/^.*pw == //p'; do
              pw2=$(fcrackzip -u -l 1-6 -c '1' "$zipfile"| sed -n -e 's/^.*pw == //p')
              next_zipfile="$(unzip -Z1 "$zipfile" | head -n1)"
              unzip -P "${pw2%.*}" "$zipfile"
              zipfile="$next_zipfile"
     
    done
else
        echo "What is the file name?"
        read file
        echo "Incert the word list name (e.g rockyou.txt)"
        read location

        zipfile="$file"
        pw=$(fcrackzip -v -u -D -p "$location" "$file"| sed -n -e 's/^.*pw == //p')
        unzip -P "$pw" "$file"

        while fcrackzip -u -D -p "$location"  "$zipfile"| sed -n -e 's/^.*pw == //p'; do
              pw2=$(fcrackzip -v -u -D -p "$location" "$zipfile"| sed -n -e 's/^.*pw == //p')
              next_zipfile="$(unzip -Z1 "$zipfile" | head -n1)"
              unzip -P "${pw2%.*}" "$zipfile"
              zipfile="$next_zipfile"
     
    done
fi
