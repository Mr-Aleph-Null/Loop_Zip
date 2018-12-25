#!/usr/bin/env bash
echo "Make sure that you have placed the Wordlist and ZIP file in the same directory as the script file. Note that the brute force option will just be numeric and very simple"
echo "Do you want to brute-force? 'No' for wordlits, 'F' for the password being the file name [Y , N, F]"
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
elif [[ $input == "F" || $input == "f" ]]; then
         echo "What is the file name?"
         read file
         pw=$(zipinfo -1 "$file" | cut -d. -f1)
         unzip -P "$pw" "$file"
         zipfile="$file"
    
         while unzip -Z1 "$zipfile" | head -n1 | grep "\.zip$"; do
              next_zipfile="$(unzip -Z1 "$zipfile" | head -n1)"
              unzip -P "${next_zipfile%.*}" "$zipfile"
              zipfile="$next_zipfile"
    done

else
        echo "What is the file name?"
        read file
        echo "insert the wordlist location"
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
