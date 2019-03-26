class AddPokeId < ActiveRecord::Migration[5.0]
  def change
    add_column :pokemons, :pokeid, :integer
  end
end
