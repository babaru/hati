class CreateIps < ActiveRecord::Migration
  def change
    create_table :ips, :id => false do |t|
      t.string :ip_start
      t.string :ip_end
      t.string :region
      t.string :comment
    end
  end
end
