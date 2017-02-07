# @Author: Benjamin Held
# @Date:   2017-02-02 21:27:19
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2017-02-07 17:42:43

module DBMapping

  # This class serves as a parent class for the mapper classes to store common
  # methods and attributes
  class Base

    # initialization
    # @param [SQLite3::Database] database a reference of the database
    def initialize(database)
      @db_base = SqliteDatabase::DBBasic.new(database)
    end

    private

    # @return [DBBasic] the basic database adapter
    attr_reader :db_base

    # helper method to determine the maximam id of the given database table
    # @param [ResultSet | nil] result the query result with the given max id
    def check_max_id(result)
      if (result != nil)
        Integer(result['Id'])
      else
        0
      end
    end

  end

end
