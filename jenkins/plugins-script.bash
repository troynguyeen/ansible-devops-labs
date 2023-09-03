#!/bin/bash

while getopts "t:u:" option; do
 case $option in
   t) TOKEN=$OPTARG;; # Get TOKEN argument with -t tag
   u) URL=$OPTARG;; # Get URL argument with -u tag
   \?)
    # Handle invalid options
    echo "script usage: $(basename \$0) [-t TOKEN] [-u URL]" >&2
    exit 1
   ;;
 esac
done

# Get list plugins
PLUGINS=$(java -jar jenkins-cli.jar -auth $TOKEN -s $URL list-plugins)

# Create an empty YAML file
plugins_dir="generate"
mkdir -p $plugins_dir
plugins_file="$plugins_dir/plugins.yaml"
echo "plugins:" > $plugins_file

# Process each line of the command output
while IFS= read -r line; do
    artifact_id=$(echo "$line" | awk '{print $1}')
    version=$(echo "$line" | awk '{gsub(/[()]/, "", $NF); print $NF}')

    # Append plugin information to the YAML file
    echo "  - artifactId: $artifact_id" >> $plugins_file
    echo "    source:" >> $plugins_file
    echo "      version: $version" >> $plugins_file
done <<< "$PLUGINS"

echo "YAML file 'plugins.yaml' generated."