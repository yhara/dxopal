require 'opal'

desc "Build dxopal.js"
task :build => ["build/dxopal.js"]

desc "Build dxopal.js and dxopal.min.js"
task :build_min => ["build/dxopal.min.js", "dxopal-game/dxopal.min.js"]

file "dxopal-game/dxopal.min.js" => "build/dxopal.min.js" do |t| cp t.source, t.name end

file "build/dxopal.min.js" => "build/dxopal.js" do |t|
  sh "uglifyjs #{t.source} -o #{t.name}"
end

file "build/dxopal.js" => Dir["opal/**/*.rb"] + ["vendor/matter.js"] do |t|
  Opal.append_path("opal")
  js = Opal::Builder.build("dxopal.rb").to_s
  js << File.read("vendor/matter.js")
  File.write(t.name, js)
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

# WebAssembly stuffs (experimental)
#
# source ~/rr_2017/emsdk-portable/emsdk_env.sh
namespace "wasm" do

  # Compile with LLVM's experimental wasm support
  task :compile do
    chdir "wasm" do
      name = "collision_checker_double"
      out = "collision_checker_double"
      sh "clang -O3 -emit-llvm --target=wasm32 -S #{name}.c -o #{out}.ll"
      sh "~/rr_2017/bin/llvm/bin/llc #{out}.ll -march=wasm32"
      sh "#{ENV['BINARYEN_ROOT']}/bin/s2wasm #{out}.s -o #{out}.wast"
      sh "#{ENV['BINARYEN_ROOT']}/bin/wasm-as -o #{out}.wasm #{out}.wast"
    end
  end

  # Compile with emcc command (via asm.js)
  task :emcc do
    chdir "wasm" do
      name = "collision_checker_double"
      out = "collision_checker_double"
      sh "emcc #{name}.c -s WASM=1 -s \"EXPORTED_FUNCTIONS=['_check_triangle_triangle', '_absolute']\" -o #{out}.html"
      sh "#{ENV['BINARYEN_ROOT']}/bin/wasm-dis -o #{out}.wast #{out}.wasm"
    end
  end
end
