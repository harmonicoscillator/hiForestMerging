#!/bin/sh
# input folder
#INPUT="/mnt/hadoop/cms/store/user/richard/pA_photonSkimForest_v85_unmerged/pA_photonSkim_hiForest2_v85_*"
# output folder and name
#INPUT=""
#OUTPUT="/export/d00/scratch/luck/pA_photonSkimForest_v85.root"
#OUTPUT="pA_Pyquen_allQCDPhoton120_hiForest2_53x_2013-18-14-1922.root"

#root -b -l -x -q mergeForest_pPb.C+\(\"$INPUT\",\"$OUTPUT\"\)

for PTHAT in 30 50 80 120 170 220 280 370 
do
     for BATCH in 2 9
     do
 	FOLDER="/mnt/hadoop/cms/store/user/richard/pA_Pyquen_allQCDPhoton${PTHAT}b${BATCH}_hiForest2_53x_2013-18-14-1922"
 	echo "$FOLDER"
 	OUTPUT="$(basename ${FOLDER}).root"
 	echo "Output name : ${OUTPUT}"

 	INPUT="${FOLDER}/*.root"
 	root -b -l -x -q mergeForest.C+\(\"$INPUT\",\"$OUTPUT\"\)
 	echo "JOB DONE."
 	echo ""
     done
done

for PTHAT in 30 50 80 120 170 220 280 370
do
    INPUT="pA_Pyquen_allQCDPhoton${PTHAT}b*.root"
    OUTPUT="pA_Pyquen_allQCDPhoton${PTHAT}_hiForest2_53x_2013-18-14-1922.root"
    root -b -l -x -q mergeForest.C+\(\"$INPUT\",\"$OUTPUT\"\)
done
