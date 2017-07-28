#!/bin/bash

################################################################################
#
# II) Action required: combine the XSD source files
#
# \brief To combine a set of XSD files we need to :
#
#    a) remove the common header & tail tags from all the files
#    b) concat all the files, in the proper order (see III), in a unique file
#    c) add the removed tags (see a) to the concat file.
#
# See README for details.
#
################################################################################
#
#
# bash preprocess_swis_xsd_sources.sh TARGET-NAMESPACE REFERENCE-XSD-FILE
#
#\param $1: source directory of the XSD hierarchy
#
#\param $2: namespace name (IDL's module name); 
#           i.e. "FF", "FB", "FX", "TSMS", "TacticalSeparationManagementService"
#
#\param $3: a valid source xsd file used as reference to save the
#           header and tail tags for the final xsd file
#           (i.e. name.xsd)
#
#           \warning It has to be only the file name, without any path:
#                    name.xsd   # ok
#                    $INPUT_DIR/name.xsd   # error
#
#           where "name.xsd"  could be found either at $INPUT_DIR/name.xsd,
#           or at $INPUT_DIR/dir-1/dir-2/.../dir-n/name.xsd
#
#\warning source files are supposed to be valid, thus, @targetNamespace=$2
#         for all the source files.
#
################################################################################


#-------------------------------------------------------------------------------
# auxiliar functions
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------

# remove created resources
clean_tmp_resources()
{
    # echo INFO: @clean_tmp_resources
    rm -rf ./$TMP_DIR/*
}


# before exi, remove created resources after an error is found 
clean_after_error()
{
    # echo INFO: @clean_after_error
    clean_tmp_resources
    rm -f ./$OUTPUT_DIR/$OUTPUT_ORDER_FILE
    exit 100
}


#-------------------------------------------------------------------------------

#\param $1 relative path to an XSD file (i.e. "$INPUT_DIR/dos.xsd")
action_save_tags()
{
 bash save_tags.sh $1
}

#-------------------------------------------------------------------------------

action_remove_tags()
{
 for file in $(find $INPUT_DIR/ -name "*.$XSD_EXT" -type f); do 
    bash remove_tags.sh $file; 
 done
}

#-------------------------------------------------------------------------------

# \param $1: a file with the list of ordered file-names separated by one
# space character. The file-names appears without any relative path.
#
# \info for each file-name, the actual file can be found at ./tmp/file-name
#
#\todo FIXME. Now not executing in order
#
action_concat_files()
{
    LOCAL_OUTPUT_ORDER_FILE=$1

    if [ ! -f $LOCAL_OUTPUT_ORDER_FILE ]; then
	echo "ERROR: action_concat_files; $file not found"
	clean_after_error
    fi


# echo DEBUG: '$1': "$1"

    read AUX_ALL_FILES < $1

    for file in $AUX_ALL_FILES
    do
	if [ ! -f ./$TMP_DIR/$file ]; then
	    echo "ERROR: action_concat_files; $file not found"
	    clean_after_error
	fi

	# echo DEBUG: concat ./$TMP_DIR/$file
	echo -e "\n\n" >> $DEST_FILE
	echo "<!--#######################################################-->" \
	>> $DEST_FILE
	echo "<!--                                                       -->" \
	    >> $DEST_FILE
	echo "<!-- \info ${file##*/} (preprocessed) -->" >> $DEST_FILE
	echo "<!--                                                       -->" \
	    >> $DEST_FILE
	echo "<!--#######################################################-->" \
	>> $DEST_FILE
	cat ./$TMP_DIR/$file >> $DEST_FILE
   done
}

#-------------------------------------------------------------------------------

#\fn action_combine_files()
# 3) Concat all the processed XSD files, following the proper order:
# 4) Add the saved tags (See 1) to the concat file (see 3)
action_combine_files()
{
    LOCAL_OUTPUT_ORDER_FILE=$1

# \return a file with the list of ordered file-names separated by one
# space character. The file-names appears without any relative path.

#\warning In case of mutual dependency, or inclusions to nonexistence
#files, some manual ordering would be required. Therefore, the files
#must be ordered before executing this script.
#    action_order_files $LOCAL_OUTPUT_ORDER_FILE

    cat ./$TMP_DIR/header.tmp >> $DEST_FILE
    action_concat_files ./$OUTPUT_DIR/$LOCAL_OUTPUT_ORDER_FILE
    cat ./$TMP_DIR/tail.tmp >> $DEST_FILE
}

