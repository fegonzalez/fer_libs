#!/bin/bash

# executing from test/ directory
echo INFO: current dir: $PWD
rm -f ./MyPreprocessingTest.xsd
rm -f ./MyPreprocessingTest.last
cd ..
echo INFO: current dir: $PWD 

bash order_sources.sh ./test/test_files

bash preprocess_swis_xsd_sources.sh \
./test/test_files \
MyPreprocessingTest \
f1_test.xsd

cd test
echo INFO: current dir: $PWD
# remove test resources
rm -rf ../tmp/*
# diff
rm ../output/xsd_ordered_list.csv
mv ../output/MyPreprocessingTest.xsd ./MyPreprocessingTest.last
echo INFO: diff ./MyPreprocessingTest.last ./MyPreprocessingTest.xsd.ok
diff ./MyPreprocessingTest.last ./MyPreprocessingTest.xsd.ok
