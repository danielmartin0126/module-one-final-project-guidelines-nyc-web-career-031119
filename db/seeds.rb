
danny = Trainer.find_or_create_by(name: "Danny", favourite_pokemon: "Blastoise")
john = Trainer.find_or_create_by(name: "John", favourite_pokemon: "Jigglypuff")

dannyblastoise = CapturedPokemon.find_or_create_by(trainer_id: 3, pokemon_id: 1)
dannypikachu = CapturedPokemon.find_or_create_by(trainer_id: 3, pokemon_id: 2)
johnpikachu = CapturedPokemon.find_or_create_by(trainer_id: 4, pokemon_id: 2)



gotta_catch_em_all = (1..151).to_a

gotta_catch_em_all.each do |i|
  pokemon_string1 = RestClient.get("https://pokeapi.co/api/v2/pokemon/#{i}/")
  pokemon_hash1 = JSON.parse(pokemon_string1)
  pokemon_string2 = RestClient.get("https://pokeapi.co/api/v2/pokemon-species/#{i}/")
  pokemon_hash2 = JSON.parse(pokemon_string2)

  name = pokemon_hash1["name"]
  primary_type = pokemon_hash1["types"].find  {|each| each["slot"] == 1}["type"]["name"]
  secondary_type = if pokemon_hash1["types"].length > 1
    pokemon_hash1["types"].find  {|each| each["slot"] == 2}["type"]["name"]
  end

  stat_hp = pokemon_hash1["stats"].find {|each| each["stat"]["name"] == "hp"}["base_stat"]
  stat_speed = pokemon_hash1["stats"].find {|each| each["stat"]["name"] == "speed"}["base_stat"]
  stat_attack = pokemon_hash1["stats"].find {|each| each["stat"]["name"] == "attack"}["base_stat"]
  stat_special_attack = pokemon_hash1["stats"].find {|each| each["stat"]["name"] == "special-attack"}["base_stat"]
  stat_defense = pokemon_hash1["stats"].find {|each| each["stat"]["name"] == "defense"}["base_stat"]
  stat_special_defense = pokemon_hash1["stats"].find {|each| each["stat"]["name"] == "special-defense"}["base_stat"]

  capture_rate = pokemon_hash2["capture_rate"]

  genus = pokemon_hash2["genera"].find {|each| each["language"]['name'] == "en"}["genus"]
  flavor_text = pokemon_hash2["flavor_text_entries"].select {|each| each["language"]['name'] == "en"}.sample["flavor_text"]
  # binding.pry

  Pokemon.find_or_create_by(name: name,
  genus: genus,
  primary_type: primary_type,
  secondary_type: secondary_type,
  flavor_text: flavor_text,
  level: 50,
  speed: stat_speed,
  special_attack: stat_special_attack,
  special_defense: stat_special_defense,
  attack: stat_attack,
  defense: stat_defense,
  hp: stat_hp,
  capture_rate: capture_rate)
end
