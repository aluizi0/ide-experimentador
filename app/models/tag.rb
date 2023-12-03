class Tag < ApplicationRecord
    has_many :trials, through: :classification
    has_many :experiments, through: :experiment_tag
end
