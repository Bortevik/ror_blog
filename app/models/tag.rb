class Tag < ActiveRecord::Base
  attr_accessible :name, :posts_count

  has_many :taggins, dependent: :destroy
  has_many :posts, through: :taggins

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def update_posts_count(i)
    self.posts_count += i
    if posts_count == 0
      delete
    else
      save
    end
  end
end
