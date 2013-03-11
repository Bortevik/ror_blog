require 'spec_helper'

describe 'Post pages' do

  subject { page }

  describe 'post creation' do
    before { visit '/posts/new' }

    describe 'with invalid information' do

      it 'should not create a post' do
        expect {click_button 'Create post' }.not_to change(Post, :count)
      end

      describe 'after submitting' do
        before { click_button 'Create post' }

        it { should have_headline('Create new post') }
        it { should have_content('error') }
        it { should have_content("Title can't be blank") }
        it { should have_content("Content can't be blank") }

        describe 'when title that is too long' do
          before do
            fill_in 'Title', with: 'a' * 101
            click_button 'Create post'
          end

          it { should have_content('Title is too long (maximum is 100 characters)')}
        end
      end
    end

    describe 'with valid information' do
      let(:post_title)   { 'Post one' }
      let(:post_content) { 'Lorem ipsum' }
      before do
        fill_in 'Title',   with:  post_title
        fill_in 'Content', with:  post_content
      end

      it 'should create a post' do
        expect {click_button 'Create post' }.to change(Post, :count).by(1)
      end

      describe 'after creating post' do
        before { click_button 'Create post' }

        it { should have_selector('h2', text: post_title)}
        it { should have_content(post_content)}
        it { should have_success_message('New post created!') }
      end
    end
  end

  describe 'index' do
    before do
      FactoryGirl.create(:post)
      FactoryGirl.create(:post)
      visit '/posts'
    end
    let(:posts) { Post.all }

    it "should render posts" do
      posts.each do |post|
        should have_selector('h3', text: post.title)
        should have_content(truncate(post.content, length: 1000, separator: ' '))
      end
    end
  end

  describe 'post page' do
    let(:post) { FactoryGirl.create(:post) }
    before { visit "/posts/#{post.id}" }

    it { should have_selector('h2', text: post.title) }
    it { should have_content(post.content) }
  end
end
