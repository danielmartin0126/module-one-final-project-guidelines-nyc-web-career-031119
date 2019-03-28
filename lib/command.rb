require 'audite'
require 'colorize'
require 'table_print'
current_user = nil

def welcome
system 'clear'
start_music('./Music/opening.mp3')

puts "                            .;:**'             MMM"
puts "                             `                  0"
puts "  .:XHHHHk.             db.   .;;.     dH  MX   0"
puts "oMMMMMMMMMMM      ~MM  dMMP :MMMMMR   MMM  MR      ~MRMN"
puts "QMMMMMb  'MMX      MMMMMMP lMX  :M~   MMM MMM  .oo. XMMM 'MMM"
puts "`MMMM.  )M> :XlHk. MMMM    XMM.oP    MMMMMMM X?XMMM MMM> MMP"
puts " 'MMMb.dMl XM M''M MMMMMX.`MMMMMMMM~ MM MMM XM    MX MM XMM"
puts "  ~MMMMM~ XMM. .XM XM`'MMMb.~*?**~ .MMX M Mt MbooMM XMMMMMP"
puts "   ?MMM>  YMMMMMM! MM   `?MMRb.    `'''   lL MMMM XM IMMM"
puts "    MMMX   'MMMM'  MM       ~%:           lMh.'''dMI IMMP"
puts "    'MMM.                                             IMX"
puts "     ~MlM                                             IMP"

puts
puts
puts "                          FLATIRON EDITION"
puts
puts
puts
puts
puts "                         Press ENTER to begin"
gets.chomp
system "clear"
puts "@==================================@"
puts "Hi, select on option:\n -Log In\n -New Trainer\n -Exit"
puts "@==================================@"

  input = gets.chomp
  if input.downcase == "log in"
    puts "Enter your username:"
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
  system "clear"
  puts "@==================================@"
  puts "Enter your username:"
  puts "@==================================@"
  user_name = gets.chomp.upcase
  if Trainer.exists? name: user_name
    current_user = Trainer.where name: user_name
    main_menu(current_user[0])
  else
    wrong_log_in
  end
end

def wrong_log_in
  system 'clear'
  puts "@==================================@"
  puts "That username does not exist. Would"
  puts "you like to try again or create new account?"
  puts "Enter your username or New Account"
  puts "@==================================@"
  response = gets.chomp
  if Trainer.exists? name: response.upcase
    current_user = Trainer.where name: response
    main_menu(current_user)
  elsif response.downcase == "new account"
    new_trainer
  else
    wrong_log_in
  end
end

def enter
  puts "Press ENTER to continue"
  gets.chomp
end

def new_trainer
  system "clear"

  puts "@==============================================================================@"
  puts "  Oak : Hello there! Welcome to the world of POKEMON! My name is OAK!\n  People call me the POKEMON PROF! This world is inhabited by creatures \n  called POKEMON! For some people, POKEMON are pets. Others use them for \n  fights. Myself...I study POKEMON as a profession. First, what is your name?"
  puts "@==============================================================================@"

  name = gets.chomp.upcase
  current_user = Trainer.find_or_create_by(name: name)
  puts "@==============================================================================@"
  puts "  Oak : Right! So your name is #{name}! This is my grandson. He's been your rival \n  since you were a baby. ...Erm, what is his name again?"
  puts "@==============================================================================@"

  rival_name = gets.chomp
  while Trainer.exists? name: rival_name
    puts "@==============================================================================@"
    puts "Oh no that's not #{rival_name}, he's my other grandson! What is this ones name?"
    puts "@==============================================================================@"
    rival_name = gets.chomp
  end
  
  rival_user = Trainer.find_or_create_by(name: rival_name)
  add_six(rival_user)

  puts "@==============================================================================@"
  puts "  Oak : That's right! I remember now! His name is #{rival_name}! #{name}! Your very own \n POKEMON legend is about to unfold! A world of dreams and adventures with \n POKEMON awaits! Let's go!"
  puts "@==============================================================================@"
  enter
  main_menu(current_user)
end

def main_menu(current_user)
  system "clear"
  puts "@==============================================================@"
  puts " Hi #{current_user.name}! Select an option:\n "
 puts " -Catch Pokemon\n -View Pokemon\n -Trainer Lookup\n -Settings\n -Exit"
 puts "@==============================================================@"

 case gets.chomp.downcase
 when "catch pokemon"
   encounter(current_user)
 when "view pokemon"
   view_team(current_user)
 when "trainer lookup"
   system "clear"
   rival_exists?(current_user)
 when "settings"
   settings(current_user)
 when "exit"
   puts "Thanks for Playing"
   exit
 else
   puts "Input valid commannd!"
   enter
   main_menu(current_user)
 end
end


