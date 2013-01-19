require 'yaml_db'

module FakeDb
  extend self

  def load_snapshot(snapshot)
    snapshot_file = snapshot_dir + "/#{snapshot}_snap.yml"
    SerializationHelper::Base.new(YamlDb::Helper).load snapshot_file
  end

  def snapshot_dir
    "#{Rails.root}/spec/fixtures"
  end
end
