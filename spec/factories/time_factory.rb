FactoryGirl.define do
  factory :time, class: Time do
    initialize_with { DateTime.new(2018, 01, 16, 8, 0, 0, '+00:00') }
  end
end