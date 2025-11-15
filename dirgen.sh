#!/bin/bash

declare -a SEASON_DIRS=()
OUTPUT_DIR=""
EXTRAS_DIR=""
NAME=""

#include these filetypes when symlinking files, will not link any files without these extensions
INCLUDE=("mp4" "mkv" "ts" "mov" "avi")

while getopts ":o:s:e:n:h" OPTION; do
  case $OPTION in
  o)
    OUTPUT_DIR="$OPTARG"
    ;;
  s)
    SEASON_DIRS+=("$OPTARG")
    ;;
  e)
    EXTRAS_DIR="$OPTARG"
    ;;
  n)
    NAME="$OPTARG"
    ;;
  h)
    echo "This script will generate a structured symbolically linked directory of a show suitable for use with Jellyfin."
    echo ""
    echo "Flags:"
    echo "-o : Output Directory [REQUIRED]"
    echo "-s : Input Directory of Season [OPTIONAL] (flag can be called multiple times for multiple seasons)"
    echo "-e : Directory of Extra Content [OPTIONAL]"
    echo "-n : Show Name [REQUIRED]"
    echo ""
    echo "Examples:"
    echo "dirgen.sh -n <Show Name> -s <Season 1 Directory> -s <Season 2 Directory> -e <Extra Content Directory> -o <Output Directory>"
    echo "dirgen.sh -n <Show Name> -o <Output Directory>"
    exit 1
    ;;
  \?)
    echo "Invalid Option: -$OPTARG, use -h for help."
    exit 1
    ;;
  :)
    echo "Option -$OPTARG requires argument."
    exit 1
    ;;
  esac
done

if [ -z "$NAME" ]; then
  echo "Error: Missing show name, use -h for help."
  exit 1
fi

if [ -z "$OUTPUT_DIR" ]; then
  echo "Error: Missing output directory, use -h for help."
  exit 1
fi

if [ ! -d "$OUTPUT_DIR" ]; then
  echo "Error: Output directory $OUTPUT_DIR is not a valid directory."
  exit 1
fi

BASE_DIR="$OUTPUT_DIR/$NAME"
mkdir "$BASE_DIR"
echo "Created base directory $BASE_DIR"

SEASON_COUNT=${#SEASON_DIRS[@]}

if [ $SEASON_COUNT -ge 1 ]; then
  for ((i = 1; i <= $SEASON_COUNT; i++)); do
    FILE="Season $i"
    mkdir "$BASE_DIR/$FILE"

    echo "Created $BASE_DIR$FILE"
    echo "Linking ${SEASON_DIRS[i - 1]} to $BASE_DIR/$FILE"

    for EP in "${SEASON_DIRS[i - 1]}"/*; do
      EXT="${EP##*.}" #extract extension
      for VALID in "${INCLUDE[@]}"; do
        if [[ "$EXT" == "$VALID" ]]; then #check if its valid
          ln -s "$EP" "$BASE_DIR/$FILE"
        fi
      done
    done
  done
else
  echo "No seasons supplied, skipping season folder setup."
fi

if [ ! -z $EXTRAS_DIR ]; then
  mkdir "$BASE_DIR/Specials"
  echo "Created and populated extras folder."
else
  echo "No extras provided, skipping extras folder setup."
fi
