def welcome
  # if trainer database is empty, run new_trainer automatically
  puts "Hi, select on option: -Log In -New Trainer"
  input = gets.chomp
  if input.downcase == "log in"
    puts ""
  elsif input.downcase == "new trainer"
    new_trainer
  else
    puts "Input valid command"
  end
end

def new_trainer
  puts "Oak : Hello there! Welcome to the world of POKEMON! My name is OAK! People call me the POKEMON PROF! This world is inhabited by creatures called POKEMON! For some people, POKEMON are pets. Others use them for fights. Myself...I study POKEMON as a profession. First, what is your name?"
  name = gets.chomp
  Trainer.find_or_create_by(name: name)
  puts "Oak : Right! So your name is #{name}! This is my grandson. He's been your rival since you were a baby. ...Erm, what is his name again?"
  rival_name = gets.chomp
  Trainer.find_or_create_by(name: rival_name)
  puts "Oak : That's right! I remember now! His name is #{rival_name}! #{name}! Your very own POKEMON legend is about to unfold! A world of dreams and adventures with POKEMON awaits! Let's go!"
end
#
# def main_menu
# end
#
# def encounter
#   # create new pokemon instance from api
#   # bonus- don't allow encounter if you have 6 pokemon
#   # present pokemon with HP
#   # gives option to Catch or Run
#   # For Catch => can succeed or fail, success adds to pokemon list
#   # Run => can look for another pokemon or go home
#   # going home returns to main menu
# end
#
# def catch
#   # if successful displays stats, congrats,  adds to pokemon list
#   # give nickname
#   # if fails, says too bad, gives option to look for another or go home
# end
#
# def main_menu
#   # makes sure we don't break or exit program unintentionally and always ends up at menu
# end
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
