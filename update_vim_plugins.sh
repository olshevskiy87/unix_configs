#!/bin/bash

cur_path=`pwd`
bundle_path=~/.vim/bundle

if [ ! -d $bundle_path ]; then
    echo no bindle folder. create it...
    mkdir -p $bundle_path
fi
cd $bundle_path

while read -r plugin
do
    IFS="|" read p_name p_url p_enable <<< "$plugin"
    p_name=$(echo -e "${p_name}" | sed -e 's/^[[:space:]]*//' | sed -e 's/[[:space:]]*$//')
    p_url=$(echo -e "${p_url}" | sed -e 's/^[[:space:]]*//' | sed -e 's/[[:space:]]*$//')
    p_enable=$(echo -e "${p_enable}" | sed -e 's/^[[:space:]]*//' | sed -e 's/[[:space:]]*$//')
    echo - plugin $p_name
    if [ ! -d $p_name ]; then
        echo bundle not exist
        if [ $p_enable -eq 1 ]; then
            echo clone it...
            git clone $p_url
        fi
    else
        echo bundle exist
        if [ $p_enable -eq 0 ]; then
            echo remove it...
            rm -rf $p_name
        fi
    fi
done < "$cur_path/plugins.list"

cd $cur_path
echo done.
