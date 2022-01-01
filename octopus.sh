#!/bin/bash
commits=$(echo $(git log -n 10 --pretty=format:'{%n  "Id": "%h",%n   "Comment": "%f"%n},' $@ | perl -pe 'BEGIN{print "["}; END{print "]\n"}' |  perl -pe 's/},]/}]/'))
# echo $commits
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
echo ${jsonBody} > tmp.json
clear=$(cat tmp.json | sed 's/\\"/\"/g')
tt=${clear/\"[{/\[{}
ttt=${tt/\}\]\"/\}\]}
echo $ttt | jq .
echo $ttt > buildinfo.json
docker run --rm -v $(pwd):/src  octopusdeploy/octo build-information \
       --package-id="PetClinic.web" \
       --version="1.0.200802.1002" \
       --file=buildinfo.json \
       --server=http://95.131.25.55:8080 \
       --apiKey=API-XVB8GHTWSLP0IP0P1XFRAPQ0H9SQPUCM \
       --overwrite-mode=OverwriteExisting # DELETE THIS
