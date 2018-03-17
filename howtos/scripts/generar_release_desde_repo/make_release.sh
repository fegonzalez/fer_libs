#!/bin/bash

# Automatic generation of a PROJECT_XXX release from the repository content



##############################################################################
# global vars
##############################################################################

INIT_DIR=$PWD
REPO_PATH="https://XXXsvn.YYY.es/PATH_RAMA"
REPO_PROJECT_XXX_VERSION="NAME_RAMA"
PROJECT_XXX_DIR="repo_src"
PROJECT_XXX_CODE_DIR="$PROJECT_XXX_DIR/C++/src/project"
PROJECT_XXX_CONFIG_DIR="$PROJECT_XXX_DIR/CONFIG/src/project"
MAKEALL_SCRIPT="makeall.sh"
RELEASE_DIR="release_project"
TMP_DIR="$INIT_DIR/TMP"
SOMEID="S2020"
DEFAULT_INSTALL_DIR_NAME_PREFIX="version_PROJECT_XXX_"
DEFAULT_INSTALL_DIR_NAME_PREFIX+=$SOMEID
DEFAULT_INSTALL_DIR_NAME_PREFIX+="_"
INSTALL_DIR_NAME_PREFIX=$DEFAULT_INSTALL_DIR_NAME_PREFIX

RED='\033[1;31m'
YELLOW='\033[1;33m'
NOCOL='\033[0m'

# printf "\nVARS: "
# printf "\nINIT_DIR: %s" $INIT_DIR
# printf "\nDOWNLOADING REPO: %s" "svn checkout $REPO_PATH/$REPO_PROJECT_XXX_VERSION $PROJECT_XXX_DIR"
# printf "\nPROJECT_XXX_DIR: %s" $PROJECT_XXX_DIR
# printf "\nPROJECT_XXX_CODE_DIR: %s" $PROJECT_XXX_CODE_DIR
# printf "\nPROJECT_XXX_CONFIG_DIR: %s" $PROJECT_XXX_CONFIG_DIR
# printf "\nMAKEALL_SCRIPT: %s" $MAKEALL_SCRIPT
# printf "\nRELEASE_DIR: %s" $RELEASE_DIR
# printf "\nTMP_DIR: %s" $TMP_DIR
# printf "\nSOMEID: %s" $SOMEID
# printf "\nINSTALL_DIR_NAME_PREFIX: %s" $INSTALL_DIR_NAME_PREFIX


printf "\n\n\n"


##############################################################################
# aux_functions
##############################################################################

error_msg()
{
 MSG=$1
 printf "\n\n${RED}ERROR: $MSG${NOCOL}\n"
}

warning_msg()
{
 MSG=$1
 printf "\n\n${YELLOW}WARNING: $MSG${NOCOL}\n"
}

#-----------------------------------------------------------------------------

cleanup_releasedir()
{
 CURRENT_DIR=$TMP_DIR
 if [ -d $CURRENT_DIR/$RELEASE_DIR ] ; then
     printf "\nrm -rf $CURRENT_DIR/$RELEASE_DIR"
     rm -rf $CURRENT_DIR/$RELEASE_DIR
 fi
}


cleanup_project_dir()
{
 CURRENT_DIR=$TMP_DIR
 if [ -d $CURRENT_DIR/$PROJECT_XXX_DIR ] ; then
     printf "\nrm -rf $CURRENT_DIR/$PROJECT_XXX_DIR"
     rm -rf $CURRENT_DIR/$PROJECT_XXX_DIR
 fi
}


cleanup_tmp_dir()
{
 if [ -d $TMP_DIR ] ; then
     printf "\nrm -rf $TMP_DIR"
     rm -rf $TMP_DIR
 fi
}

cleanup()
{
 printf "\nCleaning up resources."
 cleanup_tmp_dir
 printf "\n" 
 cd $INIT_DIR
}

#-----------------------------------------------------------------------------

cleanall_compilation()
{
 warning_msg "make clean after a bad compilation."
 
 CURRENT_DIR=$TMP_DIR/$PROJECT_XXX_CODE_DIR
 cd $CURRENT_DIR

 cd xsd2cpp && make clean && cd ..
 cd projectHmi &&  make clean && cd ..
 make clean
 for dir in $(find -name dep); do rm -rf $dir; done
 cd ../.. && rm -rf lib && rm -rf bin


 printf "\n\n... Clean finished.\n\n"
 cd $CURRENT_DIR
}

