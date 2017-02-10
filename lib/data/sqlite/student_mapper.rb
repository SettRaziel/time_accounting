# @Author: Benjamin Held
# @Date:   2017-02-08 18:32:01
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2017-02-10 18:20:59

module DBMapping

  # Class to apply ER-mapping for {Person::Student} objects to a sqlite database
  class StudentMapper < Base

    # initialization
    # @param [String] database the path to the database
    def initialize(database)
      @db_base = SqliteDatabase::DBStudent.new(database)
    end

    # public method to transform database persons to entity {Person::Student}
    # @return [Array] all transformed {Person::Student} entities
    def generate_students
      results = @db_base.query_students
      students = Array.new()
      results.each { |result|
        students << Person::Student.new(result['Name'], Integer(result['Id']),
                                        Integer(result['Mat_Nr']))
      }
      return persons
    end

    # method to persist a list of {Person::Student}s to the database
    # @param [Array] students the {Person::Student} that should be be persisted
    def persist_students(students)
      students.each { |student|
        @db_base.insert_student(student.id, student.name, student.mat_nr)
      }
      nil
    end

    # method to search for a person by its id
    # @return [Person::Student] the result, if found or nil
    def query_student(id)
      result = @db_base.query_student_by_id(id).next
      Person::Student.new(result['Name'], Integer(result['Id']),
                          Integer(result['Mat_Nr']))
    end

  end

end
