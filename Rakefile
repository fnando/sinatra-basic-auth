require File.dirname(__FILE__) + "/lib/sinatra/basic_auth/version"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "lib"
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.verbose = true
end

begin
  require "jeweler"

  JEWEL = Jeweler::Tasks.new do |gem|
    gem.name = "sinatra-basic-auth"
    gem.email = "fnando.vieira@gmail.com"
    gem.homepage = "http://github.com/fnando/sinatra-basic-auth"
    gem.authors = ["Nando Vieira"]
    gem.version = Sinatra::BasicAuth::Version::STRING
    gem.summary = "Authentication with BasicAuth that can require different credentials for different realms."
    gem.description = "Authentication with BasicAuth."
    gem.add_dependency "sinatra"
    gem.files =  FileList["README.rdoc", "{lib,test}/**/*"]
  end

  Jeweler::GemcutterTasks.new
rescue LoadError => e
  puts "You don't have Jeweler installed, so you won't be able to build this gem."
end
