FactoryGirl.define do
  factory :hub do
    name      'Portugal'
    host      'http://www.travian.pt/'
    code      'pt'
    language  'pt'
  end

  factory :server do
    sequence(:name) {|n| "Servidor#{n}" }
    sequence(:host) {|n| "http://ts#{n}.travian.pt/" }
    sequence(:code) {|n| "ts#{n}" }
    speed       1
    start_date  180.days.ago
    end_date    nil
    version     '4.0'
    sequence(:world_id) {|n| "pt#{n}#{n}" }
  end
end
