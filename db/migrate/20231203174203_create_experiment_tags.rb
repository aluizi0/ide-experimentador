class CreateExperimentTags < ActiveRecord::Migration[7.1]
  def change
    create_table :experiment_tags do |t|
      t.belongs_to :experiment
      t.belongs_to :tag
      t.timestamps
    end
  end
end
