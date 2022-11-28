# Creating structural gene annotation with Helixer

This was performed at the commits Helixer bb840b4, GeenuFF 1f6cffb, and 
HelixerPost 08c6215

Updates to the code since mean that this is not the _recommended_ way anymore,
but uncommented code in the scripts are provided exactly as used for accuracy.

Comments have been added to indicate where scripts or commands would need to be 
changed to run with more current (e.g. v0.3) versions of the code.
And for clarity / explanation.

## Structure

The scripts assume the input is provided in the following format

```
raw/<researcher>/
├── b_gravinae
│   └── b_gravinae.fasta
├── b_juncea
│   └── b_juncea.fasta
├── b_napus
│   └── b_napus.fasta
├── b_nigra
│   └── b_nigra.fasta
...
```

The final gff3 output + log files will then end up here

```
helixer_post/<researcher>/
├── b_gravinae
│   ├── b_gravinae.gff3
│   ├── hp.err
│   └── hp.out
├── b_juncea
│   ├── b_juncea.gff3
│   ├── hp.err
│   └── hp.out
├── b_napus
│   ├── b_napus.gff3
│   ├── hp.err
│   └── hp.out
├── b_nigra
│   ├── b_nigra.gff3
│   ├── hp.err
│   └── hp.out
...
```

(example excerpt only)

## Annotating

### generate numeric encoding of genome sequence
This step takes the CATGs from the fasta file, and encodes
them as 1-hot (except ambiguity characters) numeric
vectors for inputting into our network.


example to run one sequence
```
bash toh5.sh raw/<researcher>/b_gravinae/b_gravinae.fasta
```

### raw base-wise predictions of genic class & phase
This part has to run on the GPU, and it was easiest
to do so for the number of species used with nni,
which uses the files 'config.yml' and 'search_space.json'.

#### prep
##### Acquire the trained model.
E.g. 
```
wget https://uni-duesseldorf.sciebo.de/s/C68s4YLv5ZqqXus/download
mv download land_plant_v0.3_m_0100.h5
```
(for clarity note that `land_plant_v0.3_m_0100.h5` and `fullmoon_211117_17.h5`
are two names for the same model)

##### prep search\_space.json
This file requires full paths to the model and the h5 files created
above to be set exactly for the machine in question. The provided
file is an example only.

#### Start all predictions
```
export hppath=<path/to/repository>/Helixer
nnictl create -c config.yml
```

which then generates a folder `$HOME/nni-experiments/<NNI-ID>`
with the results. Each species in search_space.json,
will be in a different trial folder: `$HOME/nni-experiments/<NNI-ID>/trials/<TRIAL-ID>`

### post processing into final predictions

run once for each trial ID / species

```
bash helixer_post.sh $HOME/nni-experiments/<NNI-ID>/trials/<TRIAL-ID>
```

And you're done, this should create the gff3 files, e.g. 

`helixer_post/<researcher>/b_gravinae/b_gravinae.gff3`


## Recommendation.
This three step process made sense when running the previous version
of the code and still does for running many genomes with unbalanced 
GPU vs CPU availability.
However, to run on a single genome and also just to take advantage of usability
improvements, the above could now be accomplished for any single genome
as shown below using b\_granvinae as an example (structure simplified).

```
Helixer.py --fasta-path b_gravinae.fasta \
    --gff-output-path b_gravinae.gff3 --species b_gravinae
    --overlap-core-length=53460 --overlap-offset=13365
    --lineage land_plant
```

This method additionally provides exact instructions on how to download the 
best available model for the lineage, if not already present. 

