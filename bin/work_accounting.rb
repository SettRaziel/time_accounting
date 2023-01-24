require_relative '../lib/menu/menu'
require_relative '../lib/parameter/parameter_repository'
require_relative '../lib/output/help_output'

# call to print version number and author
def print_version
  puts 'work_accouting version 0.3.1'.yellow
  puts 'Created by Benjamin Held (September 2015)'.yellow
end

#-------------------------------------------------------------------------------
# Work Accounting Script
# Version 0.3.1
# created by Benjamin Held, September 2015

begin
  if (ARGV.size > 0)
    parameters = Parameter::ParameterRepository.new(ARGV)
    if (parameters.parameters[:help])
      HelpOutput.print_help_for(parameters.parameters[:help])
    elsif (parameters.parameters[:version])
      print_version
    end
  else
    Menu::MainMenu.new.print_menu
  end

rescue StandardError, NotImplementedError => e
  puts "#{e.message}".red
  puts "For help type: ruby <script> --help".green
  nil
end
