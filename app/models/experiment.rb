class Experiment < ApplicationRecord
    has_many :trials
    has_many :experiment_tag
    has_many :tags, through: :experiment_tag
    has_and_belongs_to_many :robots
end
