class CreateJoinTableExperimentsRobots < ActiveRecord::Migration[7.1]
  def change
    create_join_table :experiments, :robots do |t|
      t.index [:experiment_id, :robot_id]
      t.index [:robot_id, :experiment_id]
    end
  end
end
