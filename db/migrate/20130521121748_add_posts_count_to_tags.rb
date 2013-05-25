class AddPostsCountToTags < ActiveRecord::Migration
  def change
    add_column :tags, :posts_count, :integer, default: 0

    Tag.reset_column_information
    Tag.all.each do |tag|
      tag.update_attributes(posts_count: tag.posts.length)
    end
  end
end
