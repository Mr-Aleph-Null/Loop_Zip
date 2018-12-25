#!/usr/bin/env bash

#Replace the "file" with your zip file name

pw=$(zipinfo -1 file.zip | cut -d. -f1)
unzip -P "$pw" filr.zip
 
 #Puting it into loop

zipfile="file.zip"
while unzip -Z1 "$zipfile" | head -n1 | grep "\.zip$"; do
    next_zipfile="$(unzip -Z1 "$zipfile" | head -n1)"
    unzip -P "${next_zipfile%.*}" "$zipfile"
    zipfile="$next_zipfile"
done
