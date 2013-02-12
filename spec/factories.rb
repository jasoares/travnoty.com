FactoryGirl.define do
  factory :round do
    version '4.0'

    factory :ended_round do
      start_date 1.year.ago.to_datetime
      end_date   20.days.ago.to_datetime
    end

    factory :archived_round do
      start_date 2.years.ago.to_datetime
      end_date   (1.year + 10.days).ago.to_datetime
    end

    factory :running_round do
      start_date 10.days.ago.to_datetime
    end

    factory :restarting_round do
      start_date 10.days.from_now.to_datetime
    end
  end

  factory :server do
    sequence(:name) {|n| "Server#{n}" }
    sequence(:host) {|n| "ts#{n}.travian.com" }
    sequence(:code) {|n| "ts#{n}" }
    speed       1
    sequence(:world_id) {|n| "com#{n}#{n}" }

    trait :with_running_round do
      after(:create) do |server|
        FactoryGirl.create(:running_round, :server => server)
      end
    end
  end

  factory :hub do
    name      'International'
    host      'www.travian.com'
    code      'com'
    language  'en'
  end
end
