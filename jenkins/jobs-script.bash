#!bin/bash

while getopts "t:u:" option; do
 case $option in
   t) TOKEN=$OPTARG;; # Get TOKEN argument with -t tag
   u) URL=$OPTARG;; # Get URL argument with -u tag
   \?)
    # Handle invalid options
    echo "script usage: $(basename \$0) [-a] [-u] [-a somevalue]" >&2
    exit 1
   ;;
 esac
done

# Run the command and capture the output
JOBS=$(java -jar jenkins-cli.jar -auth $TOKEN -s $URL list-jobs)

for JOB in $JOBS; do

  # Create the directory if it doesn't exist
  config_dir="generate/jobs/$JOB"
  mkdir -p $config_dir
  config_file="$config_dir/config.xml"
  # Create an empty config.xml file
  rm -f $config_file
  touch $config_file

  # Save XML job to config.xml
  JOB_CONTENT=$(java -jar jenkins-cli.jar -auth $TOKEN -s $URL get-job $JOB)
  while IFS= read -r XML_LINE; do
    echo $XML_LINE >> $config_file
  done <<< "$JOB_CONTENT"

done

# Create an empty YAML file
jobs_dir="generate/list-jobs.yaml"
echo "jenkins_jobs:" > $jobs_dir

while IFS= read -r LINE; do
  # Save list jobs to yaml
  echo "  - $LINE" >> $jobs_dir
done <<< "$JOBS"

echo "XML file jobs 'config.xml' generated."
echo  "YAML file 'list-jobs.yaml' generated."
