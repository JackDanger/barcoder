require 'rake'
require 'rake/rdoctask'

desc 'Default: build the docs.'
task :default => :rdoc

desc 'Generate documentation for the barcoder plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Barcoder'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
