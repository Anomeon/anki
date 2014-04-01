class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :first_side
      t.string :second_side
      t.integer :rating, {:default => 0}
      t.references :user, index: true, null: false
      t.timestamps
    end
  end
end
