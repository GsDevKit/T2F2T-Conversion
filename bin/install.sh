#! /usr/bin/env bash
#
export binDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

releaseVersion="v1.0.0-beta"

pushd $binDir/gs_350
	rm -rf extent0.rowan_350.dbf.zip extent0.rowan_350.dbf
	curl  -L -O -s -S "https://github.com/GsDevKit/T2F2T-Conversion/releases/download/$releaseVersion/extent0.rowan_350.dbf.zip"
	unzip -q extent0.rowan_350.dbf.zip
	chmod -w extent0.rowan_350.dbf
popd

if [ "$GS_HOME"x = "x" ] ; then
	# GS_HOME not installed direct download the product
	PLATFORM="`uname -sm | tr ' ' '-'`"
	[ $PLATFORM = "Darwin-x86_64" ] && PLATFORM="Darwin-i386"
	case "$PLATFORM" in
    Darwin-i386)
      dlvers="GemStone64Bit3.5.0-i386.Darwin"
      ;;
    Linux-x86_64)
      # Linux looks OK
      dlvers="GemStone64Bit3.5.0-x86_64.Linux"
      ;;
		*) echo "This script should only be run on Mac (Darwin-i386) or Linux (Linux-x86_64). The result from \"uname -sm\" is \"`uname -sm`\""
			exit 1
			;;
	esac
	# set zipfile name from gsvers
	dl_gss_file=${dlvers}.zip

	# set ftp_address
	ftp_address=https://downloads.gemtalksystems.com
	# Look for either wget to download GemStone
	if [ -e "`which wget`" ]; then
    cmd="`which wget` --no-verbose"
	else
  	if [ -e "`which curl`" ]; then
      cmd="`which curl` -O -s -S"
  	else
    	echo "wget or curl is not available. Install wget or curl and rerun this script."
			exit 1
  	fi
	fi
	$cmd ${ftp_address}/pub/GemStone64/3.5.0/$dl_gss_file
	unzip $dl_gss_file
else
	$GS_HOME/bin/downloadGemStone 3.5.0
	pushd $binDir/gs_350
		ln -s $GS_HOME/shared/downloads/product/GemStone64Bit3.5.0-x86_64.Linux .
	popd
fi
