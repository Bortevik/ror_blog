require 'spec_helper'

describe 'Post pages' do

  subject { page }

  let(:admin) { create(:admin) }

  shared_examples_for 'save post with invalid information' do

    it 'should not save a post' do
      expect {click_button submit }.not_to change(Post, :count)
    end

    describe 'after submitting' do
      before { click_button submit }

      it { should have_content('error') }
      it { should have_content("Title can't be blank") }
      it { should have_content("Content can't be blank") }

      describe 'when title that is too long' do
        before do
          fill_in 'Title', with: 'a' * 101
          click_button submit
        end

        it { should have_content('Title is too long (maximum is 100 characters)')}
      end
    end
  end

  shared_examples_for 'save post with valid information' do

    describe 'after saving post' do
      before { click_button submit }
      let(:saved_post) { Post.order('updated_at DESC').first }

      it { current_path.should == "/posts/#{saved_post.id}" }
      it { should have_success_message(success_message) }
    end
  end

  describe 'post creation' do
    let(:submit) { 'Create post' }
    before do
      sign_in admin
      visit new_post_path
    end

    describe 'page' do

      it { should have_headline('Create new post') }
      it { should have_title('New post creation')}

      describe 'without permissions' do
        before do
          signout
          user = create(:user)
          sign_in user
          visit new_post_path
        end

        it { should have_error_message 'Access denied!' }
        it { current_path.should eq root_path }
      end
    end

    describe 'with invalid information' do
      it_should_behave_like 'save post with invalid information'
    end

    describe 'with valid information' do
      let(:success_message) { 'New post created!' }
      before do
        fill_in 'Title',   with: 'Post one'
        fill_in 'Content', with: 'Lorem ipsum'
      end

      it 'should create a post' do
        expect { click_button submit }.to change(Post, :count).by(1)
      end
      it_should_behave_like 'save post with valid information'
    end
  end

  describe 'post edition' do
    let(:submit) { 'Update post' }
    let(:post) { create(:post)}
    before do
      sign_in admin
      visit edit_post_path(post)
    end

    describe 'edit page' do
      it { should have_headline('Edit post') }
      it { should have_title('Edit post') }
      it { find_field('Title').value.should eq(post.title) }
      it { find_field('Content').value.should eq(post.content) }

      describe 'without permission' do
        before do
          signout
          user = create(:user)
          sign_in user
          visit edit_post_path(post)
        end

        it 'should redirect to home page' do
          current_path.should eq root_path
        end
      end
    end

    describe 'with invalid information' do
      before do
        fill_in 'Title',   with: ''
        fill_in 'Content', with: ''
      end

      it_should_behave_like 'save post with invalid information'
    end

    describe 'with valid information' do
      let(:success_message) { 'Post updated!' }
      before do
        fill_in 'Title',   with: 'Post one'
        fill_in 'Content', with: 'Lorem ipsum'
      end

      it 'should not create a new post' do
        expect { click_button submit }.not_to change(Post, :count)
      end
      it_should_behave_like 'save post with valid information'
    end
  end

  describe 'post destruction' do
    before do
      create(:post)
      sign_in admin
      visit root_path
    end

    it 'should delete a post' do
      expect do
        first('div.posts a[@data-method="delete"]').click
      end.to change(Post, :count).by(-1)
    end

    describe 'after destruction' do
      before { first('div.posts a[@data-method="delete"]').click }

      it { current_path.should == '/' }
      it { should have_success_message('Post was deleted!') }
    end
  end

  describe 'index' do
    before do
      create(:post)
      create(:post)
      visit '/'
    end
    let(:posts) { Post.all }

    it 'should not show edit icon to user not have permissions to edit' do
      should_not have_link('', href: edit_post_path(posts[0]))
    end

    it 'should not show delete icon to user not have permissions to delete' do
      should_not have_selector('div.posts a[@data-method="delete"]')
    end

    it 'should render posts' do
      posts.each do |post|
        should have_headline(post.title)
        should have_selector('time', text: post.created_at.to_s(:long))
        should have_content(truncate(post.content, length: 1000, separator: ' '))
      end
    end

    describe 'pagination' do
      before do
        10.times { create(:post) }
        visit '/'
        click_link '2'
      end
      after  { Post.delete_all }

      it 'should list second page properly' do
        Post.paginate(page: 2, per_page: 10).each do |post|
          should have_content(post.content)
        end
      end
    end
  end

  describe 'show page' do
    let(:post) { create(:post) }
    before { visit "/posts/#{post.id}" }

    it { should have_title(post.title) }
    it { should have_headline(post.title) }
    it { should have_selector('time', text: post.created_at.to_s(:long)) }
    it { should have_content(post.content) }
  end
end
