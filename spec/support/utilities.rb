include ApplicationHelper

def valid_signin(user)
  fill_in "Email",    with: user.email.upcase
  fill_in "Password", with: user.password
  click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-success', text: message)
  end
end

RSpec::Matchers.define :have_error_explanation do
  match do |page|
    expect(page).to have_selector('#error_explanation ul li')
  end
end

RSpec::Matchers.define :have_error_field do
  match do |page|
    expect(page).to have_selector('.field_with_errors')
  end
end

