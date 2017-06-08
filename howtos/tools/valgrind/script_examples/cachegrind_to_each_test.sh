#!/bin/bash

#!\file cachegrind_to_each_test.sh

##------------------------------------------------------------------------------

#VALGRIND_OPTIONS="--partial-loads-ok=yes"
VALGRIND_OPTIONS=

START_DATE=$(date) # just to check the total execution time

##------------------------------------------------------------------------------

for test in $(grep BOOST_AUTO_TEST_CASE ../test/test.cc \
   | sed 's/\/\/.*//g' \
   | sed 's/.*(//g' \
   | sed 's/)//g')
do
#    echo Executing: valgrind $test

    LOCAL_VALGRIND_OPTIONS="$VALGRIND_OPTIONS --log-file=cachegrind.$test.out"
#    echo LOCAL_VALGRIND_OPTIONS : $LOCAL_VALGRIND_OPTIONS

    RUN_COMMAND="./FlightPlanTranslator_test --run_test=$test"
#    echo RUN_COMMAND : $RUN_COMMAND 
        
    valgrind --tool=cachegrind $LOCAL_VALGRIND_OPTIONS $RUN_COMMAND
    
done 

##------------------------------------------------------------------------------

echo
echo
echo Start time...
echo $START_DATE
echo
echo End time...
date
echo 

# Example brief error info
# echo
# echo Memory errors:
# grep -L "ERROR SUMMARY: 0" *.out
# echo
