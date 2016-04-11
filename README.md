# Work Accounting
[![Code Climate](https://codeclimate.com/github/SettRaziel/time_accounting/badges/gpa.svg)](https://codeclimate.com/github/SettRaziel/time_accounting)

Ruby program for tracking working hours or other tasks and storing the on your
device. The stored data shall be queried for different options such as
monthly or weekly working hours.

## Development steps
* Reading and storing tasks and persons in a file (actual)
* Terminal menu to read/write data and some queries for the data (in progress)
* Formatted terminal output for the queries (in progress)
* Formatted pdf output using latex
* Reading, storing and querying tasks and persons in a database (e.g. sqlite)
* Deleting existing persons and tasks and freeing their blocked ids
* Extension of query capabilities

## Usage & Help
```
access to main menu: ruby <script>
help usage :  ruby <script> (-h | --help)

WorkAccounting help:
 -h, --help     show help text
 -v, --version  prints the current version of the project
```

## Used version
Written with Ruby >= 2.2.2

## Tested
* Linux: running with Ruby >= 2.2.2
* Windows: not tested
* MAC: not tested

## Requirements
* none

## License
see LICENSE

created by: Benjamin Held
