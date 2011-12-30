class AddPersonIdToPost < ActiveRecord::Migration
  def change
			# ajouter une colonne à la table posts de nom person_id et de type integer
			add_column :posts, :person_id, :integer
  end
end
