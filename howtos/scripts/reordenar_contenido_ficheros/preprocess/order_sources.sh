#!/bin/bash


# bash order_sources.sh INPUT_DIRECTORY

# \return a file with the list of ordered file-names separated by one
# space character. The file-names appears without any relative path.



#-------------------------------------------------------------------------------
# auxiliar functions
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
# \return a file with the list of ordered file-names separated by one
# space character. The file-names appears without any relative path.
#
# \input $1: input directory (path to the source files)
#
# \input $2: OUTPUT_ORDER_FILE
#
action_order_files()
{
echo INFO: action_order_files $1 $2

## begin-tsort ##

# All xsd files under the path
findList=($(find $1 -name "*.xsd"))

if [ ${#findList[@]} -eq 0 ] ; then
 echo "ERROR: none xsd files found at \"$1\""
 exit 11
fi


sortList=()
# Iterate over findList
for item in "${findList[@]}"; do
	# Get the list of included files
	files=$(echo	"setns s=http://www.w3.org/2001/XMLSchema
			cat /s:schema/s:include[@schemaLocation]" | xmllint --shell $item | grep xsd | cut -d '"' -f 2 | rev | cut -d '/' -f 1 | rev)
	# For each file
	for file in ${files[@]}; do
		# Get its path relative to $1
		f=$(find $1 -name "$file")
		# If file exists, make a pair
		if [[ $f ]]; then
			sortList+=($f)
			sortList+=($item)
		# If file does not exist, warn it
		else	
			echo "WARN: $file does not exist"
		fi
	done
done


# Files neither include not included
excludedlist=()
for i in "${findList[@]}"; do
	skip=
	for j in "${sortList[@]}"; do
		[[ $i == $j ]] && { skip=1; break; }
	done
	[[ -n $skip ]] || excludedList+=("$i")
done

# Print the list without include tags and not included
#echo DEBUG: 1: print the list of files that neither include nor are included
if [ -n "$excludedList" ]; then
   printf -v aux_indi_result '%s\n' "${excludedList[@]}"
fi
#echo DEBUG: aux_indi_result = $aux_indi_result

# Print the ordered list
#echo DEBUG: 2: print the inclusion list: included-files ... call-include-files
printf -v aux_tsort_result '%s\n' "$(echo "${sortList[@]}" | tsort)"
#echo DEBUG: aux_tsort_result = $aux_tsort_result


# remove paths from the name:
aux_total_result=$aux_indi_result
aux_total_result+=$aux_tsort_result
for item in ${aux_total_result}
do
#    echo DEBUG: $item
    aux_total_result_nopaths+=${item##*/}' '
done

#echo DEBUG: aux_total_result_nopaths: $aux_total_result_nopaths
#echo PWD: $PWD
echo $aux_total_result_nopaths> ./$OUTPUT_DIR/$2
}


#-------------------------------------------------------------------------------
# main script section
#-------------------------------------------------------------------------------

NumParams=1 
INPUT_DIR=$1 # source directory of the XSD hierarchy

# 1) input validation

if [ $# -ne $NumParams ] ; then
    echo -e "\n"
    echo "Usage: $0 INPUT_DIRECTORY"
    echo -e "\n"
    exit 1
fi

if [ ! -d $INPUT_DIR ]; then
    echo -e "\n"
    echo "ERROR: Input directory (\"$INPUT_DIR\") not found."
    echo -e "\n"
    exit 3
fi


# 2) resource construction

# if [ $# -eq 1 ] ; then
#     OUTPUT_ORDER_FILE=xsd_ordered_list.csv
# else
#     OUTPUT_ORDER_FILE=$2
# fi
OUTPUT_ORDER_FILE=xsd_ordered_list.csv
OUTPUT_DIR="output"
XSD_EXT="xsd"
TMP_EXT="tmp"
TMP_ORDER_FILE=$OUTPUT_ORDER_FILE.tmp

if [ ! -d ./$OUTPUT_DIR ]; then
    mkdir ./$OUTPUT_DIR
fi

if [ -f ./output/$OUTPUT_ORDER_FILE ] ; then
    rm ./output/$OUTPUT_ORDER_FILE
fi

echo
echo INFO: file-order begins ...

action_order_files $INPUT_DIR $OUTPUT_ORDER_FILE

echo INFO: $NAMESPACE file-order finished.
echo INFO: Result stored at \"./$OUTPUT_DIR/$OUTPUT_ORDER_FILE\"
echo
