#!/bin/bash
fileid="14lGg3mf4E23fFKJPngWoOy7TI9dcMW5W"
filename="tanzu_tools.tar.gz"
curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${fileid}" > /dev/null
curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=`awk '/download/ {print $NF}' ./cookie`&id=${fileid}" -o ${filename}