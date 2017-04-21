require 'opal'
require 'uglifier'

desc "Build dxopal.js"
task :build => "dxopal-game/dxopal.js"

desc "Build dxopal.js and dxopal.min.js"
task :build_min => "dxopal-game/dxopal.min.js"

file "dxopal-game/dxopal.min.js" => "dxopal-game/dxopal.js" do |t|
  puts "Minifying (this may take a little time)"
  File.write(t.name, Uglifier.compile(File.read(t.source)))
end

file "dxopal-game/dxopal.js" => "opal/dxopal.rb" do |t|
  Opal.append_path("opal")
  File.write(t.name, Opal::Builder.build("dxopal.rb").to_s)
end