#-----------------------------------------------------------------------------
# @param S1: LOCAL_SRC_DIR  : must exists
# @param S2: LOCAL_DEST_DIR : must exists
# @param S3: LOCAL_SRC_FN   : must exists
# @param S4: LOCAL_DES_FN   : must not exists
cp_file()
{
 LOCAL_SRC_DIR=$1
 LOCAL_DEST_DIR=$2
 LOCAL_SRC_FN=$3
 LOCAL_DES_FN=$4

 printf "\n\ncp %s %s" $LOCAL_SRC_DIR/$LOCAL_SRC_FN \
                       $LOCAL_DEST_DIR/$LOCAL_DES_FN
 printf "\n"

 if [ ! -d $LOCAL_SRC_DIR ] ; then
     error_msg "\"$LOCAL_SRC_DIR\" not found"
     cleanup_releasedir
     exit 71
 fi

 if [ ! -d $LOCAL_DEST_DIR ] ; then
     error_msg "\"$LOCAL_DEST_DIR\" not found"
     cleanup_releasedir
     exit 72
 fi


 if [ ! -f $LOCAL_SRC_DIR/$LOCAL_SRC_FN ] ; then
     error_msg "\"$LOCAL_SRC_DIR/$LOCAL_SRC_FN\" not found"
     cleanup_releasedir
     exit 73
 fi

 if [ -f $LOCAL_DEST_DIR/$LOCAL_DES_FN ] ; then
     error_msg "\"$LOCAL_DEST_DIR/$LOCAL_DES_FN\" already exists."
     cleanup_releasedir
     exit 74
 fi

 cp $LOCAL_SRC_DIR/$LOCAL_SRC_FN $LOCAL_DEST_DIR/$LOCAL_DES_FN

 STATUS=$?
 if [ $STATUS -ne 0 ]
 then 
     error_msg "cp failure."
     cleanup_releasedir
     exit 75
 fi
}


#-----------------------------------------------------------------------------
# @param S1: LOCAL_SRC_DIR  : must exists
# @param S2: LOCAL_DEST_DIR : must exists
# @param S3: LOCAL_SRC_FN   : must exists
# @param S4: LOCAL_DES_FN   : must not exists
mv_file()
{
 LOCAL_SRC_DIR=$1
 LOCAL_DEST_DIR=$2
 LOCAL_SRC_FN=$3
 LOCAL_DES_FN=$4

 printf "\n\nmv %s %s" $LOCAL_SRC_DIR/$LOCAL_SRC_FN \
                       $LOCAL_DEST_DIR/$LOCAL_DES_FN
 printf "\n"

 if [ ! -d $LOCAL_SRC_DIR ] ; then
     error_msg "\"$LOCAL_SRC_DIR\" not found"
     cleanup_releasedir
     exit 71
 fi

 if [ ! -d $LOCAL_DEST_DIR ] ; then
     error_msg "\"$LOCAL_DEST_DIR\" not found"
     cleanup_releasedir
     exit 72
 fi


 if [ ! -f $LOCAL_SRC_DIR/$LOCAL_SRC_FN ] ; then
     error_msg "\"$LOCAL_SRC_DIR/$LOCAL_SRC_FN\" not found"
     cleanup_releasedir
     exit 73
 fi

 if [ -f $LOCAL_DEST_DIR/$LOCAL_DES_FN ] ; then
     error_msg "\"$LOCAL_DEST_DIR/$LOCAL_DES_FN\" already exists."
     cleanup_releasedir
     exit 74
 fi

 mv $LOCAL_SRC_DIR/$LOCAL_SRC_FN $LOCAL_DEST_DIR/$LOCAL_DES_FN

 STATUS=$?
 if [ $STATUS -ne 0 ]
 then 
     error_msg "mv failure."
     cleanup_releasedir
     exit 75
 fi
}

#-----------------------------------------------------------------------------
# @param S1: SRC_DIR      : must exists
# @param S2: DEST_DIR     : must exists
# @param S3: NEW_SUBDIR   : must not exists
#$SRC_DIR $DEST_DIR $NEW_SUBDIR
cp_dir()
{
 printf "\n\ncp -r %s %s" $1  $2/$3
 printf "\n"

 if [ ! -d $1 ] ; then
     error_msg "\"$1\" not found"
     cleanup_releasedir
     exit 81
 fi

 if [ ! -d $2 ] ; then
     error_msg "\"$2\" not found"
     cleanup_releasedir
     exit 82
 fi


 if [ -d $2/$3 ] ; then
     error_msg "\"$2/$3\" already exists."
     printf "\n dir: %s" $2
     printf "\n subdir: %s" $3
     cleanup_releasedir
     exit 83
 fi

 cp -r $1  $2/$3

 STATUS=$?
 if [ $STATUS -ne 0 ]
 then 
     error_msg "cp failure."
     cleanup_releasedir
     exit 85
 fi
}



