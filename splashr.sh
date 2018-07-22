#!/bin/bash

# Settings
collection=https://source.unsplash.com/random

# Folders
imgFolder=".splashr"
rootFolder=$HOME/$imgFolder
i3lockFolder="i3lock/"
bgFolder="bg/"
loginFolder="/usr/share/images/login"
tempFolder="temp"


function downloadImages {

    # Get resolution for search. So we only get image that fits screen 
    size=$(xdpyinfo | grep dimensions | awk '{print $2}')

    for i in {1..15};
    do
        # Setting sleep 5 sec here, so we get a better chance of random image.
        sleep 5;
        curl $collection/$size --location --output $rootFolder/$tempFolder/$i.jpeg
        cp $rootFolder/$tempFolder/$i.jpeg $rootFolder/$bgFolder/$i.jpeg
    done
}

function convertImages {
    find $rootFolder/$tempFolder/. -name "*.jpeg" -exec mogrify -format png {} \;
    mv $rootFolder/$tempFolder/*.png $rootFolder/$i3lockFolder/;
}

function changeBackground {
    DISPLAY=:0 feh --bg-scale $(find $rootFolder/$bgFolder/ -name "*.jpeg" | shuf -n1)
}

function checkLoginBackground {
    if [ $(find "$loginFolder/login.jpeg" -mtime +1 | wc -l) -gt 0 ]; then
        cp $(find $rootFolder/$bgFolder/ -name "*.jpeg" | shuf -n1) $loginFolder/login.jpeg
        exit
    fi
}

if [ ! -d "$rootFolder" ]; then
    mkdir $rootFolder
    mkdir $rootFolder/$i3lockFolder
    mkdir $rootFolder/$bgFolder
    mkdir $rootFolder/$tempFolder
    downloadImages
    convertImages
    changeBackground
    exit
fi

if [ $(find "$rootFolder/$tempFolder" -mtime +2 | wc -l) -gt 0 ]; then
    downloadImages
    convertImages
    changeBackground
    exit
fi

changeBackground
checkLoginBackground
exit
