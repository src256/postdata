#!/bin/sh

bundle_dir=./vendor/bundle
if [ -d "$bundle_dir" ] ; then
    /bin/rm -rf "$bundle_dir"
    bundle update    
else
    /bin/rm -rf "$bundle_dir"
    bundle install --path "$bundle_dir"
fi





