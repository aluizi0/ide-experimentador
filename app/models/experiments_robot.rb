class ExperimentsRobot < ActiveRecord::Base
  belongs_to :experiment
  belongs_to :robot
end
