class CreateAccessLogs < ActiveRecord::Migration
  def change
    create_table :access_logs do |t|
      t.text :header
      t.string :referal
      t.string :remote_ip
      t.string :real_ip
      t.string :forwarded_for
      t.string :go_code
      t.references :go

      t.timestamps
    end
    add_index :access_logs, :go_id
  end
end
