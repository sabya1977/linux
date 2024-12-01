#!/bin/bash
#
# Desc: Running Script or Command as Another User in Linux
# We will learn different ways to run a script/command as 
# another user in Linux using su or sudo commands
#
# Author: Sabyasachi Mitra
# Date: 11/24/2024
#
# Topic :: Setting up Environment
# create two users Dave and Annie
sudo useradd annie
sudo useradd dave
# password is same as username
sudo passwd annie
sudo passwd dave
#
# login as annie and create the following script in annie's home dir
cat > /home/annie/annie-script.sh <<EOF
echo "Running annie-script.sh as user $(whoami)"
EOF
#
# set execute permission for owner
chmod u+x /home/annie/annie-script.sh
#
ls -l
# total 4
# -rwxr--r--. 1 annie annie 45 Nov 24 20:48 annie-script.sh
#
#
# Topic :: Run script using su command
# login as dave and run the script
su -c '/home/annie/annie-script.sh' annie
# enter the password of the target user (annie)
# output:
Running annie-script.sh as user annie
# Note: By default su will switch to target user and create a new shell
# But when run with -c, it will just execute the script without creating
# a new shell.
# if you don't specify any target user it will try to run as root
su -c  '/home/annie/annie-script.sh'
# enter root password
#
# Topic :: Disabling the Password Prompt (su)
# Password prompt is not preferrable when you want to run the script
# in a batch. Fortunately we have a way to supress password prompt
#
# The su command relies on Linux’s PAM for authentication purposes, we
# can disable the password prompt for the su command through its PAM 
# configuration file.
#
# open /etc/pam.d/su file and add the following lines
auth  [success=ignore default=1] pam_succeed_if.so user = annie
auth  sufficient                 pam_succeed_if.so use_uid user = dave
#
# Explanation:
# first rule checks if the target user is annie. If so, it will proceed
# (success=ignore) and we can continue on the next line to check the
# second rule to check if the current user is dave. if the target user
# is not annie the next line will be skipped (default=1) and we can continue
# on subsequent lines with the usual authentication steps.
#
# The second line checks whether the current user is dave or not. if it is
# then the system considers the authentication process as successful and 
# returns (sufficient), if it is not, nothing happens and we continue on 
# subsequent lines.
# If either of the rule results false, password is prompted
# You can also restrict su to a group, here the group name is allowedpeople 
# can su without a password:
auth sufficient pam_succeed_if.so use_uid user ingroup allowedpeople
# 
# Now run the same command as dave - password is not prompted
su -c /home/annie/annie-script.sh annie
# Note: if any other user than dave runs the script, they'll be prompted 
# for password since there is no entry for them in pam.d/su
#
# Topic :: Running a Specific Script as Another User (sudo)
#
# Before we can execute scripts as other users with sudo, we’ll need 
# to add the current user to the sudoers file. To do that, we’ll use 
# the visudo command to safely edit the /etc/sudoers file.
# Add dave to sudoers file
#
# Explanation: the EDITOR variable sets the edior to visudo
# tee -a command takes input from the pipe and append
# as root
echo 'dave ALL=(annie) /home/annie/annie-script.sh' | EDITOR='tee -a' visudo
#
# as dave - it will prompt for the password of the current user (dave)
sudo -u annie /home/annie/annie-script.sh
#
# now let's try to run the script as root
sudo -u root /home/annie/annie-script.sh
# ERROR!
# Sorry, user dave is not allowed to execute '/home/annie/annie-script.sh' as root on orcl9.
#
# Because the rules we’ve configured only allow dave to execute 
# annie-script.sh (a specific script) as annie (a specific user).
# To allow dave to execute the script annie-script.sh as any users, 
# we can change the rules for dave as such:
dave ALL=(ALL) /home/annie/annie-script.sh
# now let's try to run the script as root - it will work now
sudo -u root /home/annie/annie-script.sh
#
# Skipping Password Prompt (sudo)
# you need to edit the /etc/sudoers as follows:
dave ALL=(ALL) NOPASSWD: /home/annie/annie-script.sh