require 'spec_helper'

describe 'Static pages' do

  subject { page }

  describe 'About page' do
    before { visit '/about' }
    it { should have_title(full_title('About me'))}
  end

  describe 'Home page' do
    before { visit root_path }

    it 'show link to sign in' do
      should have_link('', href: signin_path)
    end

    describe 'when user signed in' do
      let(:user) { create(:user) }
      before do
        sign_in user
        visit root_path
      end

      it 'should show link to profile' do
        should have_link('', href: user_path(user))
      end
      it 'should show link to sign out' do
        should have_link('', href: signout_path)
      end
    end
  end
end
