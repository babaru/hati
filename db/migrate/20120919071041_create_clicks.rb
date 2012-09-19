class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
      t.text :header
      t.string :referal
      t.string :remote_ip
      t.integer :reds_id

      t.timestamps
    end
  end
end
