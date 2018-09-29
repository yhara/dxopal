require 'opal-parser'
def require_remote(url)
  %x{
    var r = new XMLHttpRequest();
    r.overrideMimeType("text/plain"); // https://github.com/yhara/dxopal/issues/12
    r.open("GET", url, false);
    r.send('');
  }
  eval `r.responseText`
end
