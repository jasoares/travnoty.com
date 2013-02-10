class RoundObserver < ActiveRecord::Observer
  def after_create(round)
    UpdateReporter.start_round_notice(round).deliver
  end

  def after_update(round)
    was, now = round.changes[:end_date]
    UpdateReporter.end_round_notice(round).deliver if was.nil? and now.is_a?(ActiveSupport::TimeWithZone)
  end
end
