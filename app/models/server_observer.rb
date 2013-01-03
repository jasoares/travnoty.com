class ServerObserver < ActiveRecord::Observer
  def after_save(model)
    UpdateReporter.server_status(model, :ended).deliver if model.changes["end_date"]
  end

  def after_create(model)
    UpdateReporter.server_status(model, :started).deliver
  end
end
