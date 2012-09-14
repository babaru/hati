class CreateMoles < ActiveRecord::Migration
  def change
    create_table :moles do |t|
      t.string :name
      t.string :weibo_id
      t.string :access_token

      t.timestamps
    end
  end
end
