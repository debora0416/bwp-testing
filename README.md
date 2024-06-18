# BWP Website Test Automation
This is a Robot Framework test automation project for the BWP Tool website (https://bwpool.azurewebsites.net/). The project includes one test case covering various functionalities of the website, such as add customer, location, tools and export excel file.

## Prerequisites
- Python 3.x (Robot Framework is Python-based)
- Robot Framework (Installation: ```pip install robotframework```)
- Robot Framework SeleniumLibrary (Installation: ```pip install --upgrade robotframework-seleniumlibrary```)
- Robot Framework RequestsLibrary (Installation: ```pip install --upgrade robotframework-requestslibrary```)

## Installation
1. Clone the repository:
```
git clone https://github.com/debora0416/bwp-testing.git
```

2. Navigate to the project directory:
```
cd bwp-testing
```

3. Install the required Python libraries:
```
pip install -r requirements.txt
```

## Running Tests
To run the the test suite, use the following command:

```
robot -d ./results ./tests/bwp_tool_test.robot
```

This will execute the test case in the login_tests.robot file and generate a report and log files in the results directory.

## Test Cases
The project includes the following test case:

- bwp_tool_test.robot