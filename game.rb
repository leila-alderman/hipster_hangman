class Game
    
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

  # Display the hangman board.
  def show_board(game_status)
    num_wrong = game_status[:incorrect_guesses].length
    puts game_status[:images][num_wrong]
    puts "Incorrect guesses: "
    puts game_status[:incorrect_guesses].join(", ")
    puts "You have #{6-num_wrong} more incorrect guesses."
    puts
    puts "Word to guess:"
    puts game_status[:word].join(" ")
    puts
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
      images: ['
        +---+
        |   |
        |    
        |    
        |    
        |   
      ==========', '
        +---+
        |   |
        |   O 
        |    
        |    
        |   
      ==========', '
        +---+
        |   |
        |   O 
        |   | 
        |    
        |   
      ==========', '
        +---+
        |   |
        |   O 
        |  /| 
        |    
        |   
      ==========', '
        +---+ 
        |   | 
        |   O 
        |  /|\ 
        |     
        |      
      ==========', '
        +---+ 
        |   | 
        |   O 
        |  /|\ 
        |  /  
        |      
      ==========', '
        +---+ 
        |   | 
        |   O  
        |  /|\ 
        |  / \ 
        |   
      ==========']
    }
  end

  # Play a round of hangman.
  def round(game_status)
    puts "Guess a new letter! Otherwise, enter 1 to solve the puzzle, 0 to quit, or 5 to save your game."
    guess = gets.chomp.downcase
    if guess == "0"
      puts "Thanks for playing! Bye!"
      return false
    elsif guess == "1"
      # Let the player guess the full answer.
      word_guess = gets.chomp.downcase.strip.split("")
      if word_guess == game_status[:secret_word]
        puts "Congratulations! You win!"
        return false
      else
        puts "Sorry, that's not the secret word."
        round(game_status)
      end
    elsif guess == "5"
      # Save the game.
      save_state = game_status.to_yaml
      savefile = File.open("savefile.txt", "w") { |f| f.puts save_state}
      puts "Your current game has been saved. See you again soon!"
      return false
    elsif guess.length > 1
      puts "Please enter only one letter at a time. Try again."
      round(game_status)
    else
      if game_status[:secret_word].include?(guess)
        game_status[:secret_word].each_with_index do |letter, i|
          game_status[:word][i] = guess if game_status[:secret_word][i] == guess
        end
      else
        game_status[:incorrect_guesses] << guess
      end
      show_board(game_status)
    end
    game_status
  end

end