
questions.html : questions.json questions-header.html
	jq -r 'to_entries | .[] | "\(.key + 1). \(.value.block)", ( .value.questions | to_entries | .[] | "    \(.key + 1). \(.value)")' \
		$< \
		| cat questions-header.html - > $@

questions.json : questions.awk index.html
	./$^ > $@
