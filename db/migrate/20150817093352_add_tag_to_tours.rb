class AddTagToTours < ActiveRecord::Migration
  def change
    add_reference :tours, :tag, index: true, foreign_key: true
  end
end
