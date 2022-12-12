#!/bin/bash

Y=$(date +%Y)
REPO=os226-$Y

if ! [ $GITHUB_TOKEN ]; then
        echo "no GITHUB_TOKEN env"
        exit 1
fi

getpulls() {
        rm -f pulls.txt
        has_next=true
        after=
        while [ "$has_next" = true ]; do 
                curl -s https://api.github.com/graphql \
                        -H "Authorization: bearer $GITHUB_TOKEN" \
                        -d @- <<EOF > page.json
                {"query" : "query{
                repository(owner: \"AntonKozlov\", name: \"os226-$Y\") {
                    pullRequests(first: 100 $after) {
                      edges {
                        node {
                          author {
                            login
                          }
                          url
                          labels(first: 10) {
                            edges {
                              node {
                                name
                              }
                            }
                          }
                        }
                      }
                      pageInfo {
                        endCursor
                        hasNextPage
                      }
                    }
                  }
                }"}
EOF
                jq -r '.data.repository.pullRequests.edges[].node | [ .author.login, .url, ( [ .labels.edges[].node.name ] | join(" ") ) ] | join("\t")' page.json >> pulls.txt
                has_next=$(jq .data.repository.pullRequests.pageInfo.hasNextPage page.json)
                after=", after:\\\"$(jq -r .data.repository.pullRequests.pageInfo.endCursor page.json)\\\""
        done
}

calcstat() {
        awk -F "\t" '
{ 
        delete labels
        nl = split($3, a, " ")
        if (!nl) {
                labels["MISSING"] = 1;
        }
        for (i in a) {
                labels[a[i]] = 1
        }

        c = 0
}
!(labels["accepted"] || \
  labels["late"]     || \
  labels["partial"]  || \
  labels["issue"]    || \
  labels["invalid"]  || \
  labels["enhancement"]) {
        printf "no labels: %s\n", $2 > "/dev/stderr"
        next
}
labels["accepted"] {
        c += 1
}
labels["late"] && nl != 1 {
        printf "Wrong number of labels: %s\n", $2 > "/dev/stderr"
}
labels["partial"] || labels["late"] {
        c += 0.5
}
labels["defenced"] {
        c += 3
}
labels["enhancement"] {
        c += 1
}
labels["hw12"] {
        c += 10
}
{
        s[$1] += c
}
END {
        for (i in s)
                printf "%24s: %.1f\n", i, s[i]
}
' pulls.txt | sort -nrk 2
}

getpulls
calcstat
rm page.json pulls.txt

# vim: expandtab
