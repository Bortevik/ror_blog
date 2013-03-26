require 'spec_helper'

describe UserMailer do

  describe 'password reset' do
    let(:user) { create(:user, secret_token: 'anything') }
    let(:email) { UserMailer.password_reset(user) }

    it { email.subject.should eq 'Password reset' }
    it { email.to.should eq [user.email] }
    it { email.from.should eq ['from@example.com'] }
    it { email.body.encoded.should match edit_password_reset_path(user.secret_token) }
  end

  describe 'activation account' do
    let(:user) { create(:user, secret_token: 'anything') }
    let(:email) { UserMailer.activate_account(user) }

    it { email.subject.should eq 'Activate your account' }
    it { email.to.should eq [user.email] }
    it { email.from.should eq ['from@example.com'] }
    it { email.body.encoded.should match activate_path(user.secret_token) }
  end
end