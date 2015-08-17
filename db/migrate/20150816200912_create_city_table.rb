class CreateCityTable < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name, null:false

      t.timestamp
    end
  end
end
