require "sinatra"
require "sinatra/reloader" if development?
require "./game"

get "/" do
  erb :index, layout: :main
end