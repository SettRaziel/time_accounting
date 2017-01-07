# @Author: Benjamin Held
# @Date:   2016-10-29 16:25:44
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2017-01-07 14:31:26

# This module holds classes that specify the required sql queries that are
# neccessary to use the application with an sqlite database storage
module SqliteDatabase

  # Basic class to open and manage the usage of a sqlite3 database as a storage
  # system. Child classes should use {#generate_additional_tables} to create
  # required tables for use.
  class DBBasic

    # initialization
    # @param [SQLite3::Database] database a reference of the database
    def initialize(database)
      @db = database
      create_tables
    end

    # method to insert a {Person::Person} into the database
    # @param [Integer] id the id that was generated by the number generator
    #   for person entities
    # @param [String] name the name of the person
    def insert_person(id, name)
      stmt = @db.prepare("INSERT OR REPLACE INTO Persons(Id, Name)
                          VALUES (?, ?)")
      stmt.execute(id, name)
      nil
    end

    # method to insert a {Task::Task} into the database
    # @param [Integer] id the id that was generated by the number generator
    #   for person entities
    # @param [Date] start_time the starting point of the task
    # @param [Date] end_time the ending point of the task
    # @param [String] description the description of the task
    def insert_task(id, start_time, end_time, description)
      stmt = @db.prepare("INSERT OR REPLACE INTO
                          Tasks(Id, Start, End, Description)
                          VALUES (?, ?, ?, ?)")
      stmt.execute(id, start_time.iso8601, end_time.iso8601, description)
      nil
    end

    # method to add a {Task::Task} to a person entity
    # @param [Integer] p_id the unique id of the person
    # @param [Integer] t_id the unique id of the task
    def map_task_to_person(p_id, t_id)
      stmt = @db.prepare("INSERT OR REPLACE INTO Matching(P_Id, T_Id)
                          VALUES (?, ?)")
      stmt.execute(p_id, t_id)
      nil
    end

    # method to query a {Task::Task} by id
    # @param [Integer] id the requested id
    # @return [ResultSet] the results
    def query_task(id)
      stmt = @db.prepare("SELECT * FROM Tasks WHERE Id = ?")
      stmt.execute(id)
    end

    # method to query all stored {Task::Task}
    # @return [ResultSet] the results
    def query_tasks
      stmt = @db.prepare('SELECT * FROM Tasks')
      stmt.execute
    end

    # method to query a {Person::Person} by id
    # @param [Integer] id the requested id
    # @return [ResultSet] the results
    def query_person_by_id(id)
      stmt = @db.prepare("SELECT * FROM Persons WHERE Id = ?")
      stmt.execute(id)
    end

    # method to query a {Person::Person} by name
    # @param [String] name the requested name
    # @return [ResultSet] the results
    def query_person_by_name(name)
      stmt = @db.prepare("SELECT * FROM Persons WHERE Name = ?")
      stmt.execute(name)
    end

    # method to query all stored {Person::Person}s
    # @return [ResultSet] the results
    def query_persons
      stmt = @db.prepare("SELECT * FROM Persons")
      stmt.execute
    end

    # method to query the mapping of assigned tasks to persons
    # @return [ResultSet] the query result
    def query_assignments
      stmt = @db.prepare('SELECT * FROM Matching')
      stmt.execute
    end

    private

    # @return
    attr_reader :db

    # method to create the required tables in the database
    def create_tables
      @db.execute("CREATE TABLE IF NOT EXISTS Persons(Id INTEGER PRIMARY KEY,
                   Name TEXT)")
      @db.execute("CREATE TABLE IF NOT EXISTS Tasks(Id INTEGER PRIMARY KEY,
                   Start TEXT, End TEXT, Description TEXT)")
      @db.execute("CREATE TABLE IF NOT EXISTS Matching(Id INTEGER PRIMARY KEY,
                   P_Id INTEGER, T_Id INTEGER,
                   FOREIGN KEY(P_Id) REFERENCES Persons(Id),
                   FOREIGN KEY(T_Id) REFERENCES Tasks(Id))")
      generate_additional_tables
      nil
    end

    # method for child classes to specify the generation of additional tables
    def generate_additional_tables
      # no additional tables
    end

  end

end

require_relative 'db_student'
