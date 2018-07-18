# SplitBlastSlurm
Scripts to multiplex BLAST jobs on a server managed by slurm



Usage: split_blast.py [options]

Options:
-h, --help            show this help message and exit
-q QUERY, --query=QUERY
                      Fasta query file. Can be a comma specified list of
                      fastas also. [None, Required]
--ns=NS, --nucSubject=NS
                      Fasta file of nucleotide sequences to  compare the
                      query sequences to. Will format if necessary. [None]
--ps=PS, --protSubject=PS
                      Fasta file of protein sequences to compare the query
                      sequences to. Will format if necessary. [None]
--withColor           Use this flag if you want the colored version of the
                      parsed output to be produced.
-n NUMPROCS, --numProcs=NUMPROCS
                      Number of separate blasts to start [4]
-t TEMP, --temp=TEMP  Name for the temporary working directory. Will be
                      created  at the beginning of the script and deleted at
                      the at the end.[/.temp]
-b BLASTTYPE, --blastType=BLASTTYPE
                      Type of blast to run. Options blastn, blastx, blastp,
                      tblastx, tblastn. [blastn or blastx or blastn, blastx]
--dontIndex           Use this flag if you don't want the sciprt to try and
                      index the database. This is necessary for complex
                      databases like nt and nr
--keepOut             Use this flag if you don't want to delete the non-
                      parsed blast files automatically if format not XML]
--blastFull           Blast full query for each task [automatically used if
                      out format not XML]
--task=TASK           Type of blastn to run. Options are blastn, dc-
                      megablast, megablast. [megablast, dc-megablast,
                      blastn]
--evalue=EVALUE       Maximum evalue for hit to be recorded [10]
-o OUTFMT, --outFmt=OUTFMT
                      Integer specifying the number of blast hits to report
                      per query/subject pair. [5]
--numHits=NUMHITS     Integer specifying the number of blast hits to report
                      per query. [5]
--numHsps=NUMHSPS     Integer specifying the number of alignments to report
                      per query/subject pair. [1]
--goodHit=GOODHIT     Floating point number specifying  the evalue necessary
                      for  a hit to be significant. [0.05]
--orfSize=ORFSIZE     Integer specifying the minimum size for an open
                      reading frame to be considered significant [100]
--cleanUp=CLEANUP     
