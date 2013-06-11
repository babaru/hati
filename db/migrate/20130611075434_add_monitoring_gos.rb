class AddMonitoringGos < ActiveRecord::Migration
  def up
    add_column :gos, :is_monitoring, :boolean, :default => true
    add_column :gos, :monitor_group_name, :string
  end

  def down
    remove_column :gos, :is_monitoring
    remove_column :gos, :monitor_group_name
  end
end
