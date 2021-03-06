# frozen_string_literal: true
# lib/tasks/elasticsearch.rake
namespace :elasticsearch do
  desc 'Create index for Elasticsearch'
  task create_index: :environment do
    Post.create_index
  end

  desc 'Import to Elasticsearch'
  task import: :environment do
    Post.import_index
  end
end
