
# By Jason Ladner
#Example command: 'sub_blast_parse.py --reg_out name --color_out name --no_hits name --numHits # --numHsps # --goodHit #.# --xml file'


from __future__ import division
import sys, optparse, os, math, random
from Bio.Blast import NCBIXML

#In version 1.1, made colored output optional
#In version 1.2, fixed no_good_hits reporting bug

def main():

    #To parse command line
    usage = "usage: %prog [options]"
    p = optparse.OptionParser(usage)
    
    #Input/output files
    p.add_option('--reg_out', help='Name to be given for the regular output file [None, Required]')
    p.add_option('--color_out', help='Name to be given to the colored output file. [None, Opt]')
    p.add_option('--no_hits', help='Name of file to write the names of queries that do not have significant hits [None, Required]')
    p.add_option('--xml', help='Name of the xml file that is to be parsed [None, Required]')
    
    #Blast options
    p.add_option('--numHits', type='int', default=5, help='Integer specifying the number of blast hits to report per query. [5]')
    p.add_option('--numHsps', type='int', default=1, help='Integer specifying the number of alignments to report per query/subject pair. [1]')

    #To determine what goes to next blast stage
    p.add_option('--goodHit', type='float', default=0.05, help='Floating point number specifying the evalue nec. for a hit to be significant. [0.05]')

    
    opts, args = p.parse_args()

    parse_sub_blast(opts)


#Doesn't return anything anymore, just writes everything to temporary output files
def parse_sub_blast(info):
    out_parse = open(info.reg_out, 'w')
    no_good_hits = open(info.no_hits ,'w')
    if info.color_out: col_out_parse = open(info.color_out, 'w')

    result_handle = open(info.xml)
    blast_records = NCBIXML.parse(result_handle)
    
    for rec in blast_records:
        if len(rec.alignments) >0:                                                                      #I believe that this verifies that there is at least one reportable hit
            if len(rec.alignments)>info.numHits: numhits=info.numHits                                                         #Determines # of hits to report, max is currently five
            else: numhits = len(rec.alignments)
            for hit in range(numhits): 
                alignment=rec.alignments[hit]                                                           #Pulls out the alignment info for the top hit
                #If top hit is not 'good', then add it to the list of queries without significant hits
                if hit==0 and float(alignment.hsps[0].expect)>info.goodHit: no_good_hits.write('%s\n' % rec.query)
                if len(alignment.hsps)>info.numHsps: numhsps=info.numHsps
                else: numhsps=len(alignment.hsps)
                for this_hsp in range(numhsps):
                    first_hsp=alignment.hsps[this_hsp]                                                           #Pulls out the top HSP info for the top hit
                    hit=[rec.query, rec.query_length, alignment.title, alignment.length, first_hsp.align_length, first_hsp.query_start, first_hsp.query_end, first_hsp.sbjct_start, first_hsp.sbjct_end, first_hsp.score, first_hsp.expect, first_hsp.identities, float(first_hsp.identities)/int(first_hsp.align_length), first_hsp.gaps]
                    out_parse.write('%s\n' % recursive_join(hit))
                    if info.color_out: 
                        colored_hit = make_colored(hit[:])
                        col_out_parse.write('%s\n' % recursive_join(colored_hit))

        #If there are no hits good enough to report
        else: no_good_hits.write('%s\n' % rec.query)
    result_handle.close()
    out_parse.close()
    no_good_hits.close()
    if info.color_out: col_out_parse.close()
    return True


def recursive_join(list, delimiter="\t"):
    ready_to_join = []
    for index, value in enumerate(list):
        if type(value) == type(()) or type(value) == type([]):
            ready_to_join.append(recursive_join(value))
        elif type(value) == type(1) or type(value) == type(1.0): 
            ready_to_join.append(str(value)) 
        else: 
            ready_to_join.append(value)
            
    joined=delimiter.join(ready_to_join)
    return joined

def make_colored(hit):
    hit[1] = '\033[91m' + str(hit[1]) + '\033[0m'
    hit[4] = '\033[95m' + str(hit[4]) + '\033[0m'
    hit[10] = '\033[96m' + str(hit[10]) + '\033[0m'
    hit[12] = '\033[92m' + str(hit[12]) + '\033[0m'
    return hit


###---------------------------->>>

if __name__ == "__main__":
    main()  


