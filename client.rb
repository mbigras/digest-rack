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