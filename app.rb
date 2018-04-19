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