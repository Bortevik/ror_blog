require 'spec_helper'

describe 'Authentication' do

  subject { page }

  describe 'sign in' do
    before { visit '/signin' }

    describe 'page' do
      it { should have_title 'Sign in' }
      it { should have_headline 'Sign in' }
    end

    describe 'with invalid information' do
      before { click_button 'Sign in' }
      it { should have_error_message('Invalid email/password combination') }
      it { should have_link('', href: signin_path) }
      it { should_not have_link('', href: signout_path) }
    end

    describe 'with valid information' do
      let(:user) { FactoryGirl.create(:user) }
      let(:post) { FactoryGirl.create(:post) }
      before { sign_in user }

      it { should have_success_message "Welcome #{user.name}!" }
      it { should have_link('', href: signout_path) }
      it { should_not have_link('', href: signin_path) }

      describe 'followed by signout' do
        before { signout }
        it { should have_link('', href: signin_path) }
        it { current_path.should == '/' }
      end
    end

    describe 'when user already signed in' do
      before do
        user = create(:user)
        sign_in user
        visit signin_path
      end

      it 'should redirect to home page' do
        current_path.should eq '/'
      end
    end

    describe 'when user not yet activated' do
      let(:not_activated_user) { create(:not_activated_user) }
      before do
        clear_emails
        sign_in not_activated_user
      end

      it { should have_error_message 'Your account not yet activated' }
      it { open_email(not_activated_user.email).should be_present }
    end
  end
end
