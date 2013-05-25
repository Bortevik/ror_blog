# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  email                :string(255)
#  password_digest      :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  auth_token           :string(255)
#  secret_token         :string(255)
#  secret_token_sent_at :datetime
#

require 'spec_helper'
include Capybara::Email::DSL

describe User do

  before { @user = build(:user) }

  let(:user) { create(:user) }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:auth_token) }
  it { should respond_to(:secret_token) }
  it { should respond_to(:secret_token_sent_at) }
  it { should respond_to(:activated) }
  it { should respond_to(:generate_token) }
  it { should respond_to(:send_password_reset) }
  it { should respond_to(:roles) }
  it { should respond_to(:assignments) }
  it { should respond_to(:role?) }
  it { should respond_to(:comments) }

  it { should be_valid }

  it 'is invalid when name is not present' do
    @user.name = ' '
    should_not be_valid
  end

  it 'is invalid when name is less than 3' do
    @user.name = 'ab'
    should_not be_valid
  end

  it 'is invalid when name is longer than 50' do
    @user.name = 'a' * 51
    should_not be_valid
  end

  it 'is invalid when email is not present' do
    @user.email = ' '
    should_not be_valid
  end

  it 'is invalid when email format is invalid' do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                   foo@bar_baz.com foo@bar+baz.com]
    addresses.each do |invalid_address|
      @user.email = invalid_address
      @user.should_not be_valid
    end
  end

  it 'is valid when email format is valid' do
    addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
    addresses.each do |valid_address|
      @user.email = valid_address
      @user.should be_valid
    end
  end

  it 'is invalid when email already is taken' do
    user_with_same_email = create(:user, email: @user.email)
    user_with_same_email.email.upcase!
    user_with_same_email.save
    should_not be_valid
  end

  it 'is invalid when name already is taken' do
    user_with_same_name = create(:user, name: @user.name)
    user_with_same_name.name.upcase!
    user_with_same_name.save
    should_not be_valid
  end

  it 'email with mixed case should save downcased' do
    mixed_case_email = 'EXamPle@eXampLe.Com'
    @user.email = mixed_case_email
    @user.save
    @user.reload
    @user.email.should == mixed_case_email.downcase
  end

  it 'is invalid when password is not present' do
    @user.password = ' '
    should_not be_valid
  end

  it 'is invalid when password confirmation is not present' do
    @user.password_confirmation = ' '
    should_not be_valid
  end

  it "is invalid when password doesn't match confirmation" do
    @user.password_confirmation = 'mismatch'
    should_not be_valid
  end

  describe 'authenticate method' do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    it 'with valid password return user object' do
      should eq found_user.authenticate(@user.password)
    end
    it 'with invalid password return false' do
      found_user.authenticate('invalid').should be_false
    end
  end

  it 'create auth token when user created' do
    user.auth_token.should be_present
  end

  it 'generated token should be unique' do
    last_token = user.generate_token(:secret_token)
    user.generate_token(:secret_token)
    user.secret_token.should_not eq last_token 
  end

  it 'send password reset' do
    user.send_password_reset
    user.reload.secret_token_sent_at.should be_present
    open_email(user.email).should be_present
  end

  it 'send activation link' do
    user.send_activation_link
    open_email(user.email).should be_present
  end

  describe 'role?' do
    let(:some_role) { create(:role) }

    it 'with assigned role return true' do
      user.assignments.create!(role_id: some_role.id)
      user.role?(some_role.name.to_sym).should be_true
    end

    it 'with no assigned role return false' do
      user.role?(:role).should be_false
    end
  end
end
