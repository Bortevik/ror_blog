require 'spec_helper'

describe 'Static pages' do

  subject { page }

  describe 'About page' do
    before { visit '/about' }
    it { should have_title(full_title('About me'))}
  end
end