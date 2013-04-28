include ApplicationHelper
include ActionView::Helpers::TextHelper

RSpec::Matchers.define :have_title do |title|
  match do |page|
    Capybara.string(page.body).has_selector?('title', text: title)
  end
end

RSpec::Matchers.define :have_headline do |text|
  match do |page|
    Capybara.string(page.body).has_selector?('h1', text: text)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    Capybara.string(page.body).has_selector?('div.alert.alert-success',
                                             text: message)
  end
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    Capybara.string(page.body).has_selector?('div.alert.alert-error',
                                             text: message)
  end
end

def sign_in(user)
  visit signin_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end

def signout
  page.find('a[@href="/signout"]').click
end