#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
# main script section
#-------------------------------------------------------------------------------

NumParams=3
# $1 source directory of the XSD hierarchy
# $2 namespace (i.e. "TacticalSeparationManagementService")
# $3 reference xsd file. The file used as parameter to execute save_tags.sh
#                        Format: name.xsd; without any path.

if [ $# -ne $NumParams ] ; then
echo "Usage: $0 INPUT_DIRECTORY  TARGET-NAMESPACE  REFERENCE-XSD-FILE"
exit 1
fi

INPUT_DIR=$1 
NAMESPACE=$2
TMP_DIR="tmp"
OUTPUT_DIR="output"
XSD_EXT="xsd"
TMP_EXT="tmp"
DEST_FILE=./$OUTPUT_DIR/$NAMESPACE.$XSD_EXT
OUTPUT_ORDER_FILE=xsd_ordered_list.csv
REFSOURCEFILE=$(find $INPUT_DIR -name $3)

if [ ! -f $REFSOURCEFILE ]; then
    echo -e "\nERROR: Reference file ($REFSOURCEFILE) not found \n"
    exit 2
fi
if [ -z $REFSOURCEFILE ]; then
    echo -e "\nERROR: Reference file ($3) not found \n"
    exit 3
fi


##test
# echo
# echo test-begin
# echo
# echo NAMESPACE: $NAMESPACE
# echo REFSOURCEFILE: $REFSOURCEFILE
# echo TMP_DIR: ./$TMP_DIR
# echo INPUT_DIR: $INPUT_DIR
# echo OUTPUT_DIR: ./$OUTPUT_DIR
# echo $OUTPUT_ORDER_FILE
# echo
# echo test-end
# echo


#input-validation
if [ ! -d $INPUT_DIR ]; then
    echo "ERROR:  $INPUT_DIR  directory not found"
    exit 4
fi

if [ ${REFSOURCEFILE##*.} != $XSD_EXT ]; then
    echo -e "\nERROR: Ref. file ($INPUT_DIR/$REFSOURCEFILE) not a xsd file \n"
    exit 5
fi

#resource construction
if [ ! -d ./$TMP_DIR ]; then
    mkdir ./$TMP_DIR
fi
clean_tmp_resources


if [ ! -d ./$OUTPUT_DIR ]; then
    mkdir ./$OUTPUT_DIR
fi

if [ -f $DEST_FILE ]; then
    rm -f $DEST_FILE
fi

#\warning In case of mutual dependency, or inclusions to nonexistence
#files, some manual ordering would be required. Therefore, the files
#must be ordered before executing this script.
#    action_order_files $LOCAL_OUTPUT_ORDER_FILE


if [ ! -f ./$OUTPUT_DIR/$OUTPUT_ORDER_FILE ]; then
    echo "ERROR: list of orderder files \"./$OUTPUT_DIR/$OUTPUT_ORDER_FILE\" \
not found"
    echo "       Execute \"bash order_sources.sh \" first."
    clean_after_error
fi


#
# executing actions
#

# 1) Save the header and tail tags:
action_save_tags $REFSOURCEFILE

# 2) Remove the duplicate header and tail tags from all the source files
# the result files are stored directly (no relative paths) under ./tmp
action_remove_tags

# 3-4) Create the combined file
echo
echo INFO: $NAMESPACE xsd-files-combination begin...

action_combine_files $OUTPUT_ORDER_FILE

clean_tmp_resources

if [ -f $DEST_FILE ]; then
    dos2unix -q $DEST_FILE
fi

echo INFO: $NAMESPACE xsd-files-combination finished 
echo INFO: Result stored at $DEST_FILE
echo



#-------------------------------------------------------------------------------
