#!/bin/bash

# Bash script to search for keywords in a list of domains and output the results in a new file
# domain that could not be resolved is colorised red
# domain with keyword(s) found is colorised green
# domain with keyword(s) not found is colorised white

# Function to prompt for a file path if the file does not exist
prompt_for_file() {
    local file_description=$1
    local file_variable_name=$2
    local file_path

    while true; do
        read -p "Enter the path for the $file_description file: " file_path
        if [ -f "$file_path" ]; then
            eval "$file_variable_name='$file_path'"
            break
        else
            echo "File not found. Please try again."
        fi
    done
}

# Check if the "domains" txt file exists, otherwise prompt for the file to use
if [ ! -f ./domains.txt ]; then
    prompt_for_file "domains.txt" domains_file
else
    domains_file="./domains.txt"
fi

# Check if the "keywords" txt file exists, otherwise prompt for the file to use
if [ ! -f ./keywords.txt ]; then
    prompt_for_file "keywords.txt" keywords_file
else
    keywords_file="./keywords.txt"
fi

# Read keywords from the keywords txt file into an array
mapfile -t keywords < "$keywords_file"

# Function to search for keywords in a given URL
search_keywords_in_url() {
    local url=$1
    # Fetch URL content
    content=$(curl --max-time 3 -L "$url" 2>/dev/null)
    if [ $? -ne 0 ]; then
        tput setaf 1; # change color to red
        echo "Processing domain $current_url of $total_urls: $url (could not be resolved)"
        tput sgr0; # reset color to default
    else
        if echo "$content" | grep -qioFf <(printf "%s\n" "${keywords[@]}") 2>/dev/null; then
            echo "$url" >> output.txt
            tput setaf 2; # change color to green
            echo "Processing domain $current_url of $total_urls: $url (keywords found)"
            tput sgr0; # reset color to default
        else
            tput setaf 7; # change color to white
            echo "Processing domain $current_url of $total_urls: $url (keywords not found)"
            tput sgr0; # reset color to default
        fi
    fi
}

# Function to handle script termination
cleanup() {
    echo "Script terminated. Results saved to 'output.txt'."
    exit
}

# Trap the script termination signals to call the cleanup function
trap cleanup SIGINT SIGTERM

# Get the last processed URL if the output txt file exists
if [ -f output.txt ] && [ -s output.txt ]; then
    last_processed=$(tail -n 1 output.txt)
    skip_urls=true
else
    skip_urls=false
fi

# Read URLs from the domains txt file and process each
total_urls=$(wc -l < "$domains_file")
current_url=0
while IFS= read -r url; do
    current_url=$((current_url + 1))
    # Skip URLs that have already been processed
    if $skip_urls; then
        if [ "$url" == "$last_processed" ]; then
            skip_urls=false
        fi
        continue
    fi
    search_keywords_in_url "$url"
done < "$domains_file"

# Call the cleanup function to save the results before exiting
cleanup
