#!/bin/sh

SCRIPT_PATH=/home/jenkins/.jenkins/jobs/CEAuto/workspace/
File_path=$SCRIPT_PATH/Libraries/genericLibrary

echo "Enabling Headless settings..."

perl -pe 's{Create normal browser}{++$n == 2 ? "#Create normal browser" : $&}ge' $File_path/commonTasks.robot > $SCRIPT_PATH/1.tmp
sed 's/#Create Headless Browser/Create Headless Browser/g' $SCRIPT_PATH/1.tmp  > $SCRIPT_PATH/2.tmp
sed 's/#Start/Start/g' $SCRIPT_PATH/2.tmp  > $SCRIPT_PATH/3.tmp
sed 's/#Library/Library/g' $SCRIPT_PATH/3.tmp  > $SCRIPT_PATH/4.tmp

mv $File_path/commonTasks.robot $File_path/commonTasks.robot.bkp
mv $SCRIPT_PATH/4.tmp $File_path/commonTasks.robot

rm -rf $SCRIPT_PATH/*.tmp
