module MultiAppRouting
  APPS = YAML.load_file(RAILS_ROOT+'/config/applications.yml')[RAILS_ENV]
end