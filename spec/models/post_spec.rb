require 'spec_helper'

describe Post do

  before { @post = Post.new(title:   'Post one',
                            content: 'Lorem ipsum') }

  subject { @post }

  it { should respond_to(:title) }
  it { should respond_to(:content) }

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
end
