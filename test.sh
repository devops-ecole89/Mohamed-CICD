#!/bin/bash

# Variables
TEST_COMMAND="pytest"
TEST_DIR="./tests"
ERROR_LOG="$(pwd)/error.log" # Absolute path to ensure it's outside the temp directory
TEMP_DIR="temp_repo"

# Ask for user input
read -p "Enter the Git repository URL to clone: " GITHUB_REPOSITORY
read -p "Enter the development branch name: " DEVELOP_BRANCH
read -p "Enter the staging branch name: " STAGING_BRANCH

# Spinner animation
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep "$pid")" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\r"
    done
    printf "    \r"
}

# Log errors
log_error() {
    local error_message="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    if [ ! -f "$ERROR_LOG" ]; then
        touch "$ERROR_LOG"
    fi

    echo "[$timestamp]" >> "$ERROR_LOG"
    echo "$error_message" >> "$ERROR_LOG"
    echo "" >> "$ERROR_LOG"
}

# Loading message animation
loading_message() {
    local message="$1"
    local duration=$2
    printf "%s" "$message"
    for i in $(seq 1 "$duration"); do
        printf "."
        sleep 0.5
    done
    printf "\n"
}

# Create a temporary directory and clone the repository
loading_message "Creating temporary directory and cloning repository $GITHUB_REPOSITORY" 3
mkdir -p "$TEMP_DIR"
git clone "$GITHUB_REPOSITORY" "$TEMP_DIR" &
spinner $!
if [ $? -ne 0 ]; then
    echo "❌ Failed to clone the repository. Check the URL and your network connection."
    exit 1
fi
cd "$TEMP_DIR" || exit 1
echo "✅ Repository cloned successfully."

# Checkout the development branch
loading_message "Switching to development branch $DEVELOP_BRANCH" 2
git checkout "$DEVELOP_BRANCH" &
spinner $!
if [ $? -ne 0 ]; then
    echo "❌ The branch $DEVELOP_BRANCH does not exist."
    exit 1
fi
echo "✅ Checked out to branch $DEVELOP_BRANCH."

# Run tests
export PYTHONPATH=$(pwd)
loading_message "Running tests" 3
echo "Tests in progress..."
$TEST_COMMAND "$TEST_DIR" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    printf "✅ Tests passed successfully.\n\n"

    # Checkout the staging branch and merge
    loading_message "Switching to staging branch $STAGING_BRANCH" 2
    git checkout "$STAGING_BRANCH" &
    spinner $!
    if [ $? -ne 0 ]; then
        echo "❌ The branch $STAGING_BRANCH does not exist."
        exit 1
    fi
    echo "✅ Checked out to branch $STAGING_BRANCH."

    loading_message "Merging $DEVELOP_BRANCH into $STAGING_BRANCH" 2
    git merge "$DEVELOP_BRANCH" &
    spinner $!
    if [ $? -ne 0 ]; then
        echo "❌ Merge conflict occurred. Please resolve it manually."
        exit 1
    fi
    echo "✅ Merge completed successfully."

    # Push the staging branch
    loading_message "Pushing to staging branch $STAGING_BRANCH" 2
    git push origin "$STAGING_BRANCH" &
    spinner $!
    if [ $? -eq 0 ]; then
        printf "✅ Successfully pushed to branch %s.\n\n" "$STAGING_BRANCH"
    else
        printf "❌ Failed to push to branch %s. Check your Git configuration.\n\n" "$STAGING_BRANCH"
        exit 1
    fi
else
    echo "❌ Tests failed."

    last_error=$($TEST_COMMAND "$TEST_DIR" 2>&1)
    log_error "$last_error"
    echo "🚨 Error logged to $ERROR_LOG."
    exit 1
fi

# Cleanup: delete the temporary directory
loading_message "Cleaning up temporary directory" 2
cd ..
rm -rf "$TEMP_DIR"
if [ $? -eq 0 ]; then
    echo "✅ Temporary directory deleted successfully."
else
    echo "❌ Failed to delete temporary directory."
    exit 1
fi

echo "✅ Script completed successfully."