#-----------------------------------------------------------------------------
# @param S1: LOC_ACTUAL_DIR   : must exists
# @param $2: LOC_ACTUAL_FILE  : must exists
# @param S2: LOC_LINK         : must NOT exists
#
ln_file()
{
 LOC_ACTUAL_DIR=$1
 LOC_ACTUAL_FILE=$2
 LOC_LINK=$3

 printf "\n\nln -s %s %s %s" $LOC_ACTUAL_DIR/$LOC_ACTUAL_FILE $LOC_LINK
 printf "\n"


 if [ ! -d $LOC_ACTUAL_DIR ] ; then
     error_msg "Directory \"$LOC_ACTUAL_DIR\" not found"
     cleanup_releasedir
     exit 91
 else
     cd $LOC_ACTUAL_DIR
 fi

 if [ ! -e $LOC_ACTUAL_FILE ] ; then
     error_msg "File \"$LOC_ACTUAL_DIR/$LOC_ACTUAL_FILE\" not found"
     cleanup_releasedir
     exit 92
 fi

 if [ -f $LOC_LINK ] ; then
     error_msg "\"$LOC_ACTUAL_DIR/$LOC_LINK\" already exists."
     cleanup_releasedir
     exit 93
 fi


 cd $LOC_ACTUAL_DIR
 ln -s $LOC_ACTUAL_FILE $LOC_LINK
 STATUS=$?
 if [ $STATUS -ne 0 ]
 then 
     error_msg "Link failure."
     cleanup_releasedir
     exit 95
 fi
}

##############################################################################
# functions
##############################################################################

input_validation()
{
 printf "\nInput validation."
 
 # CURRENT_DIR=$INIT_DIR
 # cd $CURRENT_DIR

 # cd $INIT_DIR
}

#-----------------------------------------------------------------------------

# @param S1: CURRENT_DIR   : must exists
make_validation()
{
 printf "\nMake validation."

 if [ ! -d $CURRENT_DIR ] ; then
     error_msg "\"$CURRENT_DIR\" not found"
     cleanup
     exit 4
 fi

 if [ ! -f $CURRENT_DIR/$MAKEALL_SCRIPT ] ; then
     error_msg "make-all script not found ("$CURRENT_DIR/$MAKEALL_SCRIPT")"
     cleanup
     exit 5
 fi

 if [ ! -x $CURRENT_DIR/$MAKEALL_SCRIPT ] ; then
     error_msg "make-all script ("$CURRENT_DIR/$MAKEALL_SCRIPT"), \
not executable "
     cleanup
     exit 6
 fi

 cd $INIT_DIR
}

##############################################################################

mk_tmp_dir()
{
 printf "\nGenerating the TMP directory."

 cleanup
 mkdir $TMP_DIR
 STATUS=$?
 if [ $STATUS -ne 0 ]
 then 
     error_msg "\"mkdir $TMP_DIR\" failure."
     cleanup
     exit 50
 fi

 cd $INIT_DIR
}

##############################################################################

download_from_repo()
{
 printf "\nDownloading PROJECT_XXX from repo."

 CURRENT_DIR=$TMP_DIR
 cd $CURRENT_DIR

 if [ -d $CURRENT_DIR/$PROJECT_XXX_DIR ] ; then
     cleanup_project_dir
     cd $CURRENT_DIR
 fi

 printf "\nsvn checkout $REPO_PATH/$REPO_PROJECT_XXX_VERSION $PROJECT_XXX_DIR"
 svn checkout $REPO_PATH/$REPO_PROJECT_XXX_VERSION $PROJECT_XXX_DIR > /dev/null
 STATUS=$?
 if [ $STATUS -ne 0 ]
 then 
     error_msg "\"svn checkout\" failure"
     cleanup
     exit 10
 fi

 cd $INIT_DIR
}

##############################################################################

do_compilation()
{
 CURRENT_DIR=$TMP_DIR/$PROJECT_XXX_CODE_DIR
 cd $CURRENT_DIR

 printf "\n./$MAKEALL_SCRIPT > /dev/null"
 ./$MAKEALL_SCRIPT > /dev/null
 STATUS=$?
 if [ $STATUS -ne 0 ]
 then 
     error_msg "\"./$MAKEALL_SCRIPT\" failure"
     cleanall_compilation
     cd $INIT_DIR
     exit 25
 fi

 cd $INIT_DIR
}

