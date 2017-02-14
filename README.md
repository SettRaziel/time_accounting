# Work Accounting
[![Code Climate](https://codeclimate.com/github/SettRaziel/time_accounting/badges/gpa.svg)](https://codeclimate.com/github/SettRaziel/time_accounting)

Ruby program for tracking working hours or other tasks and storing the on your
device. The stored data shall be queried for different options such as
monthly, weekly working hours or self defined time intervals. A terminal menu
guides trough the different options.

## Development steps
* Reading and storing tasks and persons in a file (done with v0.1.0)
* Terminal menu to read/write data and some queries for the data (mostly
  done with v0.2.0)
* Formatted terminal output for the queries (basic with v0.2.0, but will be extended)
* Formatted pdf output using latex, formatted csv output (basic csv output
  with v0.2.1)
* Reading, storing and querying tasks and persons in a database
  * Storage in sqlite3 database as main feature of v0.3.0
* Deleting existing persons and tasks and freeing their blocked ids
* Extension of query capabilities

## Usage & Help
The menus explain themselves. The basic script calls are:

```
access to main menu: ruby <script>
help usage :  ruby <script> (-h | --help)

WorkAccounting help:
 -h, --help     show help text
 -v, --version  prints the current version of the project
```

## Documentation
Documentation is written in yard and can be created by running the shell-script
`create_yard.sh`. Yard needs to be installed on the system in order to do that.
The documentation can also be found online [here](https://bheld.eu/doc/accounting_doc/frames.html).

## Used version
Written with Ruby >= 2.2.2

## Tested
* Linux: running with Ruby >= 2.2.2
* Windows: not tested
* MAC: not tested

## Requirements
* Ruby with a version > 2.2
* csv (all)
* sqlite3 (when using sqlite3 as database backend)
* yard (optional for documentation)

## License
see LICENSE

created by: Benjamin Held
