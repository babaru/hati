class CreateGos < ActiveRecord::Migration
  def change
    create_table :gos do |t|
      t.string :code
      t.string :url

      t.timestamps
    end
  end
end
