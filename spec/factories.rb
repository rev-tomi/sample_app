FactoryGirl.define do
  factory :user do
    name      "Tamas Rev"
    email     "tamas@example.com"
    password  "foobar"
    password_confirmation "foobar"
  end
end
