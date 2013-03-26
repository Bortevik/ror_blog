require 'spec_helper'

feature 'Reset password' do

  subject { page }

  describe 'sending email' do
    background { visit new_password_reset_path }

    scenario 'page displayed properly' do
      should have_title 'Reset password'
      should have_headline 'Reset password'
    end

    given(:wrong_email) { 'one@example.com' }

    scenario 'with invalid email does not send email' do
      fill_in 'Email', with: wrong_email
      click_button 'Reset password'
      current_path.should eq(root_path)
      should have_error_message "Not found user with email #{wrong_email}"
      open_email(wrong_email).should be_nil
    end

    given(:user) { create(:user) }

    scenario 'with valid email send email' do
      fill_in 'Email', with: user.email
      click_button 'Reset password'
      should have_content 'Email sent with password reset'
      open_email(user.email).subject.should have_content 'Password reset'
    end
  end

  describe 'update password' do
    given(:user) { create(:user) }
    background do
      user.send_password_reset
      open_email(user.email).click_link(user.secret_token)
    end

    scenario 'with blank fields' do
      click_button 'Update password'
      should have_content "Confirm password can't be blank"
      should have_content "Password can't be blank"
    end

    scenario 'when confirmation does not match' do
      fill_in 'Password', with: 'foo'
      click_button 'Update password'
      should have_content "Password doesn't match confirmation"
    end

    scenario 'when confirmation matches' do
      fill_in 'Password', with: 'foo'
      fill_in 'Confirm password', with: 'foo'
      click_button 'Update password'
      should have_success_message 'Password has been updated'
      current_path.should eq root_path
    end

    scenario 'when token has expired' do
      user.secret_token_sent_at = 4.hour.ago
      user.save!
      visit edit_password_reset_path(user.secret_token)
      should have_error_message 'Password reset has expired'
    end

    scenario 'when token invalid' do
      expect do
        visit edit_password_reset_path('not exist')
      end.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end