#! /bin/bash

curdir=$(pwd)
cd /home/odmb/my_dir_name

export CVS_RSH=ssh
export CVSROOT=username@cmscvs.cern.ch:/local/reps/CMSSW
export CVSROOT=:ext:username@cmscvs.cern.ch:/local/reps/tridas

cd TriDAS
cvs update
cd emu
rm -rf me11dev
cd ../../me11dev
cvs update
cd ..
cp -r me11dev TriDAS/emu/.
cp -r ../mfs/TriDAS/emu/compile.sh TriDAS/emu/.
sed -i 's/mfs/my_dir_name/' TriDAS/emu/compile.sh
cd TriDAS/emu
bash compile.sh

cd $curdir

exit 0