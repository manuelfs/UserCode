#! /bin/bash

export CVS_RSH=ssh
export CVSROOT=username@cmscvs.cern.ch:/local/reps/CMSSW

cvs co -d me11dev UserCode/FGolf/TriDAS/emu/me11dev

export CVSROOT=:ext:username@isscvs.cern.ch/local/reps/tridas

cvs co TriDAS/emu
rm -r TriDAS/emu/me11dev
cp -r me11dev TriDAS/emu/.
cd TriDAS/emu/
cp /home/odmb/mfs/TriDAS/emu/compile.sh .
sed -i 's/mfs/my_dir_name/' compile.sh
bash compile.sh
cd ../..
