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
# 1) Save the header and tail tags:
#
#   a) <?xml ...  ?>
#   b) <schema ... >
#   c) </schema ... >
################################################################################
#
#\param $1  the name (relative path included) of the source file to parse
#           (i.e. "./input/dos.xsd")
#
#\return   creates "./tmp/header.tmp" with the header tags of the
#          source file (see save_header_tags() function)
#
#\return   creates "./tmp/tail.tmp" with the tail tags of the
#          source file (see save_tail_tags() function)
#
# [ Example
#
#     input:  sh remove_tags.sh ./input/uno.xsd 
#
#     output: ./tmp/header.tmp
#             ./tmp/tail.tmp
#
#  End-Example ]
#
################################################################################

#-------------------------------------------------------------------------------
# auxiliar functions
#-------------------------------------------------------------------------------

#\param $1 relative path to an XSD file (i.e. "./input/dos.xsd")
save_tail_tags()
{
    perl -n -e " 
if( (/<\/schema/../>/) )  
{ print; } 
"  $1 ;  
#"  ./input/uno.xsd ;  
}

#-------------------------------------------------------------------------------

#\param $1 relative path to an XSD file (i.e. "./input/dos.xsd")
save_header_tags() 
{
#     perl -n -e " 
# if( (/<\?xml/../\?>/) or (/<schema/../>/) )  
# { print; } 
# "  $1 ;  

perl -n -e " if( (/<\?xml/../\?>/) or (/<schema/../>/) )  { print; } "  $1 ;  

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

if [ ! -f $SRC_FILE ]; then
    echo -e "\n File to parse ($SRC_FILE) not found \n"
    exit 11
fi


# 1) Save the header and tail tags:
save_tail_tags $SRC_FILE > ./tmp/tail.tmp
save_header_tags $SRC_FILE > ./tmp/header.tmp
