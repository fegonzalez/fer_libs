
To remove the line and print the output to standard out:

>>sed '/pattern to match/d' ./infile

To directly modify the file:

>>sed -i '/pattern to match/d' ./infile

To directly modify the file (and create a backup):

>>sed -i.bak '/pattern to match/d' ./infile

For Mac OS X users:

>>sed -i '' '/pattern/d' ./infile

