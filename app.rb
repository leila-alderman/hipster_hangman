require "sinatra"
require "sinatra/reloader" if development?
require "./game"

get "/" do
  erb :index, layout: :main
end

post "/" do
  redirect "/game"
end

get "/game" do
  game = Game.new
  @status = game.start_game
  erb :game, layout: :main
end



# Select a random word of 5 to 12 letters from the dictionary file.
def get_word(dictionary)
  word = dictionary[rand(dictionary.length)]
  # Ensure that the word is between 5 and 12 letters long.
  if word.length.between?(5,12)
    return word.downcase.strip
  else
    get_word(dictionary)
  end
end

# Initialize the game status parameters.
def start_game
  dictionary = File.readlines("hipster-dictionary.txt")
  secret_word = get_word(dictionary).split("")
  word = secret_word.map do |x| 
    x == "-" ? x = "-" : x = "_"
  end
  return {
    secret_word: secret_word,
    word: word,
    incorrect_guesses: [],
    images: [1, 2, 3, 4, 5, 6, 7]
  }
end