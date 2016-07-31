#!/bin/bash

help="FORMAT: $0 TYPE FILE [FILE*]. This scripts shows the ocurrences of TYPE in the list of FILE"s
error_msg=$help

tia_ns="TIA_NAMESPACE::"
##### verifying input correction #####

 if [ "$#" -lt 2 ]
 then 
     echo $error_msg
     exit
 fi

##### taking paramenters #####

#storing the file to use only the files from this point.
type=$1
shift

#replace operation
for file in "$@"; do
    if  [ -f "$file" ] && $(grep -ql $type $file); then
	    echo Replacing \"$type\" in  \"$file\" =  $tia_ns$type
#	    sed 's/'$type'/'$tia_ns$type'/g' $file
	    sed  -i  's/'$type'/'$tia_ns$type'/g' $file
    fi
done

echo replace finished
