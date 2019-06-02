# How to develop DXOpal

1. `npm install uglifyjs -g`
2. `bundle install`

# How to update Opal

1. `bundle update`
2. `rake build_min -B`

# How to make a release

1. Test
  - rackup and open http://localhost:9292/
  - Open starter-kit/index.html in Firefox
1. Edit opal/dxopal/version.rb
1. Add release date in CHANGELOG.md
1. `rake release`
