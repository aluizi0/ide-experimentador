class ExperimentTag < ApplicationRecord
  belongs_to :experiment
  belongs_to :tag
end
