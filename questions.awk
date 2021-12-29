#!/bin/awk -f

BEGIN {
	printf "[\n"
}

function question(label) {
	r = sub("^<!--" label ":\\s*", "")
	if (r) {
		sub(/\s+-->$/, "", $0)
		gsub("\"", "\\" "\"")
	}
	return r
}


$1 == "name:" { 
	b = 1
}

b && match($0, /^#+ (.*)$/, m) {
	b = 0
	if (q) {
		printf "      \"%s\"\n    ]\n  },\n", q
		q = ""
	}
	printf "  {\n    \"block\" : \"%s\",\n    \"questions\" : [\n", m[1]
}

question("Q") {
	if (q)
		printf "      \"%s\",\n", q
	q = $0

}

question("QCONT") {
	q = q ", " $0
}

END {
	if (q)
		printf "      \"%s\"\n    ]\n  }\n]\n", q
}
