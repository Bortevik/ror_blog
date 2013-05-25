require 'spec_helper'

describe Tag do
  before { @tag = build(:tag) }

  subject { @tag }

  it { should respond_to(:name) }
  it { should respond_to(:taggins) }
  it { should respond_to(:posts) }

  it { should be_valid }

  it 'name should be present' do
    @tag.name = nil
    should_not be_valid
  end

  it 'is invalid when name already is taken' do
    tag_with_same_name = create(:tag, name: @tag.name)
    tag_with_same_name.name.upcase!
    tag_with_same_name.save
    should_not be_valid
  end

  describe 'when update posts count' do
    it 'should change count' do
      @tag.posts_count = 2
      @tag.save
      expect do
        @tag.update_posts_count -1
      end.to change { @tag.reload.posts_count }.by(-1)
    end

    it 'delete tag if count become equal 0' do
      @tag.posts_count = 1
      @tag.save
      @tag.update_posts_count -1
      expect do
        Tag.find(@tag.id)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
