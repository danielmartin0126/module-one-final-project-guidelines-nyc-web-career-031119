current_user = nil
rival_user = ""
def welcome
  # if trainer database is empty, run new_trainer automatically
  puts "Hi, select on option: -Log In -New Trainer -Exit"
  input = gets.chomp
  if input.downcase == "log in"
    check_log_in
  elsif input.downcase == "new trainer"
    new_trainer
  elsif input.downcase == "exit"
    exit
  else
    puts "Input valid command"
    welcome
 end
end

def check_log_in
  puts "Enter your username:"
  user_name = gets.chomp
  if Trainer.exists? name: user_name
    current_user = Trainer.where name: user_name
    main_menu(current_user[0])
  else
    puts "The is currently no account with that username. Would you like to try again, or create new account?"
    puts "1. Try again 2. New account"
    response = gets.chomp
    if response == "1" || response.downcase == "try again"
      check_log_in
    elsif response == "2" || response.downcase == "new account"
      new_trainer
    end
  end
end

def new_trainer
  puts "Oak : Hello there! Welcome to the world of POKEMON! My name is OAK! People call me the POKEMON PROF! This world is inhabited by creatures called POKEMON! For some people, POKEMON are pets. Others use them for fights. Myself...I study POKEMON as a profession. First, what is your name?"
  name = gets.chomp
  current_user = Trainer.find_or_create_by(name: name)
  puts "Oak : Right! So your name is #{name}! This is my grandson. He's been your rival since you were a baby. ...Erm, what is his name again?"
  rival_name = gets.chomp
  rival_user = Trainer.find_or_create_by(name: rival_name)
  puts "Oak : That's right! I remember now! His name is #{rival_name}! #{name}! Your very own POKEMON legend is about to unfold! A world of dreams and adventures with POKEMON awaits! Let's go!"
  main_menu(current_user)
end



def main_menu(current_user)
 puts "-Catch Pokemon -View Pokemon -Rivals Lookup -Exit"
 case gets.chomp.downcase
 when "catch pokemon"
   puts 1
   encounter(current_user)
 when "view pokemon"
   puts 2
   # view
 when "rivals lookup"
   puts 3
 when "exit"
   puts "Thanks for Playing"
   exit
 else
   puts "Input valid commannd!"
   main_menu(current_user)
 end
end


def encounter(current_user)
  # bonus- don't allow encounter if you have 6 pokemon
  pokemon = Pokemon.order("RANDOM()").first
  puts "You have encountered a wild #{pokemon.name.upcase}!"
  puts pokemon.name.upcase
  puts "L: #{pokemon.level}"
  puts "HP: #{pokemon.hp}/#{pokemon.hp}"
  catch_or_run(current_user, pokemon)
end

def catch_or_run(current_user, pokemon)
  puts "Select an option:"
  puts "1. Catch"
  puts "2. Run"
  # For Catch => can succeed or fail, success adds to pokemon list
  input = gets.chomp
  if input == "1" || input.downcase == "catch"
    CapturedPokemon.find_or_create_by(trainer_id: current_user.id, pokemon_id: pokemon.id)
    puts "You captured #{pokemon.name.upcase}!"
    display_pokemon(pokemon)
    another_pokemon?(current_user)
  elsif input == "2" || input.downcase == "run"
    puts "You got away safely."
    another_pokemon?(current_user)
  else
    puts "Input valid command"
    catch_or_run(current_user, pokemon)
  end
end

def another_pokemon?(current_user)
  prompt = "Would you like to look for another Pokemon? y/n"
  case get_yes_or_no(prompt)
  when "y"
    encounter(current_user)
  when "n"
    main_menu(current_user)
  end
end

def get_yes_or_no(prompt)
  answer = ''
  responses = ['y', 'n']
  no_responses = ['N', 'n', 'no', 'No', 'NO', 'nah', 'Nah']
  yes_responses = ['Yes', 'yes', 'YES', 'Y', 'y', 'ya']
  puts prompt
  while !responses.include?(answer)
    answer = gets.chomp
    if yes_responses.include?(answer)
      answer = 'y'
    elsif no_responses.include?(answer)
      answer = 'n'
    else
      puts "Invalid command"
      puts prompt
    end
  end
  answer
end

def display_pokemon(pokemon)

  puts "L: #{pokemon.level}"
  puts "HP: #{pokemon.hp}"
  puts pokemon.genus
  puts pokemon.flavor_text
  puts "Type: #{pokemon.primary_type}"
  if pokemon.secondary_type
   puts "Secondary Type: #{pokemon.secondary_type}"
  end
  puts "Stats:"
  puts "Speed: #{pokemon.speed}"
  puts "Attack: #{pokemon.attack}"
  puts "Defense: #{pokemon.defense}"
  puts "Special Attack: #{pokemon.special_attack}"
  puts "Special Defense: #{pokemon.special_defense}"

  prompt = "More Options? y/n"
  case get_yes_or_no(prompt)
  when 'y'
    puts "-Give Nickname -Release -other functions "
  end
end

# #

#
#
# def view
#   # shows list of up to 6 pokemon, option to return to main menu
#   # bonus, set limit to 6
#   # Select a pokemon and have options [View info, change name, release, Return(select another pokemon)]
# end
#
# def view_other
#   # input trainer name to view their info/pokemon
#   # bonus- check whose pokemon is stronger
#   # option to return to main menu
# end
#
# def exit
#   # exits program
# end
