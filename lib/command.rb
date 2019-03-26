current_user = nil
rival_user = ""
def welcome
 # if trainer database is empty, run new_trainer automatically
 puts "Hi, select on option: -Log In -New Trainer"
 input = gets.chomp
 if input.downcase == "log in"
   check_log_in
 elsif input.downcase == "new trainer"
   new_trainer
 else
   puts "Input valid command"
   welcome
 end
end

def new_trainer
  puts "Oak : Hello there! Welcome to the world of POKEMON! My name is OAK! People call me the POKEMON PROF! This world is inhabited by creatures called POKEMON! For some people, POKEMON are pets. Others use them for fights. Myself...I study POKEMON as a profession. First, what is your name?"
  name = gets.chomp
  binding.pry
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
  # create new pokemon instance from api
  pokemon = Pokemon.order("RANDOM()").first
  puts "You have encountered a wild #{pokemon.name.upcase}!"
  # present pokemon with HP
  puts pokemon.name.upcase
  puts "L: #{pokemon.level}"
  puts "HP: #{pokemon.hp}/#{pokemon.hp}"
  # gives option to Catch or Run

  puts "Select an option:"
  puts "1. Catch"
  puts "2. Run"
  input = gets.chomp
  # For Catch => can succeed or fail, success adds to pokemon list
  if input == 1 || "Catch"
    CapturedPokemon.find_or_create_by(trainer_id: current_user.id, pokemon_id: pokemon.id)
    display_pokemon(pokemon)

  elsif input == 2 || "Run"
    puts "You got away safely."
    puts "Would you like to look for another Pokemon? y/n"
    answer = gets.chomp
    if answer == "y"
      encounter
    else
      main_menu(current_user)
    end
  end
  main_menu(current_user)
  # bonus- don't allow encounter if you have 6 pokemon
end
#
def display_pokemon(pokemon)
  puts "You captured #{pokemon.name.upcase}!"
  puts pokemon.level
  puts pokemon.hp
  puts pokemon.genus
  puts pokemon.flavor_text
  puts "Type: #{pokemon.primary_type}"
  if pokemon.secondary_type
   puts "Secondary Type: #{pokemon.secondary_type}"
  end
  puts "Stats:"
  puts pokemon.speed
  puts pokemon.attack
  puts pokemon.defense
  puts pokemon.special_attack
  puts pokemon.special_defense
  # if successful displays stats, congrats,  adds to pokemon list
  # give nickname
  # if fails, says too bad, gives option to look for another or go home
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
