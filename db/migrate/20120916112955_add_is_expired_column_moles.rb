class AddIsExpiredColumnMoles < ActiveRecord::Migration
  def up
  	add_column :moles, :is_expired, :boolean, :default => false
  end

  def down
  	remove_column :moles, :is_expired
  end
end
