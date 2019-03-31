#!/bin/bash

##############################################################
##                                                          ##
##          UNCLASSIFIED//FOR OFFICIAL USE ONLY             ##
##                                                          ##
##############################################################

# Variables
WHOAMI=`who mom likes | awk '{print $1}'`
DATE=`date "+%F %H:%M:%S" | awk '{print $1 " " $2 }'`
WORKINGDIRECTORY=/usr/share/sbin
LOGFILE=$WORKINGDIRECTORY/git_tug_o_war/git_pull.log
REPO={{ insert_this_repos_https_url_here }}
ARCHIVEFILE=latest.tar
PARENTDIRECTORY={{ insert_root_directory_splunk_lives_in_here }}
CHILDDIRECTORY=$PARENTDIRECTORY/splunk/etc/deployment-apps
OLDLATESTFILE=`ls -t $PARENTDIRECTORY | head -1` # Setting the variable based on the current latest folder in $PARENTDIRECTORY

# Getting started

cd $PARENTDIRECTORY

sudo GIT_SSL_NO_VERIFY=TRUE git clone $REPO -b $BRANCH # Doing an HTTPS pull, disregards the cert check

REPODIRECTORY=`ls -t | head -1` # Setting the variable bsaed on the newest folder in $PARENTDIRECTORY

if [ "$OLDLATESTFILE" == "$REPODIRECTORY" ] # Making sure the newest folder is not the same as the old latest folder
    then
        echo ""
        echo "ERROR."
        echo "I think we have a problem."
        echo "I don't believe I cloned that repo correctly."
        echo ""
        echo "Please make sure Gitlab is running."
        echo "or there isn't something wrong with $REPO."
        echo ""
        echo "Let's try again."
        echo "$DATE | $WHOAMI - ERROR: Repo did not clone correctly, exiting..." >> $LOGFILE # Logging a failure in the cloning process
        exit
    else
        :
fi

cd $PARENTDIRECTORY/$REPODIRECTORY

sudo git archive --format=tar -o $ARCHIVEFILE HEAD 2> /dev/null # Tarring up and removing .git from folder

sudo mv $ARCHIVEFILE $PARENTDIRECTORY

cd $PARENTDIRECTORY

sudo rm -rf $REPODIRECTORY

sudo rm -rf $CHILDDIRECTORY

sudo mkdir $CHILDDIRECTORY

sudo mv $ARCHIVEFILE $CHILDDIRECTORY

cd $CHILDDIRECTORY

sudo tar -xvf $ARCHIVEFILE > /dev/null

sudo rm -f $ARCHIVEFILE

sudo chown -R xadmin:wheel $CHILDDIRECTORY

echo ""
echo "We have success."
echo "Always trust but verify."
echo ""
echo "-kdor"

echo "$DATE | $WHOAMI - SUCCESS: The $REPODIRECTORY repo has been cloned and integrated successfully." >> $LOGFILE # Logging success

##############################################################
##                                                          ##
##          UNCLASSIFIED//FOR OFFICIAL USE ONLY             ##
##                                                          ##
##############################################################