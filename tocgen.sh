#!/bin/bash

TOC=index.html

find -name slides.html | xargs awk '
match($0, /^## (.*)$/, m) {
	split(FILENAME, p, "/")
	path[p[2]] = FILENAME
	title[p[2]] = m[1]
	lastfile = FILENAME
	nextfile
}
$1 == "---" {
	nextfile
}
ENDFILE {
	if (lastfile != FILENAME) {
		print "warning: " FILENAME " have no subtitle" > "/dev/stderr"
	}
}
END {
	print "<p><a href=\"./questions.html\">Список вопросов</a></p>"
	for (i in title) {
		print "<p><a href=\"" path[i] "\">" i ": " title[i] "</a></p>"
	}
}
' > $TOC
