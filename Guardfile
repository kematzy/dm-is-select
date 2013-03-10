# A sample Guardfile
# More info at https://github.com/guard/guard#readme


notification :growl

# guard 'rspec', :version => 2 do
guard 'rspec', :cli => "--color --format d " do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { "spec" }
  watch('spec/spec_helper.rb')  { "spec" }
  
end
