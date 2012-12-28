class ServerObserver < ActiveRecord::Observer
  def after_save(model)
    UpdateReporter.changed_server(model).deliver if model.new_record? or model.changed?
  end
end
