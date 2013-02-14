class RenameMirrorsHubIdToMainHubId < ActiveRecord::Migration
  def change
    rename_column :hubs, :mirrors_hub_id, :main_hub_id
  end
end
