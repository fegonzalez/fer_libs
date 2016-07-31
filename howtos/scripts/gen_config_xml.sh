#!/bin/bash

file=$1

counter=1


cat <<header >> config_xml_output
<hierarchy>
  <help file="help0.txt"/>
  <level id="1." title="PERFORMANCE">
    <help file="help1.txt"/>
header

IFS=$'\n'

for line in $(cat ${file})
do
    test_name=$(echo $line | awk '{ print $1 }')
    id=$(echo $line | awk '{ print $2 }')

    id_short=$( echo "$id" | sed 's/^\(...\).*/\1/' )
    id_really_short=${id_short%%.*}

    if [ "${id_short}" != "${id_short_last}" ]
    then

	[ "${id_really_short}" = "2" ] && 
	[ "${id_really_short}" != "${id_really_short_last}" ] &&
	cat<<handling >> config_xml_output

    </level>
  </level>
  <level id="2." title="HANDLING QUALITIES">
    <help file="help2.txt"/>
handling

	[ "${id_really_short}" = "${id_really_short_last}" ] && 
	echo "    </level>" >> config_xml_output

	level_title="title TBC"

	case ${id_short} in
	    "1.a") level_title="Engine Assessment";;
	    "1.b") level_title="Surface Operations";;
	    "1.c") level_title="Take off";;
	    "1.d") level_title="Hover";;
	    "1.e") level_title="Vertical Climb";;
	    "1.f") level_title="Level Flight";;
	    "1.g") level_title="Climb";;
	    "1.h") level_title="Descent";;
	    "1.i") level_title="Autorotation";;
	    "1.j") level_title="Landing";;
	    "2.a") level_title="Control System Mechanical Characteristics";;
	    "2.b") level_title="Low Airspeed Handling Qualities";;
	    "2.c") level_title="Longitudinal Handling Qualities";;
	    "2.d") level_title="Lateral and Directional Handling Qualities";;
	esac


	cat <<secondlevel >> config_xml_output
    <level id="${id_short}" title="${level_title}" manual="False" auto="True" record="False">
      <help file="help${id_short//./_}.txt"/>

secondlevel

    fi

    cat <<individualtest >> config_xml_output
      <test id="$id" title="${test_name//_/ }" num_id="${counter}" string_id="${test_name}" manual="True" auto="True" record="False">
        <help file="/qtg/help${test_name//./_}.pdf"/>
      </test>

individualtest

    counter=$(($counter + 1))
    id_short_last="${id_short}"
    id_really_short_last="${id_really_short}"
    
done

cat <<footer >> config_xml_output
    </level>
  </level>
</hierarchy>
footer


