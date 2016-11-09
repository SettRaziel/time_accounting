# @Author: Benjamin Held
# @Date:   2016-10-29 16:25:44
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-11-09 20:14:12

module Database

  class DBBasic

    attr_reader :db

    def initialize(db_path)
      create_database(db_path)
    end

    def create_database(db_path)
      begin
        @db = SQLite3::Database.open(db_path)
        create_tables
      rescue IOError || StandardError
        raise ArgumentError, "Error [DBCreator]: invalid path to database."
      end
    end

    def insert_person(id, name)
      stmt = @db.prepare("INSERT INTO Persons(Id, Name) VALUES (?, ?)")
      stmt.execute(id, name)
    end

    def insert_task(id, start_time, end_time, description)
      stmt = @db.prepare("INSERT INTO Tasks(Id, Start, End, Description) " \
                         "VALUES (?, ?, ?, ?)")
      stmt.execute(id, start_time.iso8601, end_time.iso8601, description)
    end

    def query_task(id)
      stmt = @db.prepare("SELECT * FROM Tasks WHERE Id = ?")
      stmt.execute(id)
    end

    def query_person_by_id(id)
      stmt = @db.prepare("SELECT * FROM Persons WHERE Id = ?")
      stmt.execute(id)
    end

    def query_person_by_name(name)
      stmt = @db.prepare("SELECT * FROM Persons WHERE Name = ?")
      stmt.execute(name)
    end

    private

    def create_tables
      @db.execute("CREATE TABLE IF NOT EXISTS Persons(Id INTEGER PRIMARY KEY,
                   Name TEXT)")
      @db.execute("CREATE TABLE IF NOT EXISTS Tasks(Id INTEGER PRIMARY KEY,
                   Start TEXT, End TEXT, Description TEXT)")
      @db.execute("CREATE TABLE IF NOT EXISTS Matching(Id INTEGER PRIMARY KEY,
                   P_Id INTEGER, T_Id INTEGER,
                   FOREIGN KEY(P_Id) REFERENCES Persons(Id),
                   FOREIGN KEY(T_Id) REFERENCES Tasks(Id))")
    end

  end

end
