#!/bin/bash

mkdir -p datasets && cd datasets

COMPONENTS=("Demographics" "Dietary" "Examination" "Laboratory" "Questionnaire")

for component in "${COMPONENTS[@]}"
do
file="${component}.json"
curl -s https://wwwn.cdc.gov/nchs/nhanes/search/datapage.aspx?Component=${component} \
| hq \
    "{ datasets: #GridView1 > tbody > tr  | \
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
count=$(jq '.datasets | length' $file)
printf '[LOG] Discovered %d %s datasets\n' "$count" "$component"
done