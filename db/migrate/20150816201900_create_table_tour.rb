class CreateTableTour < ActiveRecord::Migration
  def change
    create_table :tours do |t|
      t.string :name, null: false

      t.references :city, index: true

      t.timestamp
    end
  end
end
