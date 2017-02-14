# @Author: Benjamin Held
# @Date:   2017-02-08 18:32:01
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2017-02-14 07:11:24

module DBMapping

  # Class to apply ER-mapping for {Person::Person} and {Person::Student} objects
  # to a sqlite database
  class StudentMapper < PersonMapper

    # initialization
    # @param [String] database the path to the database
    def initialize(database)
      @db_base = SqliteDatabase::DBStudent.new(database)
    end

    # public method to transform database persons to entity {Person}
    # @return [Array] all transformed {Person} entities
    def generate_persons
      results = @db_base.query_persons
      persons = Array.new()
      results.each { |result|
        id = Integer(result['Id'])
        mat_nr = @db_base.query_matnr_for_student(id).next
        if (mat_nr != nil)
          persons << Person::Student.new(result['Name'], id, mat_nr['Mat_Nr'])
        else
          persons << Person::Person.new(result['Name'], id)
        end
      }
      return persons
    end

    # method to persist a list of {Person}s to the database
    # @param [Array] persons the {Person}s that should be be persisted
    def persist_persons(persons)
      persons.each { |person|
        case (person)
        when Person::Student
          @db_base.insert_student(person.id, person.name, person.mat_nr)
        when Person::Person
          @db_base.insert_person(person.id, person.name)
        else
          raise ArgumentError, 'Cannot persist object. Class not found.'
        end
      }
      nil
    end

    # method to search for a person by its id
    # @return [Person::Person | nil] the result, if found or nil
    def query_person(id)
      result = query_student(id)
      return result if (result != nil)
      result = @db_base.query_person_by_id(id).next
      if (result != nil)
        return Person::Person.new(result['Name'], Integer(result['Id']))
      end
      nil
    end

  end

end
