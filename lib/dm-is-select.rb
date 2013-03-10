# Add all external dependencies for the plugin here
require 'data_mapper'
require 'dm-is-tree'
require 'active_support/core_ext/hash/except' unless {}.respond_to?(:except)
require 'active_support/core_ext/hash/slice'  unless {}.respond_to?(:slice)

# Require plugin-files
require_relative './is/select'

DataMapper::Model.append_extensions(DataMapper::Is::Select)
