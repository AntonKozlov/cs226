
TOC=index.html

echo -n > $TOC

for i in $(find \( -name '*.html' -o -name '*.pdf' \) -and -not -name proto.html -and -not -name index.html | sort -n -k 1.3 ); do
	echo -e "<p><a href=\"$i\">$(basename ${i%.*})</a></p>\n" >> $TOC
done
