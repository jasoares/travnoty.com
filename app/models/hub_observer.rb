class HubObserver < ActiveRecord::Observer
  def after_save(model)
    UpdateReporter.changed_hub(model).deliver if model.new_record? or model.changed?
  end
end
