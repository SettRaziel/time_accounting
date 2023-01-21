module DBMapping

  # Class to apply ER-mapping for {Person::Person} objects to a sqlite database
  class PersonMapper < Base

    # initialization
    # @param [String] database the path to the database
    def initialize(database)
      super(database)
    end

    # public method to transform database persons to entity {Person::Person}
    # @return [Array] all transformed {Person::Person} entities
    def generate_persons
      results = @db_base.query_persons
      persons = Array.new()
      results.each { |result|
        persons << Person::Person.new(result['Name'], Integer(result['Id']))
      }
      return persons
    end

    # method to persist a list of {Person::Person}s to the database
    # @param [Array] persons the {Person::Person} that should be be persisted
    def persist_persons(persons)
      persons.each { |person|
        @db_base.insert_person(person.id, person.name)
      }
      nil
    end

    # method to search for a person by its id
    # @return [Person::Person | nil] the result, if found or nil
    def query_person(id)
      result = @db_base.query_person_by_id(id).next
      if (result != nil)
        return Person::Person.new(result['Name'], Integer(result['Id']))
      end
      nil
    end

    # method to query the max id of the person table
    # @return [Integer] the maximal person id
    def query_max_person_id
      check_max_id(@db_base.query_max_person_id.next)
    end

  end

end
