require 'spec_helper'

describe 'User pages' do

  subject { page }

  shared_examples_for 'save user with invalid information' do

    it 'should not create a user' do
      expect {click_button submit }.not_to change(User, :count)
    end

    describe 'after submitting' do
      before { click_button submit }

      it 'with blank fields show error messages' do
        should have_content('error')
        should have_content("Name can't be blank")
        should have_content("Email can't be blank")
        should have_content("Password can't be blank")
        should have_content("Confirm password can't be blank")
      end

      it 'when name that is too short show error message' do
        fill_in 'Name', with: 'a' * 2
        click_button submit
        should have_content('Name is too short (minimum is 3 characters)')
      end

      it 'when name that is too long show error message' do
        fill_in 'Name', with: 'a' * 51
        click_button submit
        should have_content('Name is too long (maximum is 50 characters)')
      end

      it 'when email is invalid show error message' do
        fill_in 'Email', with: 'example.example.com'
        click_button submit
        should have_content('Email is invalid')
      end

      it 'when same email already is taken show error message' do
        email = create(:user).email
        fill_in 'Email', with: email.upcase
        click_button submit
        should have_content('Email has already been taken')
      end
    end
  end

  describe 'signing up' do
    let(:submit) { 'Sign up' }
    before { visit '/signup' }

    it 'page render properly' do
      should have_headline('Sign up')
      should have_title('Sign up')
    end

    describe 'with invalid information' do
      it_should_behave_like 'save user with invalid information'
    end

    describe 'with valid information' do
      let(:email) { 'example@example.com' }
      before do
        clear_emails
        fill_in 'Name',             with: 'Joe'
        fill_in 'Email',            with: email
        fill_in 'Password',         with: 'foobar'
        fill_in 'Confirm password', with: 'foobar'
      end

      it 'should create a user' do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe 'send email' do
        before { click_button submit }

        it { open_email(email).should be_present }
        it { should have_success_message 'Activation link was sent'}
      end

      describe 'account activation' do

        specify 'with invalid token' do
          expect do
            visit activate_path('somthing')
          end.to raise_exception(ActiveRecord::RecordNotFound)
        end

        describe 'with valid token' do
          let(:user) { create(:user, secret_token: 'token') }
          before { visit activate_path(user.secret_token) }

          it { should have_success_message 'Your account was activated' }
          it { current_path.should eq root_path }
        end
      end
    end
  end

  describe 'user profile edition' do
    let(:submit) { 'Save changes' }
    let(:user) { create(:user)}
    before do
      sign_in user
      visit edit_user_path user
    end

    describe 'edit page' do
      it { should have_headline('Edit profile') }
      it { should have_title('Edit profile') }
      it { find_field('Name').value.should eq(user.name) }
      it { find_field('Email').value.should eq(user.email) }

      it 'without permission redirect to home page' do
        signout
        another_user = create(:user)
        sign_in another_user
        visit edit_user_path(user)
        current_path.should eq root_path
      end
    end

    describe 'with invalid information' do
      before do
        fill_in 'Name',             with: ''
        fill_in 'Email',            with: ''
        fill_in 'Password',         with: ''
        fill_in 'Confirm password', with: ''
      end

      it_should_behave_like 'save user with invalid information'
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

      describe 'after updating profile' do
        before { click_button submit }

        it 'redirect to profile' do
          current_path.should eq user_path(user)
        end
        it 'have success message' do
          should have_success_message('Profile was updated!')
        end
      end
    end
  end

  describe 'user destruction' do
    before do
      user = create(:user)
      sign_in user
      visit user_path(user)
    end

    it 'should delete a user' do
      expect do
        click_link 'Delete account'
      end.to change(User, :count).by(-1)
    end

    describe 'after destruction' do
      before { click_link 'Delete account' }

      it { current_path.should eq root_path }
      it { should have_success_message('Your account was deleted') }
    end
  end

  describe 'index' do
    before do
      create(:user)
      create(:user)
      admin = create(:admin)
      sign_in admin
      visit users_path
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
        35.times { create(:user) }
        visit users_path
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
    let(:user) { create(:user) }
    before do
      sign_in user
      visit "/users/#{user.id}"
    end

    it { should have_title('User profile') }
    it { should have_headline('User profile') }
    it { should have_content(user.name) }
    it { should have_content(user.email) }
    it { should have_link('Edit profile', href: edit_user_path(user)) }
    it { should have_link('Delete account', href: user_path(user)) }

    it 'without permission redirect to home page' do
      another_user = create(:user)
      signout
      sign_in another_user
      visit user_path(user)
      current_path.should eq root_path
    end
  end
end
