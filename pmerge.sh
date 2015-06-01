#!/bin/bash

if [[ $# -ne 3 ]]
then
  echo "Usage: ./pmerge.sh <input-list> <out-dir> <files-per-job>"
  exit 1
fi

now="submit_$(date +"%Y-%m-%d__%H_%M_%S")"
mkdir $now
echo "Working directory: $now"
#logdir="$HOME/CONDOR_LOGS/mergeLogs/$now"
#mkdir -p $logdir
#echo "Logs will be placed in: $logdir"

len=$(wc -l $1 | awk '{print $1}')
filesperjob=$3
njobs=$((len/filesperjob+1))
echo "$len files, with $njobs jobs"

cp $1 $now
mkdir -p $2

echo "compiling merge script"
g++ mergeForest.C $(root-config --cflags --libs) -Werror -Wall -O2 -o mergeForest.exe || exit 1

cp mergeForest.exe $now

cat > $now/pmerge.condor <<EOF
Universe     = vanilla
Initialdir   = $PWD/$now
Notification = Error
Executable   = $PWD/$now/merge.sh
Arguments    = \$(Process) $1 $2 $3
GetEnv       = True
#Output       = $logdir/\$(Process).out
#Error        = $logdir/\$(Process).err
#Log          = $logdir/\$(Process).log
Rank         = Mips
+AccountingGroup = "group_cmshi.$(whoami)"
should_transfer_files = YES
when_to_transfer_output = ON_EXIT
transfer_input_files = $1,mergeForest.exe

Queue $njobs

EOF

cat > $now/merge.sh <<EOF
start=\$(((\$1+1)*\$4))
mkdir mergedTmp
cat \$2 | head -n \$start | tail -n \$4 | awk -v filename=\$1 -v outdir=\$3 -v nfiles=\$4 '{print "ln -s "\$1" mergedTmp/"}' | bash

echo | awk -v filename=\$1 -v outdir=\$3 -v nfiles=\$4 '{print "./mergeForest.exe \"mergedTmp/*.root\" \""filename".root\""}' | bash
mv \$1.root \$3

EOF

#cat $now/pmerge.condor
#cat $now/merge.sh
#echo condor_submit $now/pmerge.condor
condor_submit $now/pmerge.condor
