require 'ftools'
File.copy(File.join(File.dirname(__FILE__), 'templates/applications.yml'), RAILS_ROOT+'/config')
