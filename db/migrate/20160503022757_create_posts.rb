# frozen_string_literal: true
class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.references :user, null: false, index: { unique: true }, foreign_key: true

      t.timestamps null: false
    end
  end
end
