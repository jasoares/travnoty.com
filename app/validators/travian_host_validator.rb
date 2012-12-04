class TravianHostValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value =~ %r[\Ahttp://\w+\.travian\.\w+(?:\.\w+)?/\Z]
      object.errors[attribute] << (options[:message] || "is not a valid travian host")
    end
  end
end
