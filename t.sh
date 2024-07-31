#!/bin/bash

# Initialize a counter
count=0

# Function to display the menu
show_menu() {
    echo "1. Create a Directory"
    echo "2. Create a File"
    echo "3. Create 500,000 Nested Directories with README.md"
    echo "4. Exit"
    echo -n "Enter your choice [1-4]: "
}

# Function to create a directory
create_directory() {
    echo -n "Enter the name of the directory: "
    read dir_name
    mkdir -p "$dir_name"
    echo "Directory '$dir_name' created."
}

# Function to create a file
create_file() {
    echo -n "Enter the name of the file (with path if needed): "
    read file_name
    touch "$file_name"
    echo "File '$file_name' created."
}

# Function to handle cleanup and show the number of directories created
cleanup() {
    echo
    echo "Process interrupted."
    echo "Directories created: $count"
    exit 1
}

# Trap SIGINT and SIGTERM signals to run the cleanup function
trap cleanup SIGINT SIGTERM

# Function to create 500,000 nested directories with README.md files
create_nested_directories_with_readme() {
    echo -n "Enter the base name for the directories: "
    read base_name
    echo "Enter the text to add to README.md files. End input with a single dot (.) on a new line:"

    readme_text=""
    while IFS= read -r line; do
        if [[ $line == "." ]]; then
            break
        fi
        readme_text+="$line"$'\n'
    done

    echo "Creating 500,000 nested directories with README.md files..."

    dir_path="$base_name"
    mkdir -p "$dir_path"
    echo "$readme_text" > "$dir_path/README.md"
    count=$((count + 1))

    for i in {1..500000}; do
        dir_path="$dir_path/${base_name}_$i"
        mkdir -p "$dir_path"
        echo "$readme_text" > "$dir_path/README.md"
        count=$((count + 1))
    done

    echo "500,000 nested directories created with base name '$base_name' and README.md files."
    echo "Total directories created: $count"
}

# Main script loop
while true; do
    show_menu
    read choice
    case $choice in
        1) create_directory ;;
        2) create_file ;;
        3) create_nested_directories_with_readme ;;
        4) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid choice, please try again." ;;
    esac
done
