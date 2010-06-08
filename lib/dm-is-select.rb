# Needed to import datamapper and other gems
require 'rubygems'
require 'pathname'

# Add all external dependencies for the plugin here
# gem 'dm-core', '~> 0.10.0'
require 'dm-core'
# gem 'extlib', '~> 0.9.13'
# require 'extlib'
# gem 'dm-is-tree', '~> 0.10.0'
require 'dm-is-tree'


# Require plugin-files
require Pathname(__FILE__).dirname.expand_path / 'dm-is-select' / 'is' / 'select.rb'

DataMapper::Model.append_extensions(DataMapper::Is::Select)

# If you wish to add methods to all DM Models, use this:
# 
# DataMapper::Model.append_inclusions(DataMapper::Is::Select::ResourceInstanceMethods)
#
