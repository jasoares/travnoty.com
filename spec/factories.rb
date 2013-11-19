FactoryGirl.define do

  sequence(:name, 'A') { |n| "John Doe #{n.upcase}" }

  factory :pre_subscription do
    name  { generate(:name) }
    email { (name.blank? ? generate(:name) : name).gsub(/\s/, '') + "@example.com" }
  end

  sequence(:username) { |n| "johndoe#{n}" }

  factory :user do
    username { generate(:username) }
    password 'hersecretpassword'
    email    { (username.blank? ? generate(:username) : username) + "@example.com" }
  end

  factory :round do
    version '4.0'

    factory :ended_round do
      start_date { 2.years.ago.to_datetime }
      end_date   { (2.years.ago + 20.days).to_datetime }
    end

    factory :running_round do
      start_date 10.days.ago.to_datetime
    end

    factory :restarting_round do
      start_date 10.days.from_now.to_datetime
    end
  end

  factory :server do
    sequence(:name)                                      { |n| "Server #{n}"        }
    sequence(:code, aliases: [:server, :classic_server]) { |n| "ts#{n}"            }
    host                                                 { "#{code}.travian.com" }
    speed                                                1
    sequence(:world_id)                                  {|n| "com#{n}#{n}"        }

    factory :server_with_rounds do
      ignore do
        rounds_count 2
      end

      after(:create) do |server, eval|
        FactoryGirl.create(:running_round, :server => server)
        rounds = FactoryGirl.build_list(:ended_round, eval.rounds_count - 1)
        rounds.reverse.each { |round| server.rounds << round }
      end
    end

    trait :with_running_round do
      after(:create) do |server|
        FactoryGirl.create(:running_round, :server => server)
      end
    end

    trait :with_restarting_round do
      after(:create) do |server|
        FactoryGirl.create(:restarting_round, :server => server)
      end
    end

    trait :with_ended_rounds do
      ignore do
        rounds_count 2
      end

      after(:create) do |server, eval|
        rounds = FactoryGirl.build_list(:ended_round, eval.rounds_count)
        rounds.reverse.each { |round| server.rounds << round }
      end
    end
  end

  hub_codes = YAML.load_file(
    File.expand_path('../../db/seeds/tld_to_country_name.yml', __FILE__))

  factory :hub, aliases: [:main_hub] do
    sequence(:name)     { |n| hub_codes.values[n][:country] }
    sequence(:code)     { |n| hub_codes.keys[n] }
    host                { "www.travian.#{code}" }
    sequence(:language) { |n| hub_codes.values[n][:language] }

    trait :with_mirrors do
      ignore do
        mirrors_count 2
      end

      after(:create) do |hub, eval|
        FactoryGirl.create_list(:hub, eval.mirrors_count, :main_hub => hub)
      end
    end

    factory :mirror_hub do
      main_hub
    end

    trait :with_servers do
      after(:create) do |hub|
        main_hub = hub.mirror? ? hub.main_hub : hub
        FactoryGirl.create_list(:server, 3, :hub => main_hub)
      end
    end
  end

  factory :travian_account do
    sequence(:uid, 3) { |n| n }
    sequence(:username, 'username') { |n| n }

    trait :with_user_and_round do
      after(:build) do |account|
        account.user = create(:user)
        account.round = create(:server, :with_running_round).rounds.first
      end
    end
  end
end
