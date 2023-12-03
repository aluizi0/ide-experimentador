class Experiment < ApplicationRecord
    has_many :trials
    has_many :tags, through: :experiment_tag
end
