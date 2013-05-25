class CreateTaggins < ActiveRecord::Migration
  def change
    create_table :taggins do |t|
      t.integer :post_id
      t.integer :tag_id

      t.timestamps
    end

    add_index :taggins, :post_id
    add_index :taggins, :tag_id
    add_index :taggins, [:post_id, :tag_id], unique: true
  end
end
