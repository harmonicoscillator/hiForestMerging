#!/bin/sh
# Part 2 of hadd script. Reads output of make.sh and submits one job
# for each txt file.

version=1

dataset=/mnt/hadoop/cms/store/user/richard/pp_photonSkimForest_v85_unmerged_separated
destination=/mnt/hadoop/cms/store/user/luck/partial_merge

mkdir -p $destination

dir=$dataset

jobcounter=1

for job in `ls *.txt`
do
    name=`echo $job | sed "s/txt/root/g"`
    if [ -f $destination/${name} ]; then
	echo "Job already submitted : $mergecounter"
    else
	inputList=$job
	if [ -f $inputList ]; then
	    echo "Submitting process input file: $inputList"
	    outfile=${name}
      	    Error=`echo $outfile | sed "s/root/err/g"`
	    Output=`echo $outfile | sed "s/root/out/g"`
	    Log=`echo $outfile | sed "s/root/log/g"`        
	    
	    echo "Input is : $inputList"
	    echo "Output is : $outfile"
	    echo "LFN is : $lfn"
	    echo "----------------------"
	    
	    cat > subfile <<EOF

Universe       = vanilla

# files will be copied back to this dir
Initialdir     = .

# run my script
Executable     = run.sh

+AccountingGroup = "group_cmshi.$(whoami)"
#+IsMadgraph = 1

Arguments      = $inputList $outfile $destination \$(Process)
# input files. in this case, there are none.
Input          = /dev/null

# log files
Error          = $Error
Output         = $Output
Log            = $Log

# get the environment (path, etc.)
Getenv         = True

# prefer to run on fast computers
Rank           = kflops


# should write all output & logs to a local directory
# and then transfer it back to Initialdir on completion
should_transfer_files   = YES
when_to_transfer_output = ON_EXIT
# specify any extra input files (for example, an orcarc file)
transfer_input_files    = $inputList

Queue
EOF

	    # submit the job
	    condor_submit subfile
	else
	    echo "Job not created yet : $mergecounter"
	fi
    fi
    jobcounter=$(($jobcounter + 1))
done



