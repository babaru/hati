class CreateReds < ActiveRecord::Migration
  def change
    create_table :reds do |t|
      t.string :code
      t.string :url

      t.timestamps
    end
  end
end
