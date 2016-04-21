# @Author: Benjamin Held
# @Date:   2016-01-30 17:36:19
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-04-21 14:31:11

require_relative '../lib/menu/menu'
require_relative '../lib/parameter/parameter_repository'
require_relative '../lib/output/help_output'

# call to print version number and author
def print_version
  puts 'work_accouting version 0.1.0'
  puts 'Created by Benjamin Held (September 2015)'
end

#-------------------------------------------------------------------------------
# Work Accounting Script
# Version 0.1.0
# created by Benjamin Held, September 2015
if (ARGV.size > 0)
  parameters = ParameterRepository.new(ARGV)
  if (parameters.parameters[:help])
    HelpOutput.print_help_for(parameters.parameters[:help])
  elsif (parameters.parameters[:version])
    print_version
  end
else
  Menu::MainMenu.print_menu
end
