# frozen_string_literal: true
# backup_service
class BackupService
  # -----------------------------------------------------------------
  # Library
  # -----------------------------------------------------------------
  require 'zip'

  # -----------------------------------------------------------------
  # Const
  # -----------------------------------------------------------------
  DIR_NAME_PREFIX = Constants::PRODUCT_NAME_FOR_TITLE.downcase.freeze
  ZIP_FILE_NAME_SUFFIX = '.zip'
  TEXT_FILE_SUFFIX = '.txt'
  CONTENT_SEPARATOR = ('-' * 64).freeze

  # -----------------------------------------------------------------
  # Facade
  # -----------------------------------------------------------------
  def self.create(user)
    file_name, temp_file, posts = ready(user)
    begin
      zip_data = make_zip_file(temp_file, posts, user)
    ensure
      file_delete(temp_file)
    end
    [file_name, zip_data]
  end

  # -----------------------------------------------------------------
  # Support
  # -----------------------------------------------------------------
  class << self
    private

    def ready(user)
      filename = dir_name(user) + ZIP_FILE_NAME_SUFFIX
      temp_file = Tempfile.new(filename)
      posts = PostRepository.all(user.id)
      [filename, temp_file, posts]
    end

    def dir_name(user)
      DIR_NAME_PREFIX + '_' + local_time_shorten(Time.now, user)
    end

    def make_zip_file(temp_file, posts, user)
      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
        zip.mkdir(dir_name(user))
        posts.each do |post|
          file_name = post_file_name(post, user)
          zip.get_output_stream(file_name) { |s| post_file_content(s, post, user) }
        end
      end
      File.read(temp_file.path)
    end

    def post_file_name(post, user)
      dir_name(user) + File::SEPARATOR + post.id.to_s + TEXT_FILE_SUFFIX
    end

    def post_file_content(s, post, user)
      [
        CONTENT_SEPARATOR, '[title] ' + post.title, CONTENT_SEPARATOR,
        '[tag] ' + post.tags.map(&:name).join(','),
        CONTENT_SEPARATOR,
        '[created at] ' + local_time(post.created_at, user),
        '[updated at] ' + local_time(post.updated_at, user),
        CONTENT_SEPARATOR, '[content]', CONTENT_SEPARATOR, post.content
      ].concat(comment_file_content(post.comments, user)).each { |i| s.puts(i) }
    end

    def comment_file_content(comments, user)
      array = [CONTENT_SEPARATOR, '[comment]', CONTENT_SEPARATOR]
      comments.each do |comment|
        array << [
          '[id] ' + comment.id.to_s,
          '[user id] ' + comment.user.id.to_s,
          '[user name] ' + comment.user.name,
          '[created at] ' + local_time(comment.created_at, user),
          '[updated at] ' + local_time(comment.updated_at, user),
          CONTENT_SEPARATOR, comment.content, CONTENT_SEPARATOR
        ]
      end
      comments.present? ? array : array.concat([CONTENT_SEPARATOR])
    end

    def local_time_shorten(time, user)
      time.in_time_zone(user_timezone(user)).strftime('%Y%m%d%H%M')
    end

    # refs. ApplicationHelper#local_time
    def local_time(time, user)
      time.in_time_zone(user_timezone(user)).strftime('%Y-%m-%d %H:%M')
    end

    # refs. ApplicationHelper#user_timezone
    def user_timezone(user)
      tz = user.timezone
      tz = right_timezone?(tz) ? tz : 'Etc/GMT'
      TZInfo::Timezone.get(tz).identifier
    end

    # refs. ApplicationHelper#right_timezone?
    def right_timezone?(timezone)
      TZInfo::Timezone.all_identifiers.include?(timezone)
    end

    def file_delete(temp_file)
      temp_file.close
      temp_file.unlink
    end
  end
end
