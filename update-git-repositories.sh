#!/bin/sh
repositories="aleksi dotpipeR shell-scripts etc doc"
for repo in ${repositories}; do
    cd ${HOME}/repo
    git add -u
    git commit
    git push
done
