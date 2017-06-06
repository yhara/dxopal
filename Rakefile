require 'opal'
require 'uglifier'

desc "Build dxopal.js"
task :build => ["build/dxopal.js"]

desc "Build dxopal.js and dxopal.min.js"
task :build_min => ["build/dxopal.min.js", "dxopal-game/dxopal.min.js"]

file "dxopal-game/dxopal.min.js" => "build/dxopal.min.js" do |t| cp t.source, t.name end

file "build/dxopal.min.js" => "build/dxopal.js" do |t|
  puts "Minifying (this may take a little time)"
  File.write(t.name, Uglifier.compile(File.read(t.source)))
end

file "build/dxopal.js" => "opal/dxopal.rb" do |t|
  Opal.append_path("opal")
  File.write(t.name, Opal::Builder.build("dxopal.rb").to_s)
end
