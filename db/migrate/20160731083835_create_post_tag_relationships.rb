# frozen_string_literal: true
class CreatePostTagRelationships < ActiveRecord::Migration
  def change
    create_table :post_tag_relationships do |t|
      t.references :post, index: true, foreign_key: true, null: false
      t.references :tag, index: true, foreign_key: true, null: false
    end

    add_index :post_tag_relationships, [:post_id, :tag_id], unique: true
  end
end
