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
################################################################################
#
# 1) Remove the header and tail tags of the input file ($1)
#
#   a) <?xml ...  ?>
#   b) <schema ... >
#   c) </schema ... >
################################################################################
#
#\param $1  # the name (relative path included) of the source file to parse
#           # (i.e. "./input/dos.xsd")
#
#\return # creates a new .xsd file in ./tmp with the same content of
#         # the source file but without the XML tags removed in
#         # remove_tags() function
#
# [ Example
#
#     input:  sh remove_tags.sh ./input/uno.xsd 
#
#     output: ./tmp/uno.xsd
#
#  End-Example ]
#
################################################################################

#-------------------------------------------------------------------------------
# auxiliar functions
#-------------------------------------------------------------------------------

#\param $1 relative path to an XSD file (i.e. "./input/dos.xsd")
remove_tags()
{
    perl -n -e " 
unless( (/<\?xml/../\?>/) or (/<schema/../>/) or (/<\/schema/../>/) )  
{ print; } 
"  $1 ;

# perl -n -e " unless( (/<\?xml/../\?>/) or (/<schema/../>/) or (/<\/schema/../>/) )  { print; } "  $1 ;
}


#-------------------------------------------------------------------------------
# main script section
#-------------------------------------------------------------------------------

NumParams=1 # the name (relative path included) of the source file to parse
            # (i.e. "./input/dos.xsd")

if [ $# -ne $NumParams ] ; then
echo "ERROR (BAD FORMAT): $0 RELATIVE_PATH_TO_XSD_FILE"
exit 1
fi

SRC_FILE=$1
SRC_FILENAME_WITH_EXTENSION=${SRC_FILE##*/}
SRC_FILENAME_NO_EXTENSION=${SRC_FILENAME_WITH_EXTENSION%.*}
SRC_FILENAME_EXTENSION=${SRC_FILE##*.}
OUTPUT_FILE="./tmp/$SRC_FILENAME_WITH_EXTENSION"

#test
# echo SRC_FILE: $SRC_FILE
# echo SRC_FILENAME_WITH_EXTENSION: $SRC_FILENAME_WITH_EXTENSION
# echo SRC_FILENAME_NO_EXTENSION: $SRC_FILENAME_NO_EXTENSION
# echo SRC_FILENAME_EXTENSION: $SRC_FILENAME_EXTENSION
# echo OUTPUT_FILE: $OUTPUT_FILE

if [ ! -f $SRC_FILE ]; then
    echo -e "\n File to parse ($SRC_FILE) not found \n"
    exit 11
fi

if [ $SRC_FILENAME_EXTENSION != xsd ]; then
    echo -e "\n Bad file format ($SRC_FILE), a .xsd file is expected \n"
    exit 11
fi


# 2) Remove the duplicate header and tail tags from all the source files:
remove_tags $SRC_FILE > $OUTPUT_FILE

#-------------------------------------------------------------------------------

# >> for file in $(find ./input/ -name *.xsd -type f); do sh remove_tags.sh $file; done
