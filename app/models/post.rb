class Post < ActiveRecord::Base
  attr_accessible :content, :title

  validates :title, :content, presence: true
  validates :title, length: { maximum: 100 }
end
