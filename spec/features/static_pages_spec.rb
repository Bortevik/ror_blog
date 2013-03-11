require 'spec_helper'

describe 'Static pages' do

  subject { page }

  describe 'Home page' do
    before { visit '/' }

    it { should have_title(full_title(''))}
    it { should_not have_title('| Home')}
  end

  describe 'About page' do
    before { visit '/about' }
    it { should have_title(full_title('About me'))}
  end
end