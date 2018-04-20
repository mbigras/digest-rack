require 'httparty'

class C
  include HTTParty
  base_uri 'localhost:8080'
  def initialize username, password
    self.class.digest_auth username, password
  end

  def call
    res = self.class.get '/'
    if res.success?
      res.parsed_response
    end
  end
end

o1 = C.new 'john', 'johnsecret'
p o1.call #=> "hello world!\n"
o2 = C.new 'john', 'wrong'
p o2.call #=> nil
p o1.call #=> nil

class B
  attr_reader :username, :password
  def initialize username, password
    @username = username
    @password = password
  end

  def call
    singleton_class.base_uri 'localhost:8080'
    singleton_class.digest_auth username, password
    res = singleton_class.get '/'
    if res.success?
      res.parsed_response
    end
  end
end

o1 = B.new 'john', 'johnsecret'
class << o1
  include HTTParty
end
p o1.call #=> "hello world!\n"
o2 = C.new 'john', 'wrong'
class << o1
  include HTTParty
end
p o2.call #=> nil
p o1.call #=> "hello world!\n"