#!/bin/bash

commitMessage=$(git log -1 --pretty=oneline)
echo $commitMessage
commits=$(echo $(git log -n 10 --pretty=format:'{%n  "Id": "%h",%n   "Comment": "%f"%n},' $@ | perl -pe 'BEGIN{print "["}; END{print "]\n"}' |  perl -pe 's/},]/}]/'))
jsonBody=$(jq -nr --arg v "${commits}" '{
        "BuildEnvironment":"BitBucket",
        "Branch":"main",
        "BuildNumber":"288",
        "BuildUrl":"https://bitbucket.org/octopussamples/petclinic/addon/pipelines/home#!/results/288",
        "VcsType":"Git",
        "VcsRoot":"http://bitbucket.org/octopussamples/petclinic",
        "VcsCommitNumber":"314cf2c3ee916c92a384c2796a6abe332d678e4f",
        "Commits": $v
        }')
echo $jsonBody
echo "========================="
jsonBody=$(jq \
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
echo $jsonBody
# docker run --rm -v $(pwd):/src  octopusdeploy/octo build-information \
#        --package-id="PetClinic.web" \
#        --version="1.0.200802.1002" \
#        --file=buildinfo.json \
#        --server= \
#        --apiKey= \
#        --overwrite-mode=OverwriteExisting # DELETE THIS
