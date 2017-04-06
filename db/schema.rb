# encoding: UTF-8
# frozen_string_literal: true
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_170_205_080_455) do
  create_table 'comments', force: :cascade do |t|
    t.text     'content',    limit: 65_535
    t.integer  'post_id',    limit: 4
    t.integer  'user_id',    limit: 4,     null: false
    t.datetime 'created_at',               null: false
    t.datetime 'updated_at',               null: false
  end

  add_index 'comments', ['post_id'], name: 'index_comments_on_post_id', using: :btree
  add_index 'comments', ['user_id'], name: 'index_comments_on_user_id', using: :btree

  create_table 'post_tag_relationships', force: :cascade do |t|
    t.integer 'post_id', limit: 4, null: false
    t.integer 'tag_id',  limit: 4, null: false
  end

  add_index 'post_tag_relationships', %w(post_id tag_id), name: 'index_post_tag_relationships_on_post_id_and_tag_id', unique: true, using: :btree
  add_index 'post_tag_relationships', ['post_id'], name: 'index_post_tag_relationships_on_post_id', using: :btree
  add_index 'post_tag_relationships', ['tag_id'], name: 'index_post_tag_relationships_on_tag_id', using: :btree

  create_table 'posts', force: :cascade do |t|
    t.string   'title',      limit: 255,   null: false
    t.text     'content',    limit: 65_535, null: false
    t.integer  'user_id',    limit: 4,     null: false
    t.datetime 'created_at',               null: false
    t.datetime 'updated_at',               null: false
  end

  add_index 'posts', ['user_id'], name: 'index_posts_on_user_id', using: :btree

  create_table 'search_conditions', force: :cascade do |t|
    t.string   'name',         limit: 255
    t.text     'query_string', limit: 65_535, null: false
    t.boolean  'save_flag', default: false, null: false
    t.integer  'user_id', limit: 4, null: false
    t.datetime 'created_at',                                 null: false
    t.datetime 'updated_at',                                 null: false
  end

  add_index 'search_conditions', ['user_id'], name: 'index_search_conditions_on_user_id', using: :btree

  create_table 'tags', force: :cascade do |t|
    t.string   'name', limit: 255
    t.datetime 'created_at',             null: false
    t.datetime 'updated_at',             null: false
  end

  create_table 'users', force: :cascade do |t|
    t.string   'email',                  limit: 255, default: '', null: false
    t.string   'encrypted_password',     limit: 255, default: '', null: false
    t.string   'reset_password_token',   limit: 255
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer  'sign_in_count', limit: 4, default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string   'current_sign_in_ip',     limit: 255
    t.string   'last_sign_in_ip',        limit: 255
    t.datetime 'created_at',                                      null: false
    t.datetime 'updated_at',                                      null: false
    t.string   'name',                   limit: 255, default: '', null: false
    t.string   'timezone',               limit: 255,              null: false
    t.string   'confirmation_token',     limit: 255
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string   'unconfirmed_email', limit: 255
  end

  add_index 'users', ['confirmation_token'], name: 'index_users_on_confirmation_token', unique: true, using: :btree
  add_index 'users', ['email'], name: 'index_users_on_email', unique: true, using: :btree
  add_index 'users', ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true, using: :btree

  add_foreign_key 'comments', 'posts'
  add_foreign_key 'comments', 'users'
  add_foreign_key 'post_tag_relationships', 'posts'
  add_foreign_key 'post_tag_relationships', 'tags'
  add_foreign_key 'posts', 'users'
  add_foreign_key 'search_conditions', 'users'
end
