#!/bin/bash

##############################################################
##                                                          ##
##          UNCLASSIFIED//FOR OFFICIAL USE ONLY             ##
##                                                          ##
##############################################################

##############################################################
##                                                          ##
##          TITLE:      Gitlab tug o'war                    ##
##         AUTHOR:      Kevin Dorsey (kdor)                 ##
##     CREATED ON:      6 March 2019                        ##
##     UPDATED ON:      6 March 2019                        ##
##        VERSION:      0.1                                 ##
##                                                          ##
##          NOTES:      This script is to be run by a       ##
##                      service account to a pull from      ##
##                      a Gitlab repo.                      ##
##                                                          ##
##############################################################

# Variables, y'all.
WHOAMI=`who mom likes | awk '{print $1 }'`
DATE=`date "+%F %R" | awk '{print $1 " " $2 }'`
WORKINGDIRECTORY=/Users/kdor/Repos
LOGFILE=/Users/kdor/Dropbox/git_pull.log
REPO=$1
ARCHIVEFILE=latest.tar
OLDLATESTFILE=`ls -t $WORKINGDIRECTORY | head -1`
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Functions are func-y.
func-new_log() {

    echo "DATE: $DATE | USER: $WHOAMI | REPO: $REPO" >> $LOGFILE

}

# If, then, else, PROFIT
if [ -z "$REPO" ];
    then
        echo ""
        echo -e "${RED}Oh, no! ERROR.${NC}"
        echo "You must include an argument with this script."
        echo "For this script, the argument will be passed"
        echo "as the repo we will be pulling from."
        echo "See the example below."
        echo ""
        echo "./script.sh git@github.com/kdorepos/yomommashouse.git"
        echo ""
        echo "Let's try again."
        echo -e "$DATE | $USER - ${RED}ERROR:${NC} User forgot the argument, exiting..." >> $LOGFILE
        exit
fi

if [[ $REPO =~ .git ]]
    then
        :
    else
        echo ""
        echo -e "${RED}Oh, no! ERROR.${NC}"
        echo "This doesn't look like it's a repo."
        echo "I don't see a .git anywhere in that string."
        echo ""
        echo "Let's try again."
        echo -e "$DATE | $USER - ${RED}ERROR:${NC} User submitted wrong type of argument, exiting..." >> $LOGFILE
        echo ""
        exit
fi

# LET'S GO

# read -p "Press enter to confirm '$REPO' is the repo you would like to pull from."

cd $WORKINGDIRECTORY

git clone --quiet $REPO 2> /dev/null

REPODIRECTORY=`ls -t | head -1`

if [ "$OLDLATESTFILE" == "$REPODIRECTORY" ]
    then
        echo ""
        echo -e "${RED}Oh, no! ERROR.${NC}"
        echo "I think we have a problem."
        echo "I don't believe I cloned that repo correctly."
        echo ""
        echo "Either that repo doesn't exist or is down."
        echo ""
        echo "Let's try again."
        echo -e "$DATE | $USER - ${RED}ERROR:${NC} Repo did not clone correctly, exiting..." >> $LOGFILE
        exit
    else
        :
fi

cd $WORKINGDIRECTORY/$REPODIRECTORY

git archive --format=tar -o $ARCHIVEFILE MASTER 2> /dev/null

mv $ARCHIVEFILE $WORKINGDIRECTORY

cd $WORKINGDIRECTORY

rm -rf $REPODIRECTORY

mkdir $REPODIRECTORY

mv $ARCHIVEFILE $REPODIRECTORY

cd $REPODIRECTORY

tar -xvf $ARCHIVEFILE 2> /dev/null

rm -f $ARCHIVEFILE

# Set perms here

echo ""
echo -e "${GREEN}We have success.${NC}"
echo "Always trust and verify."
echo ""
echo "-kdor"

echo -e "$DATE | $USER - ${GREEN}SUCCESS:${NC} The $REPODIRECTORY repo has been cloned and integrated successfully." >> $LOGFILE

##############################################################
##                                                          ##
##          UNCLASSIFIED//FOR OFFICIAL USE ONLY             ##
##                                                          ##
##############################################################