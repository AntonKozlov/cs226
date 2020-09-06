$1 == "---" { anchor = "" }
$1 == "name:" { anchor = $2 }
anchor && match($0, /^## (.*)$/, m) {
	printf "%d. [%s](#%s)\n", ++n, m[1], anchor
}
