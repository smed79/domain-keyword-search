## Domain Keyword Search

This Bash script searches for specific keywords in a list of websites and outputs the results to a file. It colorizes the output based on the status of each domain:

- Domains that cannot be resolved are colorized red.
- Domains with keywords found are colorized green.
- Domains with keywords not found are colorized white.

### Prerequisites

- Bash
- `curl` command-line tool

### Installation

1. Clone the repository or download the script.
2. Ensure the script is executable:
    ```bash
    chmod +x search_keywords.sh
    ```

### Usage

1. Add your list of keywords to a file named `keywords.txt`, with one keyword per line.
2. Add your list of URLs to a file named `domains.txt`, with one URL or domain per line.
3. Run the script:
    ```bash
    ./search_keywords.sh
    ```

- The script will process each URL and output the results to a file named `output.txt`.
- If the file does not exist, you will be prompted to provide the path to another file.

### Resuming from Last Processed domain

If the script is terminated (e.g., with `Ctrl+C`) and then restarted, it will continue processing from the last domain in the `output.txt` file. This ensures that already processed URLs or domains are not re-processed.

### Example Output

```
Processing domain 1 of 5: example.com (keywords found)
Processing domain 2 of 5: nonexistentdomain.com (could not be resolved)
Processing domain 3 of 5: anotherexample.com (keywords not found)
```

**In the above example:**

- `example.com` contained one or more of the specified keywords and is displayed in green.
- `nonexistentdomain.com` could not be resolved and is displayed in red.
- `anotherexample.com` did not contain any keywords and is displayed in white.

### Script Details

The script reads keywords from the `keywords.txt` file and  domains from the `domains.txt` file. It then fetches the content of each URL and searches for the keywords. The results are printed to the terminal with appropriate colors and saved to the `output.txt` file. The script also handles termination signals to ensure that results are saved before exiting.

### Handling Script Termination

If the script is terminated (e.g., via `SIGINT` or `SIGTERM`), it will call the `cleanup` function to save the results to the `output.txt` file before exiting. When restarted, the script will continue processing from the last domain in the `output.txt` file.

### Notes

- Ensure that the `keywords` and `domains` txt files are in the same directory as the script.
- The script uses `tput` for colorizing the output. Make sure your terminal supports `tput`.

### Support this Project

Star ★ this repo, and we're square :nerd_face:

### License

This project is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported.

See [LICENSE](https://creativecommons.org/licenses/by-nc-sa/3.0/) for details. 
