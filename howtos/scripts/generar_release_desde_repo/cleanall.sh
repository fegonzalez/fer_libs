#!/bin/bash

INIT_COMPIL_DIR=$PWD
#echo $INIT_COMPIL_DIR

# WARNING   Orden inverso al make all


# make clean  Hmi
cd "$INIT_COMPIL_DIR/elproyectoHmi" && make clean && cd $INIT_COMPIL_DIR

# make clean  elproyecto
cd $INIT_COMPIL_DIR && make clean && cd $INIT_COMPIL_DIR

# make clean  xs2cpp
cd "$INIT_COMPIL_DIR/xsd2cpp" && make clean && cd $INIT_COMPIL_DIR


#for dir in $(find -name dep); do rm -rf $dir; done

cd ../.. && rm -rf lib && rm -rf bin

echo
echo ... Clean finished
echo
cd $INIT_COMPIL_DIR
echo $PWD
