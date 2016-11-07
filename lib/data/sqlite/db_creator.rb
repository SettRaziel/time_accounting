# @Author: Benjamin Held
# @Date:   2016-10-29 16:25:44
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-11-07 20:12:20

module Database

  class DBCreator

    attr_reader :db

    def initialize(db_path)
      create_database(db_path)
    end

    def create_database(db_path)
      begin
        @db = SQLite3::Database.open(db_path)
        create_tables
      rescue IOError | StandardError
        raise ArgumentError, "Error [DBCreator]: invalid path to database."
      end
    end

    private

    def create_tables
      @db.execute("CREATE TABLE IF NOT EXISTS Persons(Id INTEGER PRIMARY KEY,
                   Name TEXT)")
      @db.execute("CREATE TABLE IF NOT EXISTS Students(Id INTEGER PRIMARY KEY,
                   P_Id INTEGER, Mat_Nr INTEGER,
                  FOREIGN KEY(P_Id) REFERENCES Persons(Id))")
      @db.execute("CREATE TABLE IF NOT EXISTS Tasks(Id INTEGER PRIMARY KEY,
                   Start TEXT, End TEXT, Description TEXT)")
      @db.execute("CREATE TABLE IF NOT EXISTS Matching(Id INTEGER PRIMARY KEY,
                   P_Id INTEGER, T_Id INTEGER,
                   FOREIGN KEY(P_Id) REFERENCES Persons(Id),
                   FOREIGN KEY(T_Id) REFERENCES Tasks(Id))")
    end

  end

end