def encounter(current_user)
  if current_user.pokemons.length >= 6
    puts "@==============================================================@"
    puts " You already have six Pokemon. You must release one in order to catch another Pokemon."
    puts "@==============================================================@"
    enter
    new_song('./Music/opening.mp3')
    main_menu(current_user)
  end
  walking
  new_song('./Music/battle.mp3')
  encounter_animation()
  pokemon = Pokemon.order("RANDOM()").first
  puts "A wild #{pokemon.name.upcase} appeared!"
  puts pokemon.name.upcase
  puts "L: #{pokemon.level}"
  puts "HP: #{pokemon.hp}/#{pokemon.hp}"
  puts ""
  catch_or_run(current_user, pokemon)
end

def catch_or_run(current_user, pokemon)
  puts "@==================================@"
  puts "Type an option:"
  puts "@==================================@"
  # For Catch => can succeed or fail, success adds to pokemon list
  input = gets.chomp
  if input.downcase == "catch"
    new_song('./Music/victory.mp3')
    CapturedPokemon.find_or_create_by(trainer_id: current_user.id, pokemon_id: pokemon.id)
    puts "You captured #{pokemon.name.upcase}!"
    display_pokemon(pokemon,current_user)
    another_pokemon?(current_user)
  elsif input.downcase == "run"
    new_song('./Music/flee.mp3')
    run_animation
    puts ""
    another_pokemon?(current_user)
  else
    puts "Input valid command"
    catch_or_run(current_user, pokemon)
  end
end

def another_pokemon?(current_user)
  if (CapturedPokemon.where trainer_id: current_user.id).length >= 6
    puts "You already have six Pokemon. You must release one in order to catch another Pokemon."
    new_song('./Music/opening.mp3')
    main_menu(current_user)
  else
    prompt = "Would you like to look for another Pokemon? y/n"
    case get_yes_or_no(prompt)
    when "y"
      encounter(current_user)
    when "n"
      new_song('./Music/opening.mp3')
      main_menu(current_user)
    end
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

def display_pokemon_without_options(pokemon, user)
  system "clear"
  puts "@==================================@"
  puts "  #{pokemon.name.upcase}"
  puts "  L: #{pokemon.level}"
  puts "  HP: #{pokemon.hp}"
  puts "  #{pokemon.genus}"
  puts "  Type: #{pokemon.primary_type}"
  if pokemon.secondary_type
   puts "  Secondary Type: #{pokemon.secondary_type}"
  end
  puts "  Stats:"
  puts "  Speed: #{pokemon.speed}"
  puts "  Attack: #{pokemon.attack}"
  puts "  Defense: #{pokemon.defense}"
  puts "  Special Attack: #{pokemon.special_attack}"
  puts "  Special Defense: #{pokemon.special_defense}"
  puts "@==================================@\n "
  puts "#{pokemon.flavor_text}\n "
  enter
end

def display_pokemon(pokemon, user)
  display_pokemon_without_options(pokemon, user)
  prompt = "More Options? y/n"
  case get_yes_or_no(prompt)
  when 'y'
    pokemon_options(pokemon,user)
  end
end

def pokemon_options(pokemon, user)
  puts "@==================================@"
  puts " -Release Pokemon\n -View Team\n -Main Menu"
  puts "@==================================@"

  case gets.chomp.downcase
  when "release pokemon"
    doomed = CapturedPokemon.find_by(pokemon_id: pokemon.id, trainer_id: user.id)
    CapturedPokemon.destroy(doomed.id)
    view_team(user)
  when "change name"
  when "view team"
    view_team(user)
  when "main menu"
    main_menu(user)
  else
    puts "Invalid command"
    pokemon_options(pokemon, user)
  end

end

def view_team(current_user)

  if (CapturedPokemon.where trainer_id: current_user.id).length == 0
    puts "You have no pokemon! Returning to main menu"
    enter
    main_menu(current_user)
  else
    system "clear"
    puts "@==================================@"
    puts "#{current_user.name}'s team\n \n"
    puts "--------------"

    current_user.reload.pokemons.each do |pokemon|
      puts pokemon.name.upcase
      puts "--------------"
    end
    puts "@==================================@"

    puts "\nSELECT A POKEMON OR RETURN TO MAIN MENU"
    input = gets.chomp.downcase
    if input == "main menu" || input == "return"
      new_song('./Music/opening.mp3')
      main_menu(current_user)
    elsif current_user.pokemons.find_by(name: input)
      view = current_user.pokemons.find_by(name: input)
      display_pokemon(view, current_user)
      view_team(current_user)
    else
      puts "Invalid command"
      view_team(current_user)
    end
  end
end

