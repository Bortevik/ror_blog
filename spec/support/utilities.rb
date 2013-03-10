include ApplicationHelper

RSpec::Matchers.define :have_title do |title|
  match do |page|
    Capybara.string(page.body).has_selector?('title', text: title)
  end
end

RSpec::Matchers.define :have_headline do |text|
  match do |page|
    page.should have_selector('h1', text: text)
  end
end