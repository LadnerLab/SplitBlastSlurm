#!/bin/bash
#SBATCH --time=5:00
#ABATCH --workdir=.


temp_dir=$2
# Header Added to files produced
$header='Query Name\tQuery Length\tSubject Name\tSubject Length\tAlignment Length\tQuery StartQuery End\tSubject Start\tSubject End\tHsp Score\tHsp Expect\tHsp Identities\tPercent Match\tNumber of Gaps\n'

echo -e "Query Name\tQuery Length\tSubject Name\tSubject Length\tAlignment Length\tQuery StartQuery End\tSubject Start\tSubject End\tHsp Score\tHsp Expect\tHsp Identities\tPercent Match\tNumber of Gaps\n" >> out.txt

for file in $( ls "$temp_dir" ); do 
    # Add each result to the output file
    num_lines=$( grep -c '' $temp_dir/$file ) 
    if [[ $num_lines -gt 0 ]] && [[ $file == *_parsed.txt ]]; then
       cat "$temp_dir/$file" >> out.txt	
    fi
done

# If the --keepOut flag was not used, remove files after all outputs were combined
if   [[ $3 = 0 ]]; then 
    rm -rf $temp_dir *.nin *.nsq *.nhr "$QUERY_*" "*_no_good_hits*" slurm-* pyoutput blastn_*
fi



