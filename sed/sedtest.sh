#!/bin/bash
#
# Desc: Basic sed editor command demonstration 
#
# Author: Sabyasach Mitra
# Date: 11/24/2024
#
# the string test will be replaced with big test
echo "This is a test" | sed 's/test/big test/'
#
# delete data1.txt
rm data1.txt
# create a file data1.txt and add following lines
# using here document facility
cat > data1.txt << EOF
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
EOF
#
# replace string
sed -e 's/brown/green/; s/dog/cat/' data1.txt
#
# run with sed script parameter file
# we should not put ; between commands in commands in the sed1.sed (sed script)
# sed commands in script should be in separate lines
sed -f sed1.sed data1.txt
