module SqliteDatabase

  # Child class of {SqliteDatabase::DBBasic} to add the capabilities to the
  # database to handle {Person::Student} objects
  class DBStudent < DBBasic

    # initialization
    # @param [SQLite3::Database] database a reference of the database
    def initialize(database)
      super(database)
    end

    # method to insert a {Person::Student} into the database
    # @param [Integer] id the id that was generated by the number generator
    #   for person entities
    # @param [String] name the name of the student
    # @param [Integer] mat_nr the matriculation number
    def insert_student(id, name, mat_nr)
      insert_person(id, name)
      stmt = @db.prepare("INSERT OR REPLACE INTO Students(P_Id, Mat_Nr)
                          VALUES (?, ?)")
      stmt.execute(id, mat_nr)
      nil
    end

    # method to query a {Person::Student} by id
    # @param [Integer] id the requested id
    # @return [ResultSet] the results
    def query_student_by_id(id)
      stmt = @db.prepare("SELECT p.Id, p.Name, s.Mat_Nr FROM
                          Students s LEFT JOIN Persons p on p.id=s.p_id
                          WHERE p.id = ?")
      stmt.execute(id)
    end

    # method to query a {Person::Student} by id
    # @param [String] name the requested name
    # @return [ResultSet] the results
    def query_student_by_name(name)
      stmt = @db.prepare("SELECT p.Id, p.Name, s.Mat_Nr FROM
                          Students s LEFT JOIN Persons p on p.id=s.p_id
                          WHERE p.name = ?")
      stmt.execute(name)
    end

    # method to query a {Person::Student} by matriculation number
    # @param [Integer] mat_nr the requested matriculation number
    # @return [ResultSet] the results
    def query_student_by_matnr(mat_nr)
      stmt = @db.prepare("SELECT p.Id, p.Name, s.Mat_Nr FROM
                          Students s LEFT JOIN Persons p on p.id=s.p_id
                          WHERE s.Mat_Nr = ?")
      stmt.execute(id)
    end

    # method to query all {Person::Student}s
    # @return [ResultSet] the results
    def query_students
      stmt = @db.prepare("SELECT p.Id, p.Name, s.Mat_Nr FROM
                          Students s LEFT JOIN Persons p on p.id=s.p_id")
      stmt.execute
    end

    # method to query a metriculcation number for a given id
    # @param [Integer] id the query id
    # @return [ResultSet] the result
    def query_matnr_for_student(id)
      stmt = @db.prepare("SELECT s.Mat_Nr FROM Students s WHERE s.P_Id = ?")
      stmt.execute(id)
    end

    private

    # overwritten method from the parent class to specify the creation of
    # additional required tables
    def generate_additional_tables
      @db.execute("CREATE TABLE IF NOT EXISTS
                   Students(Id INTEGER PRIMARY KEY,
                   P_Id INTEGER, Mat_Nr INTEGER,
                   FOREIGN KEY(P_Id) REFERENCES Persons(Id))")
    end

  end

end
