# Digest Rack

> Example using rack and net-http-digest_auth

## Usage example

Server

```
ruby <<'EOF'
require 'rack'

class App
  def call env
    ['200', {'Content-Type' => 'text/plain'}, ["hello world!\n"]]
  end
end

# http://recipes.sinatrarb.com/p/middleware/rack_auth_basic_and_digest
app = Rack::Auth::Digest::MD5.new(App.new) do |username|
  # Return the password for the given user
  {'john' => 'johnsecret'}[username]
end

app.realm = 'Protected Area'
app.opaque = 'secretkey'

Rack::Handler::WEBrick.run app
EOF
[2018-04-18 23:42:03] INFO  WEBrick 1.4.2
[2018-04-18 23:42:03] INFO  ruby 2.5.0 (2017-12-25) [x86_64-darwin17]
[2018-04-18 23:42:03] INFO  WEBrick::HTTPServer#start: pid=2298 port=8080
::1 - - [18/Apr/2018:23:42:41 PDT] "GET / HTTP/1.1" 401 0
- -> /
::1 - - [18/Apr/2018:23:42:41 PDT] "GET / HTTP/1.1" 200 13
- -> /
```

Client

```
ruby <<'EOF'
require 'uri'
require 'net/http'
require 'net/http/digest_auth'

digest_auth = Net::HTTP::DigestAuth.new

uri = URI.parse 'http://localhost:8080/'
uri.user = 'john'
uri.password = 'johnsecret'

h = Net::HTTP.new uri.host, uri.port

req = Net::HTTP::Get.new uri.request_uri

res = h.request req
# res is a 401 response with a WWW-Authenticate header

auth = digest_auth.auth_header uri, res['www-authenticate'], 'GET'

# create a new request with the Authorization header
req = Net::HTTP::Get.new uri.request_uri
req.add_field 'Authorization', auth

# re-issue request with Authorization
res = h.request req

puts res.body
EOF
hello world!
```