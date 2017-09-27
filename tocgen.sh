
TOC=index.html

echo -n > $TOC

for i in $(find -name '*.html' -and -not -name proto.html -and -not -name index.html | sort -n); do 
	echo -e "<p><a href=\"$i\">$(basename ${i%.html})</a></p>\n" >> $TOC
done
