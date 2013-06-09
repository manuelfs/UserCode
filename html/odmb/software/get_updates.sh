#! /bin/bash

curdir=$(pwd)
cd /home/odmb/my_dir_name

export CVS_RSH=ssh
export CVSROOT=username@cmscvs.cern.ch:/local/reps/CMSSW
export CVSROOT=:ext:username@cmscvs.cern.ch:/local/reps/tridas

cd TriDAS
cvs update
cd emu
rm -rf odmbdev
cd ../../odmbdev
cvs update
cd ..
cp -r odmbdev TriDAS/emu/.
cd TriDAS/emu
bash compile.sh

cd $curdir

exit 0