def rival_exists?
  system "clear"
  puts "@==================================@"
  puts " Enter a rival Trainer's name:"
  puts "@==================================@"
  answer = gets.chomp.upcase
  @rival_user = Trainer.find_by(name: answer)
  if answer == 'BACK' || answer.include?('menu')
    main menu(current_user)
  elsif !@rival_user
    system "clear"
    puts "@==================================@"
    puts "#{answer} does not exist"
    puts "@==================================@"
    enter
    rival_exists?(current_user)
  elsif (CapturedPokemon.where trainer_id: @rival_user.id).length == 0
    puts "This trainer has no pokemon!"
    enter
    rival_exists?(current_user)
  end
  view = user.pokemons.find_by(name: input.downcase)
  display_pokemon(view, user)
end

def view__rival_team(user)
  system "clear"
  puts "@==================================@"
  puts "#{rival_user.name}'s team\n \n"
  puts "--------------"

  user.reload.pokemons.each do |pokemon|
    puts pokemon.name.upcase
    puts "--------------"
  end
  puts "@==================================@"

  puts "\nSELECT A POKEMON OR RETURN TO MAIN MENU"
  input = gets.chomp.downcase
  if input == "main menu" || input == "return"
    new_song('./Music/opening.mp3')
    @rival_user = nil
    main_menu(user)
  elsif user.pokemons.find_by(name: input.downcase)
    display_pokemon_without_options(user.pokemons.find_by(name: input.downcase), user)
    view__rival_team(user)
  else
    "Invalid command"
    view__rival_team(user)
  end
end

def settings(current_user)
  system "clear"
  puts "@==================================@"

  puts "Select an option:\n "
  puts "Change Trainer name"
  puts "Back"
  puts "@==================================@"

  input = gets.chomp.downcase
  if input.include?("change")
    system "clear"
    puts "Enter your new name:"
    current_user.name = gets.chomp.upcase
    current_user.save
    main_menu(current_user)
  elsif input.include?('back')
    main_menu(current_user)
  else
    puts "Invalid command"
    settings(current_user)
  end
end

def start_music(file)
  @player = Audite.new
  @player.load(file)
  @player.start_stream
end

def new_song(file)
  @player.load(file)
  @player.start_stream
end

def walking
  system "clear"
  puts "@======================@"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|  웃                  |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/2.0)
  system "clear"
  puts "@======================@"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|     웃               |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/2.0)
  system "clear"
  puts "@======================@"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|         웃           |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/2.0)
  system "clear"
  puts "@======================@"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|              웃      |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/2.0)
  system "clear"
  puts "@======================@"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/2.0)
end

def encounter_animation
  sleep(1)
  system "clear"
  puts "@======================@"
  puts "|@@                    |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@                  |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@                |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@              |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@            |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@          |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@        |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@    |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@  |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@                    |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@                  |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@                  |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@              |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@            |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@          |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@        |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@    |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@  |"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|                      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@                    |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@                  |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@                |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@              |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@            |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@          |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@        |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@      |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@    |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@  |"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|                      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@                    |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@                  |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@                |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@              |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@            |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@          |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@        |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@      |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@    |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@  |"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|                   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@                 웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@               웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@             웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@           웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@         웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@       웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@     웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@   웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@ 웃 |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@  |"
  puts "|//////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@////////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@//////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@////////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@//////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@////////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@//////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@////////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@//////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@//////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@////|"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@//|"
  puts "|@@                    |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@                  |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@                |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@              |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@            |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@          |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@        |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@      |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@    |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@  |"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "@======================@"
  sleep(1.0/40.0)
  system "clear"
  puts "@======================@"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/15.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "@======================@"
  sleep(1.0/15.0)
  system "clear"
  puts "@======================@"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/15.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "@======================@"
  sleep(1.0/15.0)
  system "clear"
  puts "@======================@"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/15.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "@======================@"
  sleep(1.0/15.0)
  system "clear"
  puts "@======================@"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "|                      |"
  puts "@======================@"
  sleep(1.0/15.0)
  system "clear"
  puts "@======================@"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "|@@@@@@@@@@@@@@@@@@@@@@|"
  puts "@======================@"
  sleep(1.0/15.0)
  system "clear"
  puts "@======================@"
  puts "| :L 50                |"
  puts "| hp:______   (/◕ヮ◕)/ |"
  puts "|                      |"
  puts "|    웃                |"
  puts "|@====================@|"
  puts "|| Catch     Run      ||"
  puts "|@====================@|"
  puts "@======================@"
  sleep(1.0/15.0)
end

def run_animation
  system "clear"
  puts "@======================@"
  puts "| :L 50                |"
  puts "| hp:______   (/◕ヮ◕)/ |"
  puts "|                      |"
  puts "|    웃                |"
  puts "|@====================@|"
  puts "|| Got away safetly!  ||"
  puts "|@====================@|"
  puts "@======================@"
  sleep(1.0/15.0)
end

def add_six(user)
  6.times do
  CapturedPokemon.find_or_create_by(trainer_id: user.id, pokemon_id: (Pokemon.order("RANDOM()").first.id))
  end
end
