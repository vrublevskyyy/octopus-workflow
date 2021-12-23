#!/bin/bash

commitMessage=$(git log -1 --pretty=oneline)
echo $commitMessage
commits=$(echo $(git log -n 10 --pretty=format:'{%n  "Id": "%h",%n   "Comment": "%f"%n},' $@ | perl -pe 'BEGIN{print "["}; END{print "]\n"}' |  perl -pe 's/},]/}]/'))
jsonBody=$(jq -n  \
          --arg commits "$commits" \
    '{
        "BuildEnvironment":"BitBucket",
        "Branch":"main",
        "BuildNumber":"288",
        "BuildUrl":"https://bitbucket.org/octopussamples/petclinic/addon/pipelines/home#!/results/288",
        "VcsType":"Git",
        "VcsRoot":"http://bitbucket.org/octopussamples/petclinic",
        "VcsCommitNumber":"314cf2c3ee916c92a384c2796a6abe332d678e4f",
        "Commits": $commits
        }')
echo $commits
echo "========================="
comma=$(echo $jsonBody | jq -r '.Commits')
jsonBody=$(jq -n -r  \
          --arg commits "$comma" \
    '{
        "BuildEnvironment":"BitBucket",
        "Branch":"main",
        "BuildNumber":"288",
        "BuildUrl":"https://bitbucket.org/octopussamples/petclinic/addon/pipelines/home#!/results/288",
        "VcsType":"Git",
        "VcsRoot":"http://bitbucket.org/octopussamples/petclinic",
        "VcsCommitNumber":"314cf2c3ee916c92a384c2796a6abe332d678e4f",
        "Commits": $commits
        }')
echo $jsonBody > buildinfo.json
echo "=========="
cat buildinfo.json
# docker run --rm -v $(pwd):/src  octopusdeploy/octo build-information \
#        --package-id="PetClinic.web" \
#        --version="1.0.200802.1002" \
#        --file=buildinfo.json \
#        --server=http://95.131.25.55:8080 \
#        --apiKey=API-CUNPLE38JKPGFKVRQWLXKVNGVO030EW7 \
#        --overwrite-mode=OverwriteExisting # DELETE THIS
