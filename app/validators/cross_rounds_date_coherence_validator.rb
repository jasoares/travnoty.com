class CrossRoundsDateCoherenceValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    if object.server
      last_end_date = Round.last_end_date_by(object.server)
      if last_end_date and value < last_end_date
        object.errors[attribute] << (options[:message] || "must be after last round's end_date")
      end
    end
  end
end
