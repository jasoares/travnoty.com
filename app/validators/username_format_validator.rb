class UsernameFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value =~ /\A[a-z0-9][-a-z0-9]+\z/i
      msg = "may only contain alphanumeric characters or dashes and cannot start with a dash"
      object.errors[attribute] << (options[:message] || msg)
    end
  end
end
