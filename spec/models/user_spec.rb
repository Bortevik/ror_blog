require 'spec_helper'

describe User do

  before do
    @user = User.new(name:     'Example User',
                     email:    'example@example.com',
                     password: 'foobar',
                     password_confirmation: 'foobar')
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  describe 'when name is not present' do
    before { @user.name = ' ' }
    it { should_not be_valid }
  end

  describe 'when name is less than 3' do
    before { @user.name = 'ab' }
    it { should_not be_valid }
  end

  describe 'when name is longer than 50' do
    before { @user.name = 'a' * 51 }
    it { should_not be_valid }
  end

  describe 'when email is not present' do
    before { @user.email = ' ' }
    it { should_not be_valid }
  end

  describe 'when email format is invalid' do
    let(:addresses) do
      %w[user@foo,com user_at_foo.org example.user@foo.
                    foo@bar_baz.com foo@bar+baz.com]
    end

    it 'should be invalid' do
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe 'when email format is valid' do
    let(:addresses) do
      %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
    end

    it 'should be valid' do
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe 'when email already is taken' do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email.upcase!
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe 'email with mixed case' do
    let(:mixed_case_email) { 'EXamPle@eXampLe.Com' }
    before do
      @user.email = mixed_case_email
      @user.save
      @user.reload
    end

    it { @user.email.should == mixed_case_email.downcase }
  end

  describe 'when password is not present' do
    before { @user.password = ' ' }
    it { should_not be_valid }
  end

  describe 'when password confirmation is not present' do
    before { @user.password_confirmation = ' ' }
    it { should_not be_valid }
  end

  describe "when password don't match confirmation" do
    before { @user.password_confirmation = 'mismatch' }
    it { should_not be_valid }
  end

  describe 'return value of authenticate method' do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe 'with valid password' do
      it { should == found_user.authenticate(@user.password) }
    end

    describe 'with invalid password' do
      let(:user_for_invalid_password) { found_user.authenticate('invalid') }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end
end