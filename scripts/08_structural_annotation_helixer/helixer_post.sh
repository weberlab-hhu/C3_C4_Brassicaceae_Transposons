#!/bin/bash

# this requires the path to the _trial_ directory as it's single argument
# e.g. $HOME/nni-experiments/<NNI-ID>/trials/<TRIAL-ID>
trial=$1

# all other paths / file names are derived from the original data path, as follows
x=`cat $trial/parameter.cfg`
genome_dat=`echo $x|grep -o "test_data.*test_data.h5"|sed 's/.*"//g'`
y=`echo $genome_dat|sed 's@/test_data.h5@@g'`
sp=`echo $y|sed 's@.*/@@g'`
outdir=`echo $y|sed 's@/h5s/@/helixer_post/@g'`

mkdir -p $outdir

helixer_post_bin $genome_dat $trial/predictions.h5 100 0.1 0.8 60 $outdir/$sp.gff3 2> $outdir/hp.err > $outdir/hp.out

