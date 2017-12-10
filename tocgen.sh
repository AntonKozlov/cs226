#!/bin/bash

TOC=index.html

echo -n > $TOC

MASKED_FILES=(
	index.html
	proto.html
	cs226.html
)

for i in $(find \( -name '*.html' -o -name '*.pdf' \) ${MASKED_FILES[@]/#/-and -not -name } | sort -n -k 1.3 ); do
	echo -e "<p><a href=\"$i\">$(basename ${i%.*})</a></p>\n" >> $TOC
done
