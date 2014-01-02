require 'sinatra'

class Staticbot < Sinatra::Base
  get '/' do
    "Hello world"
  end
end
