#! /usr/bin/env bash
#
export binDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

pushd $binDir/gs_350
	rm -rf extent0.rowan_350.dbf.zip
	zip extent0.rowan_350.dbf.zip extent0.rowan_350.dbf
popd

