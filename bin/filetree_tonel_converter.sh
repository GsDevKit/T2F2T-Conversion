#! /bin/bash

# Convert packages between tonel and filetree file format

binDir=$(dirname "$0")
if [ "$GEMSTONE" = "" ]; then
  export GEMSTONE="$binDir/gs_350/GemStone64Bit3.5.0-x86_64.Linux"
fi

$GEMSTONE/bin/topaz -l -q -C"GEM_SOLO_EXTENT=extent0.rowan.dbf" -S $binDir/filetree_tonel_converter.tpz -- $*
if [ $? != 0 ]; then 
  echo "ERRORs from topaz"
  exit 1
fi

