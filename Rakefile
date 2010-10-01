require 'rake'
require 'rake/rdoctask'


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "barcoder"
    gem.summary = %Q{Barcode image generation library, for non-write filesystems.}
    gem.description = %Q{This library is designed to support streaming barcode information, from GBarcode, straight to the web browser using data urls. This is ideal for no-write filesystem scenarios.}
    gem.email = "derek@derekperez.com"
    gem.homepage = "http://github.com/perezd/barcoder"
    gem.authors = ["Derek Perez", "Jack Danger Canty"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end


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
