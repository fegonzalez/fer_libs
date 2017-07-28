#!/bin/bash

# executing from test/ directory
echo INFO: current dir: $PWD
rm -f ./MyPreprocessingTest.xsd
rm -f ./MyPreprocessingTest.last
cd ..
echo INFO: current dir: $PWD
echo INFO: bash order_sources.sh ./test/test_files
bash order_sources.sh ./test/test_files
echo INFO bash preprocess_swis_xsd_sources.sh ./test/test_files MyPreprocessingTest f1_test.xsd
bash preprocess_swis_xsd_sources.sh ./test/test_files MyPreprocessingTest f1_test.xsd
cd test
echo INFO: current dir: $PWD
# remove test resources
rm -rf ../tmp/*
rm ../output/xsd_ordered_list.csv
#update result
mv ../output/MyPreprocessingTest.xsd ./MyPreprocessingTest.last

# (check manually)

