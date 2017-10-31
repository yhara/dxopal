require 'opal'
require_relative 'opal/dxopal/version'

desc "Build dxopal.js"
task :build => ["build/dxopal.js"]

desc "Build dxopal.js and dxopal.min.js"
task :build_min => ["build/dxopal.min.js", "starter-kit/dxopal.min.js"]

file "starter-kit/dxopal.min.js" => "build/dxopal.min.js" do |t| cp t.source, t.name end

file "build/dxopal.min.js" => "build/dxopal.js" do |t|
  sh "uglifyjs #{t.source} -o #{t.name}"
end

file "build/dxopal.js" => Dir["opal/**/*.rb"] + ["vendor/matter.js"] do |t|
  Opal.append_path("opal")
  js = Opal::Builder.build("dxopal.rb").to_s
  js << File.read("vendor/matter.js")
  File.write(t.name, js)
end

desc "Rebuild API reference"
task :api do
  sh "yard doc -o doc/api/ opal/**/*.rb"
end

namespace "release" do
  desc "Make a release commit"
  task :prepare do
    sh "rake build_min -B"
    sh "gem build dxopal.gemspec"
    sh "git ci -a -m 'v#{DXOpal::VERSION}'"
  end

  desc "Make a release commit"
  task :push do
    sh "git tag 'v#{DXOpal::VERSION}'"
    sh "git push origin master --tags"
  end

  desc "Release gem"
  task :push_gem do
    sh "gem build dxopal.gemspec"
    sh "gem push dxopal-#{DXOpal::VERSION}.gem"
  end

  desc "Make a release commit"
  task :push_kit do
    cd "starter-kit" do
      sh "git ci dxopal.min.js -m 'v#{DXOpal::VERSION}'"
      sh "git tag 'v#{DXOpal::VERSION}'"
      sh "git push origin master --tags"
    end
  end
end

# How to make a release
# TODO: should edit lib/dxopal/version.rb :-\
# 1. Edit CHANGELOG.md
# 2. `rake release:prepare`
# 3. Test
#   - Open starter-kit/index.html in Firefox
#   - rackup and open http://localhost:9292/
# 4. `rake release:push`
# 5. `rake release:push_game`
