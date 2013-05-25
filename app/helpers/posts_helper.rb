module PostsHelper
  def tag_links(tags)
   tags.map { |tag| link_to tag.name, tag_path(tag) }
  end
end
