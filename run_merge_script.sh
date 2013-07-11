#!/bin/sh
# input folder
INPUT="/mnt/hadoop/cms/store/user/richard/pA_photonSkimForest_v85_unmerged/pA_photonSkim_hiForest2_v85_*"
# output folder and name
OUTPUT="/export/d00/scratch/luck/pA_photonSkimForest_v85.root"

root -b -l -x -q mergeForest_pPb.C+\(\"$INPUT\",\"$OUTPUT\"\)
