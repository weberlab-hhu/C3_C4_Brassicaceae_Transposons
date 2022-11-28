#!/bin/bash
# this script takes one argument, the path to the fasta file
input=$1

# generate output path/file names, based on input path name
outdir=`echo $input |cut -f1-3 -d/ | sed 's@raw/@h5s/@g'`
species=`echo $input|cut -f3 -d/`

mkdir -p $outdir

# convert data
$hppath/export.py --output-path $outdir/test_data.h5 --chunk-size 106920 --species $species --direct-fasta-to-h5-path $input --no-multiprocess 2> $outdir/export.err > $outdir/export.out
# to accomplish the same in v0.3*, change this to:
#fasta2h5.py --h5-output-path $outdir/test_data.h5 --subsequence-length 106920 --species $species --fasta-path $input --no-multiprocess 2> $outdir/export.err > $outdir/export.out