#-----------------------------------------------------------------------------

generate_binaries()
{
 printf "\n\nGeneration of PROJECT_XXX binaries."

 CURRENT_DIR="$TMP_DIR/$PROJECT_XXX_CONFIG_DIR/scripts/"
 make_validation $CURRENT_DIR

 # a) At $TMP_DIR:
 CURRENT_DIR="$TMP_DIR/$PROJECT_XXX_CONFIG_DIR/scripts/"
 if [ -d $TMP_DIR/$PROJECT_XXX_CODE_DIR ] ; then
     printf "\ncp $MAKEALL_SCRIPT  $TMP_DIR/$PROJECT_XXX_CODE_DIR"
     cp $CURRENT_DIR/$MAKEALL_SCRIPT  $TMP_DIR/$PROJECT_XXX_CODE_DIR
 else
     error_msg "PROJECT_XXX directory not found ("$PROJECT_XXX_CODE_DIR")"
     cleanup
     exit 15
 fi


# b) At $PROJECT_XXX_CODE_DIR
 CURRENT_DIR=$TMP_DIR/$PROJECT_XXX_CODE_DIR
 make_validation $CURRENT_DIR

 printf "\ncd $CURRENT_DIR"
 cd $CURRENT_DIR
 do_compilation

 cd $INIT_DIR
}

##############################################################################
#
# 4) Creating and fulfilling the installation directory
#
# 4.1) Make the installation dir
# 4.2) Add binaries
# 4.3) Add config & adap files and dirs
# 4.4) Make the required links
#
# \NICE_TO_HACE Add script instalador del PROJECT_XXX. En la maquina destino debe:
#      a) extraer el contenido de la entrega 
#      b) establecer variables de entorno necesarias.
#
make_install()
{

 if [ ! -d $TMP_DIR ] ; then
     error_msg "\"$TMP_DIR\" not found"
     cleanup_releasedir
     exit 28
 fi

 mk_release_dir
 add_bins
 add_config
 mk_links
 mk_tar
}

##############################################################################

# 4.1) Make the insallation dir

mk_release_dir()
{
 printf "\n\nGenerating the release directory."

 cleanup_releasedir

 CURRENT_DIR=$TMP_DIR
 cd $CURRENT_DIR

 printf "\nmkdir $RELEASE_DIR"
 mkdir $RELEASE_DIR
 STATUS=$?
 if [ $STATUS -ne 0 ]
 then 
     error_msg "\"mkdir $RELEASE_DIR\" failure."
     #cleanup
     cleanup_releasedir
     exit 30
 fi

 mk_install_dir

 cd $INIT_DIR
}


mk_install_dir()
{
 CURRENT_DIR=$TMP_DIR/$RELEASE_DIR
 cd $CURRENT_DIR
 
 # e.g. version_PROJECT_XXX_S2020_090218.tar.gz
 DNAME=$INSTALL_DIR_NAME_PREFIX
 DNAME+=$RELEASE_DATE

 printf "\nmkdir $DNAME"
 mkdir $DNAME
 STATUS=$?
 if [ $STATUS -ne 0 ]
 then 
     error_msg "\"mkdir $DNAME\" failure."
     #cleanup
     cleanup_releasedir
     exit 31
 fi

 export THE_INSTAL_DIR=$TMP_DIR/$RELEASE_DIR/$DNAME
 export THE_EVENTUAL_RELEASE_NAME=$DNAME

printf "\n\n THE_INSTAL_DIR: %s \n\n "  $THE_INSTAL_DIR
}

##############################################################################

# 4.2) Add binaries

add_bins()
{
 SRC_DIR="$TMP_DIR/$PROJECT_XXX_DIR/C++/bin/linux_x86/project"
 DEST_DIR=$THE_INSTAL_DIR

 cd $DEST_DIR
 mkdir bin
 DEST_DIR+="/bin"

 #project
 SRC_FILE_NAME="projectComponent"
 DEST_FILE_NAME="project_"
 DEST_FILE_NAME+=$SOMEID
 DEST_FILE_NAME+="_$RELEASE_DATE"
 cp_file $SRC_DIR $DEST_DIR $SRC_FILE_NAME $DEST_FILE_NAME

 #hmi
 SRC_FILE_NAME="projectHmi"
 DEST_FILE_NAME="projectHmi_"
 DEST_FILE_NAME+=$SOMEID
 DEST_FILE_NAME+="_$RELEASE_DATE"
 cp_file $SRC_DIR $DEST_DIR $SRC_FILE_NAME $DEST_FILE_NAME

 # ...
}

