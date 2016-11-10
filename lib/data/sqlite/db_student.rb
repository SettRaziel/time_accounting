# @Author: Benjamin Held
# @Date:   2016-11-04 19:35:56
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-11-10 21:09:28

module Database

  class DBStudent

    def initialize(db_basic)
      @db = db_basic
      @db.db.execute("CREATE TABLE IF NOT EXISTS
                      Students(Id INTEGER PRIMARY KEY,
                      P_Id INTEGER, Mat_Nr INTEGER,
                      FOREIGN KEY(P_Id) REFERENCES Persons(Id))")
    end

    def insert_student(id, name, mat_nr)
      @db.insert_person(id, name)
      stmt = @db.db.prepare("INSERT INTO Students(P_Id, Mat_Nr) VALUES (?, ?)")
      stmt.execute(id, mat_nr)
    end

    def query_student_by_id(id)
      stmt = @db.db.prepare("SELECT p.Id, p.Name, s.Mat_Nr FROM " \
                            "Students s LEFT JOIN Persons p on p.id=s.p_id " \
                            "WHERE p.id = ?")
      stmt.execute(id)
    end

    def query_student_by_name(name)
      stmt = @db.db.prepare("SELECT p.Id, p.Name, s.Mat_Nr FROM " \
                            "Students s LEFT JOIN Persons p on p.id=s.p_id " \
                            "WHERE p.name = ?")
      stmt.execute(name)
    end

    def query_student_by_matnr(mat_nr)
      stmt = @db.db.prepare("SELECT p.Id, p.Name, s.Mat_Nr FROM " \
                            "Students s LEFT JOIN Persons p on p.id=s.p_id " \
                            "WHERE s.Mat_Nr = ?")
      stmt.execute(id)
    end

    private

    attr_accessor :db

  end

end
