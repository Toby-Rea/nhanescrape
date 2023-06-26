#!/bin/sh

scrape_datasets() {
    file="${tmp_dir}/${component}.json"
    curl -s https://wwwn.cdc.gov/nchs/nhanes/search/datapage.aspx?Component=${component} \
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

tmp_dir=$(mktemp -d)

for component in "Demographics" "Dietary" "Examination" "Laboratory" "Questionnaire"; do
    scrape_datasets $component
done

jq -s 'add' ${tmp_dir}/*.json > Available_Datasets.json