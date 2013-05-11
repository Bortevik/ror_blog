require 'spec_helper'

describe 'Comments' do

  subject { page }

  describe 'creation' do
    before do
      post = create(:post)
      visit post_path(post)
    end

    it 'with data create comment' do
      fill_in 'comment_body', with: 'Some comment'
      expect do
        click_button 'Add comment'
      end.to change(Comment, :count).by(1)
    end

    it 'with no data do not create comment' do
      fill_in 'comment_body', with: ' '
      expect do
        click_button 'Add comment'
      end.to_not change(Comment, :count)
    end
  end

  describe 'deletion' do

    it 'should delete comment with permission' do
      post = create(:post)
      comment = create(:comment, body: 'comment',  post_id: post.id)
      sign_in create(:admin)
      visit post_path(post)
      expect do
        find('div.comment a[@data-method="delete"]').click
      end.to change{ comment.reload.body }.from('comment').to('#deleted#')
    end
  end
end
