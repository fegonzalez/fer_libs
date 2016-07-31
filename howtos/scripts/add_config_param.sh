#!/bin/bash

##########################################################################
# Ejemplo de uso en ficheros testParam.h y testParam.cpp
#
# $0 PARAM_MODULE_NAME PARAM_DATA_TYPE   PARAM_VAR_NAME   PARAM_DEFAULT_VALUE  expected."
#
# STRING
#./add_config_param.sh whatever string NEW_CADENA \"valor_cadena\"
# CHAR
#./add_config_param.sh whatever char caracter_a  \'A\'
# DOUBLE 
#./add_config_param.sh  whatever double TURRET_LASER_ISECTOR_YAW_OFFSET   1.0
#
# VECTOR y valores múltiples
# No soportado: hacerlo con valor inicial unico para tenerlo todo excepto 
# la inicialización, y hacer esta a mano
#
#########################################################################


NumParams=4
change_point_param_1="_DO_NOT_REMOVEME_change_point_param_1"
change_point_param_2="_DO_NOT_REMOVEME_change_point_param_2"
change_point_param_3="_DO_NOT_REMOVEME_change_point_param_3"
change_point_param_4="_DO_NOT_REMOVEME_change_point_param_4"
change_point_param_5="_DO_NOT_REMOVEME_change_point_param_5"
change_point_param_101="_DO_NOT_REMOVEME_change_point_param_101"
change_point_param_201="_DO_NOT_REMOVEME_change_point_param_201"
change_point_publish_1="_DO_NOT_REMOVEME_change_point_publish_1"
change_point_config_1="_DO_NOT_REMOVEME_change_point_config_1"


if [ $# -ne $NumParams ] ; then
echo "ERROR (BAD FORMAT): $0  MODULE_NAME  DATA_TYPE  VAR_NAME  DEFAULT_VALUE  expected."
exit 1
fi

PARAM_MODULE_NAME=$1
PARAM_DATA_TYPE=$2
PARAM_VAR_NAME=$3
PARAM_DEFAULT_VALUE=$4

#Edit the next paths to access to the correct files
HEADER_PARAM_FILE_NAME="whatever_system_icd.h"
CPP_PARAM_FILE_NAME="whateverParameters.cpp"
PARAM_PUBLISH_FILE_NAME="whatever_system.cpp"
PARAM_CONFIG_FILE_NAME="../../../whatever_path/whatever_config.dat"
TEST_CONFIG_FILE_NAME="whatever_config_test.dat"
OSTREAM_OPERATOR_PARAM_FILE_NAME="whatever_system_icd.cpp"

if [ ! -f $HEADER_PARAM_FILE_NAME ]; then
    echo -e "\n $HEADER_PARAM_FILE_NAME not found \n"
    exit 11
fi


if [ ! -f $CPP_PARAM_FILE_NAME ]; then
    echo -e "\n $CPP_PARAM_FILE_NAME not found \n"
    exit 21
fi


if [ ! -f $PARAM_PUBLISH_FILE_NAME ]; then
    echo -e "\n $PARAM_PUBLISH_FILE_NAME not found \n"
    exit 31
fi


if [ ! -f $PARAM_CONFIG_FILE_NAME ]; then
    echo -e "\n $PARAM_CONFIG_FILE_NAME not found \n"
    exit 41
fi


if [ ! -f $TEST_CONFIG_FILE_NAME ]; then
    echo -e "\n $TEST_CONFIG_FILE_NAME not found \n"
    exit 51
fi



if [ ! -f $OSTREAM_OPERATOR_PARAM_FILE_NAME ]; then
    echo -e "\n $OSTREAM_OPERATOR_PARAM_FILE_NAME not found \n"
    exit 51
fi

# echo $PARAM_MODULE_NAME=$1
# echo $PARAM_DATA_TYPE=$2
# echo $PARAM_VAR_NAME=$3
# echo $PARAM_DEFAULT_VALUE=$4
# echo HEADER_PARAM_FILE_NAME=$HEADER_PARAM_FILE_NAME
# echo CPP_PARAM_FILE_NAME=$CPP_PARAM_FILE_NAME
# echo PARAM_PUBLISH_FILE_NAME=$PARAM_PUBLISH_FILE_NAME
# echo PARAM_CONFIG_FILE_NAME=$PARAM_CONFIG_FILE_NAME
# echo TEST_CONFIG_FILE_NAME=$TEST_CONFIG_FILE_NAME
# echo OSTREAM_OPERATOR_PARAM_FILE_NAME=$OSTREAM_OPERATOR_PARAM_FILE_NAME

# echo $change_point_param_1
# echo $change_point_param_2
# echo $change_point_param_3
# echo $change_point_param_4
# echo $change_point_param_5
# echo $change_point_param_101 
# echo $change_point_param_201 
# echo $change_point_publish_1
# echo $change_point_config_1


for file in $(ls $HEADER_PARAM_FILE_NAME); 
do 
sed -i "s/$change_point_param_1/$change_point_param_1\n const $PARAM_DATA_TYPE DEFAULT_$PARAM_VAR_NAME = $PARAM_DEFAULT_VALUE;/g" $file;
sed -i "s/$change_point_param_2/$change_point_param_2\n $PARAM_DATA_TYPE $PARAM_VAR_NAME;/g" $file;
sed -i "s/$change_point_param_3/$change_point_param_3\n , $PARAM_DATA_TYPE $PARAM_VAR_NAME = DEFAULT_$PARAM_VAR_NAME/g" $file;
sed -i "s/$change_point_param_4/$change_point_param_4\n , $PARAM_VAR_NAME($PARAM_VAR_NAME)/g" $file;
sed -i "s/$change_point_param_5/$change_point_param_5\n $PARAM_VAR_NAME = DEFAULT_$PARAM_VAR_NAME;/g" $file;
done

for file in $(ls $CPP_PARAM_FILE_NAME); 
do
sed -i "s/$change_point_param_101/$change_point_param_101\n , params_file.parameter<$PARAM_DATA_TYPE>(\"$PARAM_VAR_NAME\")/g" $file;
done

for file in $(ls $PARAM_CONFIG_FILE_NAME); 
do
sed -i "s/$change_point_config_1/$change_point_config_1\n$PARAM_VAR_NAME  $PARAM_DEFAULT_VALUE/g" $file;
done

# echo $change_point_param_101 

for file in $(ls $TEST_CONFIG_FILE_NAME); 
do
sed -i "s/$change_point_config_1/$change_point_config_1\n$PARAM_VAR_NAME  $PARAM_DEFAULT_VALUE/g" $file;
done


for file in $(ls $PARAM_PUBLISH_FILE_NAME); 
do
sed  -i "s/$change_point_publish_1/$change_point_publish_1\n publish_input\(the_config_params.$PARAM_VAR_NAME);/g" $file;
done


for file in $(ls $OSTREAM_OPERATOR_PARAM_FILE_NAME); 
do
sed -i "s/$change_point_param_201/$change_point_param_201\n out \<\< object.$PARAM_VAR_NAME \<\< \", \" ; /g" $file;
done
