require 'opal'
require_relative 'lib/dxopal/version'

desc "Build dxopal.js"
task :build => ["build/dxopal.js"]

desc "Build dxopal.js and dxopal.min.js"
task :build_min => "build/dxopal.min.js"

file "build/dxopal.min.js" => "build/dxopal.js" do |t|
  sh "terser #{t.source} -o #{t.name}"
end

file "build/dxopal.js" => Dir["lib/**/*.rb"] do |t|
  puts "Building #{t.name}..."
  Opal.append_path("lib")
  js = Opal::Builder.build("dxopal.rb").to_s
  File.write(t.name, js)
  puts "Wrote #{t.name}"
end

desc "Rebuild API reference"
task :api do
  sh "yard doc -o doc/api/ lib/**/*.rb lib/**/**/*.rb"
end

desc "Run server"
task :server do
  sh "bundle exec rackup -p 9292"
end

desc "git ci, git tag and git push"
task :release do
  sh "git diff HEAD"
  v = "v#{DXOpal::VERSION}"
  puts "release as #{v}? [y/N]"
  break unless $stdin.gets.chomp == "y"

  sh "bundle install" # to update the version in Gemfile.lock
  sh "rake api"
  sh "rake build_min -B"
  sh "gem build dxopal.gemspec"

  sh "git ci -am '#{v}'"
  sh "git tag '#{v}'"
  sh "git push origin master --tags"
  sh "gem push dxopal-#{DXOpal::VERSION}.gem"
end
