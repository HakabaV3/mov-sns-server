class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.references :group, index: true
      t.references :user, index: true
      t.string :name
      t.text :description
      t.string :path

      t.timestamps
    end
  end
end
