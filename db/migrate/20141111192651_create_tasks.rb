class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name, required: true
      t.boolean :completed, default: false, required: true
      t.belongs_to :project, required: true

      t.timestamps
    end
  end
end
