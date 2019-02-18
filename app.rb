require "sinatra"
require "sinatra/reloader" if development?
require "./game"

get "/" do
  "Hello world"
end