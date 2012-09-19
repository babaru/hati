class AddIpColumnsClicks < ActiveRecord::Migration
  def up
    add_column :clicks, :real_ip, :string
    add_column :clicks, :forwarded_for, :string
  end

  def down
  end
end
