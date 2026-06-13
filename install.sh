#!/bin/sh

#---------------------------------------------------------------------------
# RuDI frameworks and CLI installation utility
#---------------------------------------------------------------------------

# ensure that we are working in a 'rudi' directory that contains this script
RUDI_DIR="$(cd "$(dirname "$0")" >/dev/null 2>&1 && pwd)"
export RUDI_DIR
case "$RUDI_DIR" in
    */rudi) ;;
    *)
        echo ""
        echo "ERROR - this script must be run from within a 'rudi' folder than contains it"
        echo ""
        exit 1
        ;;
esac
cd "$RUDI_DIR"

# initialize the RuDI directory tree
echo "initializing the RuDI directory tree"
mkdir -p frameworks/definitive      # populated below
mkdir -p frameworks/developer-forks # populated below
mkdir -p suites/definitive          # populated by user via `rudi add` or other means
mkdir -p suites/developer-forks     # populated by user via `rudi add` or other means

updateRepo() {
    PARENT_FOLDER=$1
    GIT_REPO=$2
    CHECKOUT=$3
    REPO_NAME=$(echo "$GIT_REPO" | sed 's/.*\///')
    FOLDER="$PARENT_FOLDER/$REPO_NAME"
    echo "$FOLDER"
    if [ -d "$FOLDER" ]; then
        cd "$FOLDER"
        git checkout main
        git pull
    else
        cd "$PARENT_FOLDER"
        if git clone "https://github.com/$GIT_REPO.git"; then
            cd "$REPO_NAME"
        fi
    fi
    if [ "$PWD" = "$FOLDER" ]; then
        if [ "$CHECKOUT" = "latest" ]; then
            CHECKOUT=$(
                git tag | 
                grep -E '^v[0-9]+\.[0-9]+\.[0-9]+' | 
                sed -e 's/v//' -e 's/\./\t/g' | 
                sort -k1,1nr -k2,2nr -k3,3nr | 
                head -n1 | 
                awk '{print "v"$1"."$2"."$3}'
            ) # the latest tagged version, method robust to all contingencies
            if [ "$CHECKOUT" = "" ]; then CHECKOUT="main"; fi
        fi
        echo "checking out $CHECKOUT"
        git -c advice.detachedHead=false checkout "$CHECKOUT"
    fi
    cd "$RUDI_DIR"
}

# initialize/update the CLI
echo "initializing the command line interface"
chmod ug+x rudi 

# determine if there is an active git developer user
GIT_USER_DEV=""
if [ "$INSTALL_RUDI_FORKS" != "" ]; then
    if [ -f ~/gitCredentials.R ]; then
        GIT_USER_DEV=$(cat ~/gitCredentials.R 2>/dev/null | grep GIT_USER | sed -e 's/.*GIT_USER\s*=\s*//' -e 's/[",]//g')
    fi
    if [ "$GIT_USER_DEV" = "" ]; then
        echo ""
        echo "!!! WARNING: Fork installation requested but ~/gitCredentials.R not found or does not specify GIT_USER !!!"
        echo "!!! See: https://rustydataint.github.io/docs/usage/development !!!"
        echo ""
    fi
fi 

# clone/pull the framework repositories
echo "cloning/updating the framework repositories"
PIPELINES_FRAMEWORK=rudi-pipelines-framework
APPS_FRAMEWORK=rudi-apps-framework
updateRepo "$RUDI_DIR/frameworks/definitive" "RustyDataInt/$PIPELINES_FRAMEWORK" latest
updateRepo "$RUDI_DIR/frameworks/definitive" "RustyDataInt/$APPS_FRAMEWORK" latest
if [ "$GIT_USER_DEV" != "" ]; then
    updateRepo "$RUDI_DIR/frameworks/developer-forks" "$GIT_USER_DEV/$PIPELINES_FRAMEWORK" main
    updateRepo "$RUDI_DIR/frameworks/developer-forks" "$GIT_USER_DEV/$APPS_FRAMEWORK" main
fi

# clone/pull any tool suites from config.yml
echo "cloning/updating requested tool suites"
SUITES=$(
    grep -v "^\s*#" config/suites.yml | 
    grep -v "^---" | 
    sed -e 's/^\s*-\s*//' -e 's/suites:\s*//' -e 's/#.*//' -e "s|^https://github.com/||" -e "s/\.git$//" | 
    grep "\S"
)
export SUITES

for GIT_REPO in $SUITES; do 
    REPO_VERSION=latest # checkout latest unless a version-specific suite-centric build/install
    if [ "$GIT_REPO" = "$GIT_USER/$SUITE_NAME" ] && [ "$SUITE_VERSION" != "" ]; then 
        REPO_VERSION=$SUITE_VERSION
    fi
    updateRepo "$RUDI_DIR/suites/definitive" "$GIT_REPO" "$REPO_VERSION"
    if [ "$GIT_USER_DEV" != "" ]; then
        REPO_NAME=${GIT_REPO##*/}
        updateRepo "$RUDI_DIR/suites/developer-forks" "$GIT_USER_DEV/$REPO_NAME" main
    fi
done

# clone/pull any additional tool suite dependencies from suite _config.yml files
echo "cloning/updating tool suite dependencies"
DEPENDENCIES=$(
    cat "$RUDI_DIR"/suites/definitive/*/_config.yml 2>/dev/null | 
    perl -e '
        my $inDep = 0;
        my %suites = map {$_ => 1} split(/\s+/, $ENV{SUITES});
        while(<>){
            if($_ =~ m/^suite_dependencies/){ $inDep = 1 } 
            elsif($_ =~ m/^\S/){ $inDep = 0 }
            elsif($inDep and $_ =~ m|^\s+-\s+(\S+)|){
                $suites{$1} or print $1, "\n";
            }
        }
    ' | 
    sort | 
    uniq
)
for GIT_REPO in $DEPENDENCIES; do 
    updateRepo "$RUDI_DIR/suites/definitive" "$GIT_REPO" latest
    if [ "$GIT_USER_DEV" != "" ]; then
        REPO_NAME=${GIT_REPO##*/}
        updateRepo "$RUDI_DIR/suites/developer-forks" "$GIT_USER_DEV/$REPO_NAME" main
    fi
done

# initialize the pipelines jobManager
JOB_MANAGER_DIR="$RUDI_DIR/frameworks/definitive/$PIPELINES_FRAMEWORK/job_manager"
perl "$JOB_MANAGER_DIR/initialize.pl" "$RUDI_DIR"
if [ $? -ne 0 ]; then exit 1; fi
JOB_MANAGER_DIR="$RUDI_DIR/frameworks/developer-forks/$PIPELINES_FRAMEWORK/job_manager"
if [ -f "$JOB_MANAGER_DIR/initialize.pl" ]; then
    perl "$JOB_MANAGER_DIR/initialize.pl" "$RUDI_DIR"
fi
