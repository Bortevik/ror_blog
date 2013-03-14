class Post < ActiveRecord::Base
  attr_accessible :content, :title

  default_scope order: 'created_at DESC'

  validates :title, :content, presence: true
  validates :title, length: { maximum: 100 }
end
