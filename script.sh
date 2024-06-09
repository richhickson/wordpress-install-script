#!/bin/bash
# This script was written by Richard Hickson. Twitter.com/richhickson.
# 
# It uses code from Michael Coigliaro - https://gist.github.com/Adirael/3383404#file-fix-wordpress-permissions-sh 
# Based on hardening wordpress here  https://wordpress.org/support/article/hardening-wordpress/
# It downloads, unzips, removes the zip and the ziped folder.
#

#Download wordPress
wget https://wordpress.org/latest.zip

#Unzip Wordpress
unzip latest.zip

#Move WordPress from extracted folder to root of the current folder.
pwd=$(pwd)
mv wordpress/* $pwd/

#alter permissions
WP_OWNER=www-data # <-- wordpress owner
WP_GROUP=www-data # <-- wordpress group
WP_ROOT=$1 # <-- wordpress root directory
WS_GROUP=www-data # <-- webserver group

# reset to safe defaults
find ${WP_ROOT} -exec chown ${WP_OWNER}:${WP_GROUP} {} \;
find ${WP_ROOT} -type d -exec chmod 755 {} \;
find ${WP_ROOT} -type f -exec chmod 644 {} \;

# allow wordpress to manage wp-config.php (but prevent world access)
chgrp ${WS_GROUP} ${WP_ROOT}/wp-config.php
chmod 660 ${WP_ROOT}/wp-config.php

# allow wordpress to manage wp-content
find ${WP_ROOT}/wp-content -exec chgrp ${WS_GROUP} {} \;
find ${WP_ROOT}/wp-content -type d -exec chmod 775 {} \;
find ${WP_ROOT}/wp-content -type f -exec chmod 664 {} \;

#Download and install Joost installer-basic-auth.php 
mkdir wp-content/mu-plugins
wget https://gist.githubusercontent.com/jdevalk/4a11ec58a7f7123bb525470c1a1454c4/raw/54be07e4aebc9e7cd99a40edf1100503b21c0a7f/installer-basic-auth.php

#tidy up
rm -rf wordpress/ && rm latest.zip
