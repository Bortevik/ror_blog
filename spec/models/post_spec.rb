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

require 'spec_helper'

describe Post do

  before { @post = Post.new(title:   'Post one',
                            content: 'Lorem ipsum') }

  subject { @post }

  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:comments) }
  it { should respond_to(:comments_count) }

  it { should be_valid }

  describe 'when title is not present' do
    before { @post.title = ' ' }
    it { should_not be_valid }
  end

  describe 'with blank content' do
    before { @post.content = ' ' }
    it { should_not be_valid }
  end

  describe 'when title that is too long' do
    before { @post.title = 'a' * 101 }
    it { should_not be_valid }
  end

  describe 'with right order' do
    let!(:older_post) { FactoryGirl.create(:post, created_at: 1.day.ago) }
    let!(:newer_post) { FactoryGirl.create(:post, created_at: 1.hour.ago) }

    specify { Post.all.should == [newer_post, older_post] }
  end
end
