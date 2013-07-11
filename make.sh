#!/bin/sh
# Part 1 of hadd script. Creates txt file with Nmerge input files each.
# Use submit.sh to read the txt files and submit condor jobs.

version=1

Nmerge=90

counter=1
mergecounter=1
jobcounter=1

dataset=/mnt/hadoop/cms/store/user/richard/pp_photonSkimForest_v85_unmerged_separated
destination=/mnt/hadoop/cms/store/user/luck/partial_merge
#dataset=/mnt/hadoop/cms/store/user/luck/partial_merge
#destination=/mnt/hadoop/cms/store/user/luck/pA_photonSkimForest_v85

mkdir -p $destination

name=pp_photonSkimForest_v85.root
dir=$dataset

echo "input       : $dataset"
echo "destination : $destination"

for infile in `ls -tr $dir | grep root`
do
    if [ $counter -lt $Nmerge ]; then  
	echo "file:$dir/$subdir/$infile" >> ${name}_$mergecounter.txt
	counter=$(($counter + 1))
        jobcounter=$(($jobcounter + 1))

    else
	echo "file:$dir/$subdir/$infile" >> ${name}_$mergecounter.txt
	inputList=${name}_$mergecounter.txt
	echo "Submitting process input file: $inputList"
	outfile=${name}_$mergecounter.root
	jobcounter=$(($jobcounter + 1))
	mergecounter=$(($mergecounter + 1))
	counter=1
    fi
done
