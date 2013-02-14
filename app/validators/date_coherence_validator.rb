class DateCoherenceValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    if value and object.start_date > value
      [:start_date, :end_date].each do |attr|
        msg = attr == :start_date ? "must be before the end date" : "must be after the start date"
        object.errors[attr] << (options[:message] || msg)
      end
    end
  end
end
