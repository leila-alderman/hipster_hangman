require "sinatra"
require "sinatra/reloader" if development?

enable :sessions

get "/" do
  erb :index, layout: :main
end

post "/" do
  redirect "/game"
end

get "/game" do
  session["status"] ||= start_game
  @status = session["status"]
  erb :game, layout: :main
end

post "/game" do
  @status = session["status"]
  @guess = params["guess"]
  session["status"] = round(@status, @guess)
  redirect "/game"
end



# Initialize the game status parameters.
def start_game
  dictionary = File.readlines("hipster-dictionary.txt")
  secret_word = get_word(dictionary).split("")
  word = secret_word.map do |x| 
    x == "-" ? x = "-" : x = "_"
  end
  {
    secret_word: secret_word,
    word: word,
    incorrect_guesses: [],
    images: [1, 2, 3, 4, 5, 6, 7]
  }
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

# Overall game structure
def play
  status = start_game
  show_board(status)
  playing = true
  while playing == true
    status = round(status)
    if status == false
      playing = false
      return
    end
    if status[:secret_word] == status[:word]
      puts "Congratulations! You win!"
      playing = false
    elsif status[:incorrect_guesses].length >= 6
      puts "Sorry, you lost. The secret word was '#{status[:secret_word].join("")}'."
      playing = false
    end
  end
end

# Play a round of hangman
def round(status, guess)

  if guess.length > 1
    if guess == @status[:secret_word]
      puts "Congratulations! You win!"
    else
      puts "Sorry, that's not the secret word."
      round(game_status)
    end
  else
    if status[:secret_word].include?(guess)
      status[:secret_word].each_with_index do |letter, i|
        status[:word][i] = guess if status[:secret_word][i] == guess
      end
    else
      status[:incorrect_guesses] << guess
    end
  end
  return status
end