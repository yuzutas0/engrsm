# frozen_string_literal: true
class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.integer :view_number, default: 0, null: false, index: true
      t.references :user, null: false, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :posts, [:view_number, :user_id], unique: true
  end
end
