FactoryGirl.define do
  factory :hub do
    name      'Portugal'
    host      'http://www.travian.pt/'
    code      'pt'
    language  'pt'
  end

  factory :server do
    name        'Servidor 3'
    host        'http://ts3.travian.pt/'
    speed       1
    start_date  Time.utc(2012, 8, 27).to_date
    end_date    nil
    version     '4.0'
    world_id    'pt33'
  end
end
