class Comment < ActiveRecord::Base
  attr_accessible :body, :post_id, :captcha, :captcha_key

  belongs_to :user
  belongs_to :post

  default_scope order: 'created_at ASC'

  validates :body, presence: true

  apply_simple_captcha :message => "The secret Image and code were different",
                       :add_to_base => true

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
