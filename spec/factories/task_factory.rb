FactoryGirl.define do
  factory :task, class: Task do
    name 'Task1'

    trait :expired do
      completed_at nil
      deadline { build(:time) - 1.day }
      created_at { build(:time) - 10.day }
    end

    trait :not_expired do
      completed_at nil
      deadline { build(:time) + 1.day }
      created_at { build(:time) - 10.day }
    end

    trait :without_deadline do
      completed_at nil
      deadline nil
      created_at { build(:time) - 10.day }
    end
  end
end