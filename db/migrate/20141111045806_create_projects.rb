class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, required: true
      t.string :color, required: true

      t.timestamps
    end
  end
end
