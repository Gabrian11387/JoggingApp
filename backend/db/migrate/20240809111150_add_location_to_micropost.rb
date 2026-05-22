class AddLocationToMicropost < ActiveRecord::Migration[6.1]
  def change
    add_column :microposts, :location, :string
  end
end