##############################################################################

# 4.3) Add config & adap

add_config()
{
 SRC_DIR="$TMP_DIR/$PROJECT_XXX_DIR/CONFIG"
 DEST_DIR=$THE_INSTAL_DIR

 printf "\nAdding config:\n"

 #myStyleSheet.css
 printf "\nmyStyleSheet.css"
 SRC_FILE_NAME="./src/project/projectHmi/styleSheet/myStyleSheet.css"
 DEST_FILE_NAME="myStyleSheet.css"
 cp_file $SRC_DIR $DEST_DIR $SRC_FILE_NAME $DEST_FILE_NAME

 # scripts
 printf "\nscripts/"
 mkdir $DEST_DIR/scripts

 printf "\nscripts/projectLauncher.sh"
 SRC_FILE_NAME="projectLauncher.sh"
 DEST_FILE_NAME=$SRC_FILE_NAME
 DEST_FILE_NAME+="_"
 DEST_FILE_NAME+=$SOMEID
 DEST_FILE_NAME+="_$RELEASE_DATE"
 cp_file "$SRC_DIR/src/project/scripts" \
         "$DEST_DIR/scripts"  \
         $SRC_FILE_NAME $DEST_FILE_NAME
 #...

 # config directories
 SRC_DIR+="/src/project"

 # inputs/
 printf "\ninputs"
 NEW_SUBDIR="inputs"
 cp_dir "$SRC_DIR/$NEW_SUBDIR" $DEST_DIR $NEW_SUBDIR

 # ...
}

##############################################################################

# 4.4) Make the required links
#
# #ls -l |sort -d -k 1.1,1.1r -k 9   # ordenar lor tipo de fichero
mk_links()
{
 SRC_DIR=$THE_INSTAL_DIR
 DEST_DIR=$THE_INSTAL_DIR

 printf "\nAdding links:\n"

# inputs -> ./../../inputs/ #from inside adap/LEBL
 THE_LINK="inputs"
 THE_ACTUAL_FILE=" ./../../inputs/"
 ln_file "$THE_INSTAL_DIR/adap/LEBL" $THE_ACTUAL_FILE $THE_LINK

# ...
}



##############################################################################

# 4.5) Make the eventual release's tar.gz file
#
mk_tar()
{
 printf "\nMaking the release's tar.gz file:\n"

# BASE_DIR="$THE_INSTAL_DIR/.."
 BASE_DIR=$TMP_DIR/$RELEASE_DIR

 if [ ! -d $BASE_DIR/$THE_EVENTUAL_RELEASE_NAME ] ; then
     error_msg "\"$BASE_DIR/$THE_EVENTUAL_RELEASE_NAME\" not found"
     cleanup_releasedir
     exit 41
 else
     printf "\ncd $BASE_DIR"
     cd $BASE_DIR
 fi

 printf "\ntar -czvf $THE_EVENTUAL_RELEASE_NAME.tar.gz $THE_EVENTUAL_RELEASE_NAME"
 tar -czvf $THE_EVENTUAL_RELEASE_NAME.tar.gz $THE_EVENTUAL_RELEASE_NAME \
     > /dev/null
 STATUS=$?
 if [ $STATUS -ne 0 ]
 then 
     error_msg "\"tar -czvf $THE_EVENTUAL_RELEASE_NAME.tar.gz\" failure."
     cleanup_releasedir
     exit 42
 fi

 mv_file $BASE_DIR $INIT_DIR \
         $THE_EVENTUAL_RELEASE_NAME.tar.gz \
         $THE_EVENTUAL_RELEASE_NAME.tar.gz
	 
 printf "\nCreado el fichero final con la entrega: %s" \
	    "$BASE_DIR/$THE_EVENTUAL_RELEASE_NAME.tar.gz"
}

##############################################################################
# main actions
#
# Download from the repository
# Generation of PROJECT_XXX & HMI binaries
#
##############################################################################

printf "\n\n"
printf "Generating a new PROJECT_XXX release ..."
printf "\n"


MaxNumParams=1 
if [ $# -gt $MaxNumParams ] ; then
    printf "\nUsage: $0 [date]\n\n"
    exit 1
fi

if [ $# -eq 0 ] ; then
    RELEASE_DATE=$(date "+%d%m%y")
else
    RELEASE_DATE=$1
fi


input_validation
mk_tmp_dir
download_from_repo
generate_binaries
make_install
cleanup

######## finished ########
printf "\n\n"
printf " ... Task completed. PROJECT_XXX release has been correctly generated."
printf "\n\n"
cd $INIT_DIR

