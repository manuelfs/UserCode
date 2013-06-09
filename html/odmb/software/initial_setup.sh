#! /bin/bash

export CVS_RSH=ssh
export CVSROOT=username@cmscvs.cern.ch:/local/reps/CMSSW

cvs co -d odmbdev UserCode/manuelf/sw/odmbdev

export CVSROOT=:ext:username@isscvs.cern.ch/local/reps/tridas

cvs co TriDAS/emu
rm -r TriDAS/emu/odmbdev
cp -r odmbdev TriDAS/emu/.
cd TriDAS/emu/
bash compile.sh
cd ../..
