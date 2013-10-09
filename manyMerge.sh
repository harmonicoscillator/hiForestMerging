#!/bin/bash

#List of samples
# AllQCDPhotons:
#   30 DONE 845 DONE
#   50 DONE 847 DONE
#   80 DONE 844 DONE
#   120 DONE 758 DONE
#   170 DONE 749 DONE
#
# EmEnrichedDijet
#   30 DONE 821 DONE
#   50 DONE 812 DONE
#   80 DONE 743 DONE
#   120 DONE 842 DONE
#   170 DONE 838 FORESTING



for SAMPLETYPE in AllQCDPhotons EmEnrichedDijet
do
    for PTHAT in 30 50 80 120 170
    do
	now="submit_$(date +"%Y-%m-%d__%H_%M_%S")_${SAMPLETYPE}${PTHAT}"
	mkdir -p $now
	echo "Working directory: $now"
	logdir="$HOME/CONDOR_LOGS/mergeLogs/$now"
	mkdir -p $logdir
	echo "Logs will be placed in: $logdir"

	DATASET=/mnt/hadoop/cms/store/user/luck/PbPb_pythiaHYDJET_forest_${SAMPLETYPE}${PTHAT}_unmerged/*.root
	DESTINATION=/mnt/hadoop/cms/store/user/luck/PbPb_pythiaHYDJET_forest_${SAMPLETYPE}${PTHAT}
	mkdir -p $DESTINATION
	OUTFILE=PbPb_pythiaHYDJET_forest_${SAMPLETYPE}${PTHAT}.root
	#echo hadd -f ${OUTFILE} "${DATASET}/*.root" 
	cat > $now/manyMerge.condor <<EOF
Universe     = vanilla
Initialdir   = $PWD/$now
Notification = Error
Executable   = $PWD/$now/merge.sh
Arguments    = $OUTFILE "$DATASET" $DESTINATION
GetEnv       = True
Output       = $logdir/\$(Process).out
Error        = $logdir/\$(Process).err
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

