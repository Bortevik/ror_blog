require 'spec_helper'

describe Comment do

  before { @comment = build(:comment) }

  subject { @comment }

  it { should respond_to(:body) }
  it { should respond_to(:post) }
  it { should respond_to(:user) }
  it { should respond_to(:post_id) }
  it { should respond_to(:user_id) }
  it { should respond_to(:deleted?) }

  it { should be_valid }

  it 'body should be present' do
    @comment.body = ' '
    should_not be_valid
  end

  it 'after create a comment increment comments count in post model' do
    post = create(:post)
    expect do
      post.comments.create(body: 'foo')
    end.to change{ post.reload.comments_count }.by(1)
  end

  it 'after destroy a comment decrement comments count in post model' do
    post = create(:post)
    comment = post.comments.create(body: 'foo')
    expect do
      comment.destroy
    end.to change{ post.reload.comments_count }.by(-1)
  end

  it 'should have right order' do
    newer_comment = create(:comment, created_at: 1.hour.ago)
    older_comment = create(:comment, created_at: 1.day.ago)
    Comment.all.should == [older_comment, newer_comment]
  end
end
