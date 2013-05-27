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

      it { should have_selector('.post_title span', text: "can't be blank") }
      it { should have_selector('.post_content span', text: "can't be blank") }

      describe 'when title that is too long' do
        before do
          fill_in 'Title', with: 'a' * 101
          click_button submit
        end

        it { should have_content('is too long (maximum is 100 characters)')}
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
        fill_in 'Title',     with: 'Post one'
        fill_in 'Content',   with: 'Lorem ipsum'
        fill_in 'Tag names', with: 'foo bar'
      end

      it 'should create a post' do
        expect { click_button submit }.to change(Post, :count).by(1)
      end

      it 'should create tags' do
        expect { click_button submit }.to change(Tag, :count).by(1)
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

      it 'should update tags' do
        post = create(:post, tag_names: 'foo bar, blah')
        visit edit_post_path(post)
        fill_in 'Tag names', with: 'boom'
        expect do
          click_button submit
        end.to change { post.tags.pluck(:name).join(', ') }.from('foo bar, blah').to('boom')
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
        find("#delete_#{Post.first.id}").click
      end.to change(Post, :count).by(-1)
    end

    describe 'after destruction' do
      before { find("#delete_#{Post.first.id}").click }

      it { current_path.should == '/' }
      it { should have_success_message('Post was deleted!') }
    end
  end

  describe 'index' do
    before do
      @post = create(:post)
      visit root_path
    end

    it 'should not show edit icon to user not have permissions to edit' do
      should_not have_link('', href: edit_post_path(@post))
    end

    it 'should not show delete icon to user not have permissions to delete' do
      should_not have_selector("#delete_#{@post.id}")
    end

    it 'should render posts' do
      Post.all.each do |post|
        should have_headline(post.title)
        should have_selector('time', text: post.created_at.to_s(:long))
        should have_content(truncate(post.content, length: 1, separator: '<!--more-->'))
      end
    end

    it 'pagination should list second page properly' do
      create_list(:post, 11)
      visit root_path
      within '.pagination' do
        click_link '2'
      end
      Post.page(2).per_page(10).each do |post|
        should have_content(truncate(post.content, length: 1, separator: '<!--more-->'))
      end
    end

    it 'display count of post comments' do
      comments = create_list(:comment, 2, post_id: @post.id)
      visit root_path
      should have_link(comments.count.to_s, href: "#{post_path(@post)}/#comments")
    end

    it 'display post tags' do
      @post.tag_names = 'foo'
      @post.save
      visit root_path
      within '.infopanel' do
        should have_link('foo', href: tag_path(@post.tags[0]))
      end
    end
  end

  describe 'show page' do
    before { @post = create(:post) }

    it 'display post properly' do
      visit post_path(@post)
      should have_title(@post.title)
      should have_headline(@post.title)
      should have_selector('article time', text: @post.created_at.to_s(:long))
      should have_content(@post.content)
    end

    it 'display post tags' do
      @post.tag_names = 'foo'
      @post.save
      visit post_path(@post)
      within '.infopanel' do
        should have_link('foo', href: tag_path(@post.tags[0]))
      end
    end

    describe 'with comments' do

      it 'display count of comments' do
        comments = create_list(:comment, 2, post_id: @post.id)
        visit post_path(@post)
        should have_selector('h4', text: comments.count.to_s)
      end

      it 'display all comments belongs to post' do
        comments = create_list(:comment, 2, post_id: @post.id)
        visit post_path(@post)
        comments.each do |comment|
          should have_content(comment.body)
        end
      end

      it 'do not display comments do not belongs to post' do
        comment = create(:comment)
        visit post_path(@post)
        should_not have_content(comment.body)
      end

      it 'display user name for comment created by signed in user' do
        user = create(:user)
        comment = build(:comment, post_id: @post.id)
        comment.user_id = user.id
        comment.save
        visit post_path(@post)
        should have_content(user.name)
      end

      it 'display "guest" as username for comment created by guest' do
        comment = create(:comment, post_id: @post.id)
        visit post_path(@post)
        should have_content('Guest')
      end

      it 'display comment creation date' do
        comment = create(:comment, post_id: @post.id)
        visit post_path(@post)
        should have_content(comment.created_at.to_s(:long))
      end

      it 'do not display delete link to user have no permission' do
        comment = create(:comment, post_id: @post.id)
        visit post_path(@post)
        should_not have_selector("#delete_#{comment.id}")
      end

      it 'display deleted comment as dots' do
        comment = create(:comment, body: '#deleted#',  post_id: @post.id)
        visit post_path(@post)
        should have_content('......')
      end
    end
  end
end
