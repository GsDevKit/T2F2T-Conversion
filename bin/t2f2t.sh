#!/bin/bash

# Convert packages between tonel and filetree file format

export binDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
export GEMSTONE="$binDir/gs_350/GemStone64Bit3.5.0-x86_64.Linux"

$GEMSTONE/bin/topaz -i -l -q -C "GEM_SOLO_EXTENT=$binDir/gs_350/extent0.rowan_350.dbf" -S $binDir/t2f2t.tpz -- $*

if [ $? != 0 ]; then 
  echo "ERRORs from topaz"
  exit 1
fi

