#!/usr/bin/python3
# for python 3 (>>  which python3)


#!\brief This script return the list of file names included in a
#         hierarchy of files.
#
# Beginning from a file name, this script get the list of files
# included by that file; and then all the files included by those
# included files, ..., and so on.
#
# By default, the result is stored in a file named "list_of_included_idls.out"
#
#!\info This script ignores includes within one-line comments: //  #include 
#
#!\warning This script can't detect includes within multiple line
#          comments /* .... #include */


import re;

INIT_FILE="sdd_distribution_event.idl3"
OUTPUT_FILE="list_of_included_idls.out"
pattern1="#include.*\".*.idl\""
pattern2="#include.*\".*.idl3\""
pattern3="#include.*<.*.idl>"
pattern4="#include.*<.*.idl3>"

valid_pattern1='(?<!//)'+pattern1
valid_pattern2='(?<!//)'+pattern2
valid_pattern3='(?<!//)'+pattern3
valid_pattern4='(?<!//)'+pattern4


def extract_file_name(included_file):
    return re.sub("[ \t]*\".*",
                  "",
                  re.sub("[ \t]*#include[ \t]*\"",
                         "",
                         included_file))

def extract_file_name_2(included_file):
    return re.sub("[ \t]*>.*",
                  "",
                  re.sub("[ \t]*#include[ \t]*<",
                         "",
                         included_file))

# lista_init (list): new files to process: initialized to INIT_FILE
#
# the_complete_included_files_names (set): contains the name of each
# idl file included in the INIT_FILE hierarchy. NON-DUPLICATE elements.
#
# temp_list (list): temporary working list: storing the idls processed
#            int the current process loop

lista_init = [INIT_FILE]
the_complete_included_files_names = set()
temp_list = []

#main loop
while len(lista_init)>0:

    temp_list=lista_init
    lista_init=[]
    
# inner loop
#
# for the current processed file:
# 
# 1) add the name of the current processed file to 'the_complete_included_files_names'
#
# 2) add each included file to 'lista_inicial' for further processing

# for file1 in temp_list:   # read loop
# for file1 in temp_list[:]:  # write loop: Loop over a slice copy of the list
    for file1 in temp_list:   # read loop

        # 1)
        the_complete_included_files_names.add(file1)

        # 2)
        with open(file1, 'r') as f:
            readf =f.read()
        f.close()

        for included_file in re.findall(valid_pattern1, readf):
            lista_init.insert(0, extract_file_name(included_file))
        for included_file in re.findall(valid_pattern2, readf):
            lista_init.insert(0, extract_file_name(included_file))
        for included_file in re.findall(valid_pattern3, readf):
            lista_init.insert(0, extract_file_name_2(included_file))
        for included_file in re.findall(valid_pattern4, readf):
            lista_init.insert(0, extract_file_name_2(included_file))
            
#end of main loop

#print(the_complete_included_files_names)
with open(OUTPUT_FILE, 'w') as file_handler:
    for item in the_complete_included_files_names:
        file_handler.write("{}\n".format(item))

