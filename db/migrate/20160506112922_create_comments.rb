# frozen_string_literal: true
class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :view_number, default: 0, null: false, index: true
      t.references :tale, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :comments, [:view_number, :tale_id], unique: true
  end
end
