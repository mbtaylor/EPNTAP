#!/bin/sh

# Requires stilts (http://www.starlink.ac.uk/stilts) v3.4-2 or later

# Checks that the UCDs used in the LaTeX source document are legal UCD1+.

# Variables.
stilts=stilts
doc=EPNTAP.tex
ucdlist=ucdlist.txt

# Extract all the words inside \ucd{} macros in the document.
# This is a bit ad-hoc; it might need some adjustment if transferring
# to other documents.
cat $doc \
   | grep -v '^ *\\def' \
   | sed -e's/\(\\ucd{[^}]*}\)/\n\1\n/g' \
   | grep '^\\ucd{.*}' \
   | sed -e's/^\\ucd{\(.*\)}/\1/' \
   | sort \
   | uniq \
   >$ucdlist

# Assert for each line in the ucdlist file that it contains a valid UCD.

msgTxt=""
# Error messages will be improved if the following line is uncommented,
# but it requires STILTS version >3.4-4.
# msgTxt='ucd+\"->\"+ucdMessage(ucd)'

$stilts tpipe in=$ucdlist ifmt=ascii omode=discard \
              cmd='colmeta -name ucd $1' \
              cmd="assert ucdMessage(ucd)==null $msgTxt" \
&& rm -f $ucdlist

