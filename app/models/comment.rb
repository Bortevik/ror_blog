class Comment < ActiveRecord::Base
  attr_accessible :body, :post_id

  belongs_to :user
  belongs_to :post

  validates :body, presence: true

  after_create :increment_comments_count_in_post
  after_destroy :decrement_comments_count_in_post

  def deleted?
    body == '#deleted#'
  end

  private

    def increment_comments_count_in_post
      post.comments_count += 1
      post.save!
    end

    def decrement_comments_count_in_post
      post.comments_count -= 1
      post.save!
    end
end
