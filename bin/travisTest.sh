#!/bin/bash

# convert tonel format to filetree format --- expect filetree to be updated before push to github
bin/t2f2t.sh filetree rowan

if [ ! -z "$(git status --porcelain)" ]  ; then 
		echo "FAIL: unexpected changes in filetree directory"
		exit 1
else 
	echo "successful test"
fi

