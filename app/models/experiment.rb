class Experiment < ApplicationRecord
    has_many :trials
    has_many :experiment_tag
    has_many :tags, through: :experiment_tag
end
