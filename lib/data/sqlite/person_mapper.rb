# @Author: Benjamin Held
# @Date:   2016-11-25 19:47:28
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-11-30 20:58:56

require_relative '../../entity/person/person'
require_relative 'db_basic'

module DBMapping

  class PersonMapper

    def initialize(filepath)
      @db_base = Database::DBBasic.new(filepath)
    end

    def generate_persons
      results = @db_base.query_persons
      persons = Array.new()
      results.each { |result|
        persons << Person::Person.new(result['Name'], Integer(result['Id']))
      }
      return persons
    end

    def persist_persons(persons)
      persons.each { |person|
        @db_base.insert_person(person.id, person.name)
      }
    end

    private

    attr_reader :db_base

  end

end
