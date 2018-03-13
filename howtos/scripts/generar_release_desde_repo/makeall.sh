#!/bin/bash

#-----------------------------------------------------------------------------
error_msg()
{
 MSG=$1
 printf "\n\n${RED}COMPILATION ERROR: $MSG${NOCOL}\n"
}

warning_msg()
{
 MSG=$1
 printf "\n\n${YELLOW}WARNING: $MSG${NOCOL}\n"
}

cleanup_compilation()
{
 warning_msg "Cleanup compilation..."
 cd $INIT_COMPIL_DIR
}

#-----------------------------------------------------------------------------

init_compil()
{
 printf "\ninit_compil(). compilation path: %s" $INIT_COMPIL_DIR
 PREV_BINS="../../bin/linux_x86/elproyecto/"
 if [ -d $PREV_BINS ] ; then
     rm -rf $PREV_BINS
 fi

 printf "\n\nrm -rf %s" $PREV_BINS
 rm -rf $PREV_BINS
 STATUS=$?
 if [ $STATUS -ne 0 ]
 then 
     error_msg "init compilation failure "
     cleanup_compilation
     exit 102
 fi
}

#-----------------------------------------------------------------------------

# $1: CURRENT_COMP_DIR
compile_dir()
{
 CURRENT_COMP_DIR=$1

 printf "\n\nCompilation of: \"$CURRENT_COMP_DIR\""

 if [ ! -d $CURRENT_COMP_DIR ] ; then
     error_msg "\"$CURRENT_COMP_DIR\" not found"
     cleanup_compilation
     exit 110
 fi

 cd $CURRENT_COMP_DIR

 printf "\nmake..."


 make 
 STATUS=$?
 if [ $STATUS -ne 0 ]
 then 
     error_msg "\"$CURRENT_COMP_DIR\" compilation failure (make)"
     cleanup_compilation
     exit 111
 fi

 printf "\nmake link..."
 make link 
 STATUS=$?
 if [ $STATUS -ne 0 ]
 then 
     error_msg "\"$CURRENT_COMP_DIR\" linkage failure: (make link) "
     cleanup_compilation
     exit 112
 fi

 cd $INIT_COMPIL_DIR
}


#-----------------------------------------------------------------------------
#-     main    -----------------------------------------------------------------
#-----------------------------------------------------------------------------


INIT_COMPIL_DIR=$PWD

RED='\033[1;31m'
YELLOW='\033[1;33m'
NOCOL='\033[0m'

# 1) remove previous binaries
init_compil

# 2) compiling and linking xs2cpp
compile_dir "$INIT_COMPIL_DIR/xsd2cpp"

# 3) compiling and linking elproyecto
compile_dir $INIT_COMPIL_DIR

# ...


cd $INIT_COMPIL_DIR


printf "\n"
printf "\n... compilation finished"
printf "\n"
printf "\n%s" $PWD
