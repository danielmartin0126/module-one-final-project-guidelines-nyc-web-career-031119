class Pokemon < ActiveRecord::Base
  has_many :captured_pokemons
  has_many :trainers, through: :captured_pokemons
end
