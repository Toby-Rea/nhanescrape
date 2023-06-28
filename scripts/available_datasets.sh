#!/bin/bash

download() {
    curl -s "https://wwwn.cdc.gov/nchs/nhanes/search/datapage.aspx?Component=$1" \
        > "downloads/component_pages/$1.html"
}

scrape_datasets() {
    component=$(basename $1 .html)
    file="${2}/${component}.json"
    cat $1 \
    | hq \
        "{ ${component}: #GridView1 > tbody > tr  | \
            [{ \
                years: td:nth-child(1), \
                name: td:nth-child(2), \
                docs: td:nth-child(3) > a | @(href), \
                data: td:nth-child(4) > a | @(href), \
                published: td:nth-child(5) \
            }] \
        }" \
    | jq \
    | sed '/\"\(data\|docs\)\": \"/ s/\"\//\"https\:\/\/wwwn\.cdc\.gov\//' \
    > $file
    count=$(jq '.[] | length' $file)
    printf '[LOG] Discovered %d %s datasets\n' "$count" "$component"
}

export -f download
export -f scrape_datasets

mkdir -p downloads/component_pages

cat << EOF | parallel "[ -f downloads/component_pages/{}.html ] || download {}"
Demographics
Dietary
Examination
Laboratory
Questionnaire
LimitedAccess
EOF

tmp_dir=$(mktemp -d)

find "downloads/component_pages" -name *.html | parallel scrape_datasets {} $tmp_dir
jq -s 'add' ${tmp_dir}/*.json > Available_Datasets.json
