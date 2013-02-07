FactoryGirl.define do
  factory :hub do
    name      'Portugal'
    host      'www.travian.pt'
    code      'pt'
    language  'pt'
  end

  factory :server do
    sequence(:name) {|n| "Servidor#{n}" }
    sequence(:host) {|n| "ts#{n}.travian.pt" }
    sequence(:code) {|n| "ts#{n}" }
    speed       1
    sequence(:world_id) {|n| "pt#{n}#{n}" }
  end

  factory :round do
    start_date   Date.new(2012,12,17).to_datetime
    end_date     nil
    version      '4.0'
  end
end
