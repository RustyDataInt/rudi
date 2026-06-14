---
title: "Pipeline Actions"
parent: "Command Structure"
has_children: false
nav_order: 20
---

## {{ page.title }}

HPC pipelines each have a set of 
**actions** - the staged units of work they are intended to accomplish,
encoded in the pipeline's configuration - 
and **subcommands** - pipeline-level management actions handled by the 
RuDI pipelines framework. 

For example, here is the inline help for the `svCapture` pipeline.

```
$ rudi svCapture

>>> Rusty Data Interface (RuDI): HPC Pipelines <<<

svCapture: Characterize structural variant junctions in short-read, paired-end capture library(s)

usage:
  rudi svCapture <data.yml> [options]  # run all pipeline actions in data.yml
  rudi svCapture <action> <data.yml> [options] # run one action from data.yml
  rudi svCapture <action> <options>    # run one action, all options from command line
  rudi svCapture <action> --help       # pipeline action help
  rudi svCapture --help                # summarize pipeline actions

pipeline specific actions:
  align          clean paired-end reads and align to reference genome; output name-sorted bam/cram
  collate        collate read groups, make consensuses, and re-align to genome
  extract        scan name-sorted reads for molecules with alignment discontinuities
  find           scan anomalous molecules from one or more samples to make SV calls
  genotype       genotype the bulk capture regions and score SNVs in SV junction sequences

general workflow commands:
  template       return a template for creating an input-specific `data.yml` file
  conda          create, update, or list the conda environment(s) required by a pipeline
  build          build a pipeline Singularity image and push to a registry
  shell          open a command shell in a pipeline action's runtime environment
  status         print the pipeline status file for an output directory
  rollback       revert the pipeline to an earlier step for an output directory
```

### Pipeline actions

When you make a call to a pipeline, you might queue multiple actions
listed in data.yml, or you might need to run
just one action at a time, denoted as `<action>` above.

By default, when a pipeline has just one action it is called 'do',
leading to calls like:

```
rudi myPipeline do data.yml
```

### Job configuration options and templates

We strongly recommend using data.yml files to enter the sometimes
numerous options for the work you will execute. The **template**
subcommand makes it easy to create a pre-assembled job configuration file
for a pipeline for you to modify. 

### Job runtime environments

RuDI places a premium on consistent, controlled execution environments
by using [conda](https://docs.conda.io/en/latest/). It goes like this.

Developers list the software their pipeline needs in their configuration files. 

End users make calls to the **conda** subcommand to build a
pipeline's environment(s) prior to running any work. No other software installation
is needed!

Alternatively, developers make calls to the **build** subcommand to create
and upload pre-assembled Singularity containers carrying the required 
environment(s) and mark their pipelines as supporting containers 
for users to download. Users must have Singularity available on their
server capable of running (but not building) containers.
