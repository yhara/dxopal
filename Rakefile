require 'opal'

desc "Build dxopal.js"
task :build => ["build/dxopal.js"]

desc "Build dxopal.js and dxopal.min.js"
task :build_min => ["build/dxopal.min.js", "dxopal-game/dxopal.min.js"]

file "dxopal-game/dxopal.min.js" => "build/dxopal.min.js" do |t| cp t.source, t.name end

file "build/dxopal.min.js" => "build/dxopal.js" do |t|
  puts "Minifying (this may take a little time)"
  sh "uglifyjs #{t.source} -o #{t.name}"
end

file "build/dxopal.js" => Dir["opal/**/*.rb"] do |t|
  Opal.append_path("opal")
  File.write(t.name, Opal::Builder.build("dxopal.rb").to_s)
end

namespace "release" do
  desc "Make a release commit"
  task :prepare do
    ver = ENV.fetch("VER")
    sh "git stash"
    sh "rake build_min -B"
    sh "git ci -m 'v#{ver}'"
  end

  desc "Make a release commit"
  task :push do
    ver = ENV.fetch("VER")
    sh "git tag 'v#{ver}'"
    sh "git push origin master --tags"
  end

  desc "Make a release commit"
  task :push_game do
    ver = ENV.fetch("VER")
    cd "dxopal-game" do
      sh "git ci dxopal.min.js -m 'v#{ver}'"
      sh "git tag 'v#{ver}'"
      sh "git push origin master --tags"
    end
  end
end

# How to make a release
# TODO: should edit lib/dxopal/version.rb :-\
# 1. Edit CHANGELOG.md
# 2. `rake release:prepare`
# 3. Test
#   - Open dxopal-game/index.html in Firefox
#   - rackup and open http://localhost:9292/
# 4. `rake release:push`
# 5. `rake release:push_game`
