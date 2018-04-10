#!/bin/bash
#SBATCH --job-name=split_blast
#SBATCH --time=5:00
#SBATCH --workdir=.

module load python
module load anaconda
module load blast+/2.7.1


# Constants used by parts of the script
BLASTSCRIPT=split_blast.py
SPLIT_SCRIPT=split_fastas.py
DEFAULT_TEMP=temp
KEEPOUT=0
combine_file="combine_outputs.sh"
working_dir="$PWD"

POSITIONAL=()
args=()

# Run through all of the arguments provided from command line
while [[ $# -gt 0 ]]
do
key="$1"
if ! [[ -z "$key" ]]; then
    args+=("$1")
    args+=("$2")
fi

case $key in
    -q|--query)
    QUERY="$2"
    shift # past argument
    shift # past value
    ;;

    --ns|--nucSubject)
    NUCSUBJECT="$2"
    shift # past argument
    shift # past value
    ;;

    --ps|--protSubject)
    PROTSUBJECT="$2"
    shift # past argument
    shift # past value
    ;;

    --withColor)
    WITHCOLOR="$2"
    shift # past argument
    shift # past value
    ;;

    -n|--numProcs)
    NUMPROCS="$2"
    shift
    shift
    ;;

    -t|--temp)
    TEMP="$2"
    shift
    shift
    ;;

    -b|--blastType)
    BLASTTYPE="$2"
    shift
    shift
    ;;

    --dontIndex)
    DONTINDEX="$2"          
    shift
    shift
    ;;

    -k|--keepOut)
    KEEPOUT=1
    shift
    shift
    ;;
    
    --blastFull)
    BLASTFULL="$2"
    shift
    shift
    ;;

    --task)
    TASK="$2"
    shift
    shift
    ;;

    --evalue)
    EVALUE="$2"
    shift
    shift
    ;;
    
    --outFmt)
    OUTFMT="$2"
    shift
    shift
    ;;
    
    --numHits)
    NUMHITS="$2"        
    shift
    shift
    ;;

    --numHsps)
    NUMHSPS="$2"          
    shift
    shift
    ;;

    --goodHit)
    GOODHIT="$2"
    shift
    shift
    ;;
    
    --orfSize)
    ORFSIZE="$2"
    shift
    shift
    ;;

    -h|--help)
    python $BLASTSCRIPT -h 
    shift
    shift
    exit 1
    ;;

    *)
    POSITIONAL+=("$1")
    shift
    ;;
        
    
esac
done

if [ "$OUTFMT" = "" ]; then
    OUTFMT=5
fi
if [ -z "$TEMP" ]; then
    TEMP=$DEFAULT_TEMP
fi

# Read all of the command-line arguments into a variable
# Split the query file into multiple temporary files for blasting
if [ "$QUERY" ]; then
    srun $SPLIT_SCRIPT -q $QUERY -t "$workign_dir$TEMP" --numProcs $NUMPROCS
else
    srun echo "Fasta query file must be provided for script to execute."
    exit 1
fi

# Get the number of files created by split_fastas
num_files= ls "$working_dir/$TEMP" | wc -l
output=0

# Call split_blast on the rest of the files in the directory 
# with the args passed in 
jobnumber=""
args=($(echo "${args[@]}" |tr ' ' '\n' | uniq | tr '\n' ' '))
shopt -s nullglob
for file in "$TEMP"/*
do
    echo TEMP: "$TEMP/$file.sh"
    # Create a file to run the blast, save its jobnumber 
    echo '#!/bin/sh' >> "$file.sh"
    echo '#SBATCH --time=5:00' >> "$file.sh"
    echo '#SBATCH --output=pyoutput' >> $file.sh

    echo module load python >> "$file.sh"
    echo module load anaconda >> "$file.sh"
    echo module load blast+/2.7.1 >> "$file.sh"

    # We don't want to recreate the database for each blast, so only do it on the first
    if [[ -z "$jobnumber" ]] ; then
        echo ${args[@]}
        echo srun $BLASTSCRIPT -q $file ${args[@]:2} >> "$file.sh"
    else
        echo srun $BLASTSCRIPT -q $file ${args[@]:2} --dontIndex >> "$file.sh"
    fi

    output=$( sbatch "$file.sh" )
    echo $output
    jobnumber+="$( echo $output | cut -d ' ' -f 4 )":
done


# Combine files after the last blast has been completed
jobnumber="${jobnumber:0:${#jobnumber} -1}"
sbatch --dependency=afterok:$jobnumber $combine_file -t $TEMP $KEEPOUT 


