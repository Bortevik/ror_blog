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
  it { should respond_to(:taggins) }
  it { should respond_to(:tags) }

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

  it 'should have right order' do
    older_post = create(:post, created_at: 1.day.ago)
    newer_post = create(:post, created_at: 1.hour.ago)
    Post.all.should == [newer_post, older_post]
  end

  describe 'when save' do

    it 'assign new tags' do
      @post.tag_names = 'foo'
      @post.save_tag_names
      @post.tags[0].name.should eq 'foo'
    end

    it 'with assigned tags increment posts count of tag' do
      tag = create(:tag)
      @post.tag_names = tag.name
      expect do
        @post.save_tag_names
      end.to change { tag.reload.posts_count }.by(1)
    end

    it 'with unassigned tags decrement posts count of tag' do
      tag = create(:tag, posts_count: 2)
      @post.tags << tag
      @post.tag_names = 'another tag'
      expect do
        @post.save_tag_names
      end.to change { tag.reload.posts_count }.by(-1)
    end
  end
end
