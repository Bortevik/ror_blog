require 'spec_helper'

describe 'User pages' do

  subject { page }

  shared_examples_for 'save with invalid information' do

    it 'should not create a user' do
      expect {click_button submit }.not_to change(User, :count)
    end

    describe 'after submitting' do
      before { click_button submit }

      it { should have_content('error') }
      it { should have_content("Name can't be blank") }
      it { should have_content("Email can't be blank") }
      it { should have_content("Confirm password can't be blank") }

      describe 'when name that is too short' do
        before do
          fill_in 'Name', with: 'a' * 2
          click_button submit
        end

        it { should have_content('Name is too short (minimum is 3 characters)')}
      end

      describe 'when name that is too long' do
        before do
          fill_in 'Name', with: 'a' * 51
          click_button submit
        end

        it { should have_content('Name is too long (maximum is 50 characters)')}
      end

      describe 'when email is invalid' do
        before do
          fill_in 'Email', with: 'example.example.com'
          click_button submit
        end

        it { should have_content('Email is invalid')}
      end

      describe 'when same email already is taken' do
        before do
          email = FactoryGirl.create(:user).email
          fill_in 'Email', with: email.upcase
          click_button submit
        end
        it { should have_content('Email has already been taken')}
      end
    end
  end

  describe 'user creation' do
    let(:submit) { 'Sign up' }
    before { visit '/signup' }

    describe 'page' do
      it { should have_headline('Sign up') }
      it { should have_title('Sign up')}
    end

    describe 'with invalid information' do
      it_should_behave_like 'save with invalid information'
    end

    describe 'with valid information' do
      before do
        fill_in 'Name',             with: 'Joe'
        fill_in 'Email',            with: 'example@example.com'
        fill_in 'Password',         with: 'foobar'
        fill_in 'Confirm password', with: 'foobar'
      end

      it 'should create a user' do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe 'after creating user' do
        before { click_button submit }

        it { current_path.should == '/' }
        it { should have_success_message('New account created!') }
      end
    end
  end

  describe 'user profile edition' do
    let(:submit) { 'Save changes' }
    let(:user) { FactoryGirl.create(:user)}
    before do
      visit "/users/#{user.id}/edit"
    end

    describe 'edit page' do
      it { should have_headline('Edit profile') }
      it { should have_title('Edit profile') }
      it { find_field('Name').value.should eq(user.name) }
      it { find_field('Email').value.should eq(user.email) }
    end

    describe 'with invalid information' do
      before do
        fill_in 'Name',             with: ''
        fill_in 'Email',            with: ''
        fill_in 'Password',         with: ''
        fill_in 'Confirm password', with: ''
      end

      it_should_behave_like 'save with invalid information'
    end

    describe 'with valid information' do
      before do
        fill_in 'Name',             with: 'Bob'
        fill_in 'Email',            with: 'bob@example.com'
        fill_in 'Password',         with: 'barfoo'
        fill_in 'Confirm password', with: 'barfoo'
      end

      it 'should not create a new user' do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe 'after updating prafile' do
        before { click_button submit }
        let(:updated_user) { User.first }

        it { current_path.should == "/users/#{updated_user.id}" }
        it { should have_success_message('Profile was updated!') }
      end
    end
  end

  describe 'user destruction' do
    before do
      FactoryGirl.create(:user)
      visit '/users'
    end

    it 'should delete a user' do
      expect { find('a[@data-method="delete"]').click }.to change(User, :count).by(-1)
    end

    describe 'after destruction' do
      before { find('a[@data-method="delete"]').click }

      it { current_path.should == '/users' }
      it { should have_success_message('User was deleted!') }
    end
  end

  describe 'index' do
    before do
      FactoryGirl.create(:user)
      FactoryGirl.create(:user)
      visit '/users'
    end
    let(:users) { User.all }

    it 'should render users' do
      users.each do |user|
        should have_content(user.name)
        should have_content(user.email)
      end
    end

    describe 'pagination' do
      before do
        35.times { FactoryGirl.create(:user) }
        visit '/users'
        click_link '2'
      end
      after  { User.delete_all }

      it 'should list second page properly' do
        User.paginate(page: 2).each do |user|
          should have_content(user.email)
        end
      end
    end
  end

  describe 'show page' do
    let(:user) { FactoryGirl.create(:user) }
    before { visit "/users/#{user.id}" }

    it { should have_title('User profile') }
    it { should have_headline('User profile') }
    it { should have_content(user.name) }
    it { should have_content(user.email) }
  end
end