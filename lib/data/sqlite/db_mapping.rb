#!/home/benjamin/.rvm/rubies/default/bin/ruby
# @Author: Benjamin Held
# @Date:   2017-01-21 19:31:26
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2017-02-04 15:44:04

require_relative '../../entity/person/person'
require_relative '../../entity/task'
require_relative 'db_basic'

module DBMapping

  require_relative 'base_mapper'
  require_relative 'person_mapper'
  require_relative 'relations_mapper'
  require_relative 'task_mapper'

end
