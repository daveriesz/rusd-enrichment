#!/bin/bash

filename=

inshere='                <!-- INSERT HERE -->'

cat "resources.txt" \
| while read aa ; do
  if echo "$aa" | egrep "^\* " >/dev/null ; then
    filename=docs/`echo "${aa}.html" | tr "[A-Z]" "[a-z]" | sed "s/^\* *//g" | tr " " "-"`
    title=`echo "$aa" | sed "s/^\* *//g"`
    level=`echo "$title" | sed "s/ Resources$//g"`
    echo "FILENAME: $filename"
    cp "template-resources.html" "$filename"
    header=""
    subjects=( )
    subject_items=( )
    si=0
  elif echo "$aa" | egrep "^\+ " >/dev/null ; then
    hh=`echo "$aa" | sed "s/^\+ *//g"`
    header+="$hh<br>"
  elif echo "$aa" | egrep "^\*\* " >/dev/null ; then
    sb=`echo "$aa" | sed "s/^\*\* *//g"`
    subjects[$si]="$sb"
    si=$((si + 1))
  elif echo "$aa" | egrep "^\*\*\* " >/dev/null ; then
    item=`echo "$aa" | sed "s/^\*\*\* *//g"`
    sim=$((si - 1))
    subject_items[$sim]+="<li>${item}</li>"
  elif echo "$aa" | egrep "^ *$" >/dev/null ; then
    if [ "$title" = "" ] ; then continue ; fi
    header=`echo "$header" | sed "s/<br>$//g"`
    echo "    TITLE : $title"
    echo "    LEVEL : $level"
    echo "    HEADER: $header"
    for (( ii=0 ; ii<${#subjects[@]} ; ii++ ))
    {
      subject_items[$ii]="<ul>${subject_items[$ii]}</ul>"
      echo "    SUBJECT: $ii ${subjects[$ii]}"
      echo "           : ${subject_items[$ii]}"

      sed -i "s,^${inshere}$,<tr><td align=\"center\" valign=\"center\">${subjects[$ii]}</td><td width=\"100%\">${subject_items[$ii]}</td></tr>\n${inshere},g" "$filename"
    }

    sed -i "s,LEVEL,${level},g" "$filename"
    sed -i "s,\[\([^]]*\)\] *(\([^)]*\)),<a href=\"\2\">\1</a>,g" "$filename"

  fi

done

