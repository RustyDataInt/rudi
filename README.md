# RuDI Command Line Installer and Interface

The [Rusty Data Interface](https://rustydataint.github.io/) (RuDI) 
is a standardized framework for developing and running HPC data 
analysis **pipelines** and interactive visualization **apps**
with a Rust-first mindset.

This repository carries an **installation script** that will 
set up RuDI on your Linux server with all required components and 
a proper folder structure to support all tools.

## Install the RuDI frameworks

Clone this repository and run its installation script as follows:

```sh
git clone https://github.com/RustyDataInt/rudi.git
cd rudi
./install.sh
```

## OPTIONAL: Create an alias to the 'rudi' utility

The following commands will create an alias to the main 'rudi' 
command line interface (CLI) in your new installation for easy access.

```sh
# from within the rudi directory
./rudi alias --alias rudi # change the alias name if you'd like
`./rudi alias --alias rudi --get` # activate the alias in the current shell (or log back in)
```

You could also edit your shell files to modify the PATH variable.

## Configure and install tool suites

The process above clones RuDI repositories
that define the pipeline and app frameworks, but few actual
tools. To install tools from any provider, use:

```sh
rudi add --help
rudi add -s <owner>/<repository> # either format works
rudi add -s https://github.com/<owner>/<repository>.git
```

Alternatively, manually edit `config/suites.yml`, then 
call `install.sh` again to clone the listed repositories.

```yml
# rudi/config/suites.yml
suites:
    - <owner>/<repository> # either format works
    - https://github.com/<owner>/<repository>.git
```

```sh
./install.sh
rudi install # does the same thing as the previous line
```

## Run an HPC pipeline from the command line

The installation process adds the 'rudi' CLI to your installation 
folder. You can use it to run any pipeline. For help, call the 
CLI with no arguments:

```sh
./rudi
rudi # if you created an alias above
rudi --help
```

## Run the Dioxus app server

While you can launch the app server using the CLI, it is much better 
to use the [RuDI Desktop](https://rustydataint.github.io/rudi-desktop-app),
which allows you to control both local and remote app servers.

## Install and use repository developer forks

Code developers often maintain forks of RuDI framework and tool suite
repositories in their GitHub account. To install your forks alongside 
the definitive repositories provide a 
[GithHub Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
by setting environment variable `GITHUB_PAT` or creating file '~/gitCredentials.R':

```r
# ~/gitCredentials.R
gitCredentials <- list(
    USER_NAME  = "FirstName LastName",
    USER_EMAIL = "name@umich.edu",
    GIT_USER   = "xxx",
    GITHUB_PAT = "xxx"
)
```

Then re-run the RuDI installation as follows:

```sh
rudi install --help
rudi install --forks
```

Finally, add the '--develop/-d' flag to your `rudi` calls, which will
use any forked repositories from your GitHub account, or, if you have no forks,
the tip of the main branch of the definitive repository (instead of a versioned release commit).

```sh
rudi -d ...
rudi --develop ...
```
