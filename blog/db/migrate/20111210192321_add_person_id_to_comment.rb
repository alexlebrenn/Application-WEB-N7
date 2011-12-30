class AddPersonIdToComment < ActiveRecord::Migration
  def change
			# ajouter une colonne à la table comments de nom person_id et de type integer
			add_column :comments, :person_id, :integer
  end
end
