# Git Automation Toolkit
## Overview
The Git Automation Toolkit is a shell script designed to streamline typical Git workflows, particularly merging changes from a development branch to a staging branch after successful testing. It is ideal for teams working in CI/CD environments who need faster processes for testing and deploying changes.
The script automates the following tasks:
- Cloning a Git repository.
- Checking out a development branch.
- Running tests on the code.
- Merging changes to the staging branch after tests pass.
- Pushing the staging branch to the remote repository.
- Logging errors and handling cleanup if something goes wrong.

This tool reduces manual intervention and adds consistency to essential processes in both small and large-scale development workflows.
## Features
- Automatically clones a Git repository and switches branches.
- Detects and resolves issues with missing branches or failed operations.
- Runs tests using the `pytest` testing framework.
- Automatically merges development branch changes to the staging branch after successful test execution.
- Logs errors to a file for easier debugging.
- Provides animations for a better user experience.
- Removes temporary directories used during execution.

## Requirements
Before using this script, ensure you have the following requirements in place:
### Prerequisites
- **Operating System:** Linux or macOS (or Windows with a bash environment like Cygwin or WSL)
- **Git**: Version control system installed (`git` command must be accessible)
- **Python**: Ensure Python is installed and `pytest` is set up for running tests.
- **Bash Shell**: The script is written for Bash.

## Installation
1. Clone this repository to your local system:
``` bash
    git clone <REPLACE-WITH-YOUR-REPO-URL>
    cd <repository-directory>
```
1. Ensure the script has permission to execute:
``` bash
    chmod +x test.sh
```
1. (Optional) Install `pytest` if not already installed:
``` bash
    pip install pytest
```
## Usage
1. Run the script by executing the following command:
``` bash
    ./test.sh
```
1. You will be prompted to provide the following information:
    - The Git Repository URL to clone (e.g., `https://github.com/username/repository.git`).
    - The name of the development branch (e.g., `develop` or `main`).
    - The name of the staging branch (e.g., `staging`).

2. Follow the prompts as the script works through the following steps:
    - Cloning the repository into a temporary directory.
    - Checking out the development branch.
    - Running tests using `pytest`.
    - Merging to the staging branch if all tests pass.
    - Pushing the updated staging branch to the remote repository.

3. If errors are encountered, they will be logged in the `error.log` file, which is saved in the directory where the script is executed.

## Example Walkthrough
### Example Input
When prompted, suppose the following inputs are provided:
- Repository URL: `https://github.com/example/project.git`
- Development branch: `develop`
- Staging branch: `staging`

### Output/Execution Flow
- The script clones `https://github.com/example/project.git` into a temporary directory.
- It switches to the `develop` branch and runs `pytest` in the `./tests` directory.
- If tests pass:
    - Merges `develop` into `staging`.
    - Pushes the updates to the `staging` branch.
    - Cleans up the temporary directory.

- If tests fail:
    - Errors will be logged in a file named `error.log`.
    - No merge will occur, and the process will terminate.

## Error Handling
- If tests fail, the script logs details in `error.log`.
- If the repository URL or branch names are incorrect, the script informs the user and gracefully exits.
- If there's a merge conflict, the user will need to resolve it manually before rerunning the script.

Error Log Example:
``` 
[2023-03-15 14:35:18]
pytest failed with the following output:
==========================
test_example.py::TestFeature::test_functionality FAILED
...
```
## Cleanup Process
After the script completes, it will:
1. Delete the temporary directory used for cloning.
2. Retain the `error.log` file (if errors occurred) for debugging purposes.

## Limitations
- The script works only when `pytest` is correctly configured. Ensure your test cases are set up in the `./tests` directory.
- Currently supports only Bash environments.
- Assumes a structure where development and staging branches are already part of your repository.

## Contribution
Contributions are always welcome! To contribute:
1. Fork the repository.
2. Create a new feature branch.
3. Submit a pull request with clear descriptions of changes.

Please ensure all tests pass before submitting a pull request.
## License
This project is licensed under the MIT License. See the `LICENSE` file in this repository for details.
## Acknowledgments
Special thanks to all contributors and testers who helped streamline this Git automation process.
