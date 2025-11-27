#!/bin/bash
# Setup script to create symlink to classic-evry-report template

TEMPLATE_DIR="/home/paul/Documents/classic-evry-report"
TARGET_DIR="${1:-.}"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory $TARGET_DIR does not exist"
    exit 1
fi

cd "$TARGET_DIR" || exit 1

if [ -e "classic-evry-report" ]; then
    echo "classic-evry-report already exists in this directory"
    exit 0
fi

ln -s "$TEMPLATE_DIR" classic-evry-report
echo "✓ Created symlink to classic-evry-report template"
echo "You can now use: #import \"classic-evry-report/lib.typ\": ..."
