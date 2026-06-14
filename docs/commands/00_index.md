---
title: "Command Structure"
has_children: true
nav_order: 20
---

## One utility, multiple actions

Similar to other common utilities (git, docker, etc.), the RuDI
CLI has various argument formats to execute many needed tasks. 

Call the utility without any subcommands or options to see the basic structures.

```bash
$ rudi

>>> Rusty Data Interface (RuDI) <<<

rudi is a utility for:
  - submitting, monitoring and managing HPC data analysis pipelines
  - launching the web interface that runs all Dioxus interactive apps

usage:
  rudi <pipeline> <data.yml> [options]  # run all pipeline actions in data.yml
  rudi <pipeline> <action> <data.yml> [options] # run one action from data.yml
  rudi <pipeline> <action> <options>    # run one action, all options from command line
  rudi <data.yml> <command> [options]   # apply manager command to one data.yml
  rudi <command> [options] <data.yml ...> [options] # apply manager command to data.yml(s)
  rudi <command> [options]              # additional manager command shortcuts
  rudi <pipeline> <action> --help       # pipeline action help
  rudi <pipeline> --help                # summarize pipeline actions
  rudi <command> --help                 # manager command help
  rudi --help                           # summarize manager commands

<output truncated>
```

### Subcommands

The 'rudi' command often calls a nested program or subcommand, 
denoted as `<command>` above.

### Job configuration files

Many commands act on HPC pipeline job configurations, 
YAML-format files that specify the work to be done. We refer to this 
as `<data.yml>` above - your file would have its own name.

### Pipeline targets

Many commands execute a specific HPC pipeline, denoted as `<pipeline>` above.
Other times, the pipeline is specified in the job configuration file.

### Option levels

When setting options, order matters! An option applies to the command word
it follows. You may ultimately wish to set options on the rudi command itself,
on a subcommand, or to override the job configuration file.
