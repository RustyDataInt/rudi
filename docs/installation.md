---
title: "Installation"
has_children: false
nav_order: 10
---

## {{ page.title }}

Follow these instructions to create a multi-suite RuDI installation, 
complete with managers, frameworks, and tool suites.

### Clone the RuDI repo

From the command line of a Linux server:

```bash
git clone https://github.com/RustyDataInt/rudi.git
```

### Run the installation script

```bash
cd rudi
./install.sh
```

Please read the menu options and confirm your installation choice.
A full installation including Stage 2 apps will take many minutes 
to complete. 

### OPTIONAL: Create an alias to the command line utility (CLI)

The following commands will create an alias to the `rudi` CLI
in your new RuDI installation for easy access from any folder.

```bash
./rudi alias --alias rudi # change the alias name as needed
`./rudi alias --alias rudi --get`
```

The second command activates the alias in the current shell also - or 
simply log back in.

You could also edit your profile to modify `$PATH`, but
we prefer aliases since we often maintain multiple RuDI installations
that we refer to by different alias names.

### Configure and install tool suites

<code>install.sh</code> clones the RuDI frameworks but few actual
tools. To install tools from any provider, first edit file 
'config/suites.yml' in the 'rudi' root directory.

```yml
# rudi/config/suites.yml
suites:
    - <owner>/<repository> # either format works
    - https://github.com/<owner>/<repository>.git
```

Then call <code>install.sh</code> again to clone the listed
repositories and install any additional R package dependencies.

Alternatively, run the following from the command line:

```bash
rudi add --help
rudi add -s <owner>/<repository> # either format works
rudi add -s https://github.com/<owner>/<repository>.git
```
