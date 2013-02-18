Given /^today is (\d{2})-(\d{2})-(\d{4})$/ do |d, m, y|
  year, month, day = [y, m, d].map(&:to_i)
  Timecop.freeze(Time.new(year, month, day))
end
