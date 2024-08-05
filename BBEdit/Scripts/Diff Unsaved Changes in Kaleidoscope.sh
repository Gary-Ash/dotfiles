#!/bin/bash
#
# Diff Unsaved Changes in Kaleidoscope
# Version 1.0
# Build 1
#
# A BBEdit script to send unsaved changes to Kaleidoscope for diffing.
# Kaleidoscope Team
# hello@kaleidoscope.app
#
##

if [ ! -f /usr/local/bin/ksdiff ]; then
	echo "ksdiff not found" 1>&2
	echo "" 1>&2
	echo "Download Kaleidoscope from https://kaleidoscope.app." 1>&2
	echo "Install ksdiff by selecting Kaleidoscope > Integrations… from the menu." 1>&2
	echo "Then select ksdiff from the sidebar and click Install on the right." 1>&2
	exit 1
fi

if [ -f "$BB_DOC_PATH" ]; then
	/usr/local/bin/ksdiff "$BB_DOC_PATH" -
else
	/usr/local/bin/ksdiff -l "$BB_DOC_NAME" -
fi
