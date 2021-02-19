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

#remove standard
rm -rf wp-content/plugins/*
rm -rf wp-content/themes/twentyt*

#Download Plugins
wget https://downloads.wordpress.org/plugin/wordfence.7.4.14.zip -P wp-content/plugins/
wget https://downloads.wordpress.org/plugin/generateblocks.1.3.1.zip -P wp-content/plugins/
wget https://downloads.wordpress.org/plugin/kt-tinymce-color-grid.1.15.5.zip -P wp-content/plugins/

#Unzip Plugins
unzip wp-content/plugins/wordfence.*.zip -d wp-content/plugins/
unzip wp-content/plugins/generateblocks.*.zip -d wp-content/plugins/
unzip wp-content/plugins/kt-tinymce-color-grid.*.zip -d wp-content/plugins/

#Download Themes
wget https://downloads.wordpress.org/theme/generatepress.3.0.2.zip -P wp-content/themes/

#Unzip Themes
unzip wp-content/themes/generatepress.*.zip -d wp-content/themes/

#tidy up
rm -rf wordpress/ && rm latest.zip;
rm wp-content/themes/*.zip
rm wp-content/plugins/*.zip


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