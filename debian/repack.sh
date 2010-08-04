#!/bin/bash
# Repackage SPM8 upstream sources, strip unnecessary files, and convert zip into
# tar.gz archive.
#
# The script also determines a version of the respective SPM source snapshot.
# This is done by using the latest modification date of any file in the tarball.
# Reason: SPM doesn't have any versioning (other than the major version) which
# makes it impossible to judge which version one is using.
#
#
# Usage:
#   repack.sh <spm8.zip>
#

set -e

ORIGSRC=$1
if [ -z "$ORIGSRC" ]; then
	echo "No upstream sources given."
	exit 1
fi

CURDIR=$(pwd)
WDIR=$(mktemp -d)
SUBDIR=spm8
PACKAGENAME=spm8
SPM_MAJORVERSION=8

# put upstream sources into working dir
ORIGSRC_PATH=$(readlink -f ${ORIGSRC})
cd $WDIR
echo "Unpacking sources"
unzip -q $ORIGSRC_PATH

# cleanup
# leftovers from previous compile runs
find $SUBDIR -name '*.mex*' -delete
# strip compiled manuals, but keep individual figures in PDF format
rm -f $SUBDIR/man/manual.pdf
rm -f $SUBDIR/external/ctf/CTF_MATLAB_v13.pdf
# remove binary only pieces
rm -rf $SUBDIR/external/yokogawa
# actually remove all third party software
rm -rf $SUBDIR/external


echo -n "Determine SPM version: "
# Upstream does not have its own version string ...
# therefore we are going to use the latest modification date of any file in the
# sources
UPSTREAM_VERSION="$SPM_MAJORVERSION.$(LC_ALL=C find . -type f -exec ls -og --time-style=long-iso {} \; |sort --key 4 |tail -n1 | cut -d ' ' -f 4,4 | tr -d "-")"
ORIG_VERSION="$UPSTREAM_VERSION.1~dfsg.1"

echo "Determined version: $UPSTREAM_VERSION"
echo "Debian orig version: $ORIG_VERSION"

mv $SUBDIR $PACKAGENAME-$ORIG_VERSION.orig
tar czf ${PACKAGENAME}_$ORIG_VERSION.orig.tar.gz ${PACKAGENAME}-$ORIG_VERSION.orig
mv ${PACKAGENAME}_$ORIG_VERSION.orig.tar.gz $CURDIR

# clean working dir
rm -rf $WDIR

echo "Tarball is at: $CURDIR/${PACKAGENAME}_$ORIG_VERSION.orig.tar.gz"

