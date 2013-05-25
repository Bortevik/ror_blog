# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ActiveRecord::Base
  attr_accessible :content, :title, :tag_names

  has_many :comments, dependent: :destroy
  has_many :taggins, dependent: :destroy
  has_many :tags, through: :taggins

  attr_writer :tag_names

  default_scope order: 'created_at DESC'

  before_save :save_tag_names

  validates :title, :content, presence: true
  validates :title, length: { maximum: 100 }

  def tag_names
    @tag_names || tags.pluck(:name).join(', ')
  end

  def save_tag_names
    if @tag_names
      old_tags = self.tags.dup
      self.tags = @tag_names.split(', ').map do |name|
        tag = Tag.where(name: name).first_or_initialize
        tag.update_posts_count(1) unless old_tags.include? tag
        tag
      end
      old_tags.each do |old_tag|
        old_tag.update_posts_count(-1) unless self.tags.include? old_tag
      end
    end
  end
end
