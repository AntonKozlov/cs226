#!/bin/awk -f

BEGIN {
	indent[1] = "    "
	print "\
<!DOCTYPE html>\n\
\n\
<!-- THIS IS GENERATED FILE, DO NOT EDIT DIRECTLY -->\n\
\n\
<script>window.texme = {\n\
    style: 'none',\n\
    useMathJax: false,\n\
    protectMath: false,\n\
}</script>\n\
<script src=\"https://cdn.jsdelivr.net/npm/texme@0.9.0\"></script><textarea>\n\
\n\
# Список вопросов\n\
"
}

function line(l, s) {
	++n[l]
	printf "\n%s%d. %s", indent[l], n[l], s
}

function dequest() {
	$1 = $(NF) = ""
	sub(/^\s+/, "", $0)
	sub(/\s+$/, "", $0)
}

$1 == "name:" { 
	b = 1
	n[1] = 0
}

b && match($0, /^#+ (.*)$/, m) {
	b = 0
	line(0, m[1])
}

$1 == "<!--Q:" {
	dequest()
	line(1, $0)
}

$1 == "<!--QCONT:" {
	dequest()
	printf ", %s", $0
}

END {
	print ""
}
