# frozen_string_literal: true
class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.text :content
      t.text :request
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
