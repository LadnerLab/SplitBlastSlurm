#!/bin/bash
#SBATCH --time=5:00
#ABATCH --chdir=.


temp_dir=$2
query="$4"

count=0
for file in $( ls "$temp_dir" ); do 
    # Add each result to the output file
    num_lines=$( grep -c '' $temp_dir/$file ) 

    if [[ $num_lines -gt 0 ]] && [[ $file == *_parsed.txt ]]; then
        out_file="$query".$( echo "$file" | cut -d '.' -f 2- )
        echo "$out_file"
        if [[ $count -eq 0 ]]; then
            echo -e "Query Name\tQuery Length\tSubject Name\tSubject Length\tAlignment Length\tQuery Start\tQuery End\tSubject Start\tSubject End\tHsp Score\tHsp Expect\tHsp Identities\tPercent Match\tNumber of Gaps" >> "$out_file"
            count=1

        fi
       cat "$temp_dir/$file" >> "$out_file"
    fi
done

# If the --keepOut flag was not used, remove files after all outputs were combined
if   [[ $3 = 0 ]]; then 
    rm -rf $temp_dir *.nin *.nsq *.nhr "$QUERY_*" "*_no_good_hits*" slurm-* pyoutput blastn_*
fi



