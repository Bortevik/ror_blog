require 'spec_helper'

describe Taggin do
  let(:post) { create(:post) }
  let(:tag)  { create(:tag) }
  before { @taggin = post.taggins.build(tag_id: tag.id) }

  subject { @taggin }

  it { should respond_to(:post) }
  it { should respond_to(:tag) }

  its(:post) { should eq post }
  its(:tag)  { should eq tag }

  it { should be_valid }

  it 'should not allow access to post_id' do
    expect do
      Taggin.new(post_id: post.id)
    end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end

  it 'post_id should be present' do
    @taggin.post_id = nil
    should_not be_valid
  end

  it 'tag_id should be present' do
    @taggin.tag_id = nil
    should_not be_valid
  end
end
