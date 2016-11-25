# @Author: Benjamin Held
# @Date:   2016-11-25 19:47:28
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-11-25 20:41:39

require_relative '../../entity/person/person'

module DBMapping

  class PersonMapper

    attr_reader :persons

    def initialize(db)
      generate_persons(query_persons(db))
    end

    private

    def query_persons(db)
      stmt = db.prepare("SELECT * FROM Persons")
      db.results_as_hash = true
      stmt.execute
    end

    def generate_persons(results)
      @persons = Array.new()
      results.each { |result|
        @persons << Person::Person.new(result['Name'], Integer(result['Id']))
      }
      nil
    end

  end

end
