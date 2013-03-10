$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'rspec'
require 'data_mapper'
require 'dm-is-tree'
require_relative './../lib/dm-is-select'

def load_driver(name, default_uri)
  return false if ENV['ADAPTER'] != name.to_s

  begin
    DataMapper.setup(name, ENV["#{name.to_s.upcase}_SPEC_URI"] || default_uri)
    DataMapper::Repository.adapters[:default] =  DataMapper::Repository.adapters[name]
    true
  rescue LoadError => e
    warn "Could not load do_#{name}: #{e}"
    false
  end
end

# support Mac OS X MAMP installation of MySQL
socket_path = test(?d, "/Applications/MAMP/") ? '?socket=/Applications/MAMP/tmp/mysql/mysql.sock' : ''

ENV['ADAPTER'] ||= 'sqlite3'
# ENV['ADAPTER'] ||= 'mysql'

HAS_SQLITE3  = load_driver(:sqlite3,  'sqlite3::memory:')
HAS_MYSQL    = load_driver(:mysql,    "mysql://root:root@localhost/dm_core_test#{socket_path}")
HAS_POSTGRES = load_driver(:postgres, 'postgres://postgres@localhost/dm_core_test')
