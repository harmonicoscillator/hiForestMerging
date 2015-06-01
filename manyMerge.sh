#!/bin/bash

#List of samples
# AllQCDPhotons:
#   30
#   50
#   80
#   120
#   170
#
# EmEnrichedDijet
#   30
#   50
#   80
#   120
#   170

now1="submit_$(date +"%Y-%m-%d__%H_%M_%S")"

for DIRECTION in pPb Pbp
do
    for SAMPLETYPE in AllQCDPhoton EmEnriched
    do
	for PTHAT in 30 50 80 120 170
	do
	    now="${now1}_${DIRECTION}_${SAMPLETYPE}${PTHAT}"
	    mkdir -p $now
	    echo "Working directory: $now"
	    #logdir="$HOME/CONDOR_LOGS/mergeLogs/$now"
	    #mkdir -p $logdir
	    #echo "Logs will be placed in: $logdir"

	    DATASET=/mnt/hadoop/cms/store/user/richard/2014-photon-forests/${DIRECTION}_MIX_${SAMPLETYPE}${PTHAT}_localJEC_v3/*.root
	    DESTINATION=/mnt/hadoop/cms/store/user/luck/2014-photon-forests/${DIRECTION}_MIX_localJEC_v3/
	    mkdir -p $DESTINATION
	    OUTFILE=${DIRECTION}_MIX_${SAMPLETYPE}${PTHAT}_localJEC_v3.root
	    #echo hadd -f ${OUTFILE} "${DATASET}/*.root" 
	    cat > $now/manyMerge.condor <<EOF
Universe     = vanilla
Initialdir   = $PWD/$now
Notification = Error
Executable   = $PWD/$now/merge.sh
Arguments    = $OUTFILE $DATASET $DESTINATION
GetEnv       = True
#Output       = $logdir/\$(Process).out
#Error        = $logdir/\$(Process).err
#Log          = $logdir/\$(Process).log
Rank         = Mips
+AccountingGroup = "group_cmshi.$(whoami)"
should_transfer_files = YES
when_to_transfer_output = ON_EXIT
#transfer_input_files = 

Queue

EOF

	    cat > $now/merge.sh <<EOF
#!/bin/sh
hadd -f \$1 \$2
mv \$1 \$3

EOF
	    condor_submit $now/manyMerge.condor
	done
    done
done
