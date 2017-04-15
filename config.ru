require 'opal'

run Opal::Server.new { |server|
  # the name of the ruby file to load. To use more files they must be required from here (see app)
  server.main = 'hello_world.js.rb'
  # the directory where the code is (add to opal load path )
  server.append_path 'app'
  server.index_path = 'app/index.html.erb'
}
