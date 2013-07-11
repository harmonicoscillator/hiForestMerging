#!/bin/sh
# executable script to be submitted to condor

source /osg/app/cmssoft/cms/cmsset_default.sh
export SCRAM_ARCH=slc5_amd64_gcc462
cd /net/hisrv0001/home/luck/CMSSW_5_3_8_HI_patch2/src
eval `scramv1 runtime -sh` 
cd -

infile=$1
outfile=$2
destination=$3

filelist=""
for file in `cat $infile`
  do
  filelist="$filelist $file"
done

hadd $outfile $filelist

mv $outfile $destination/

echo "Done!"
