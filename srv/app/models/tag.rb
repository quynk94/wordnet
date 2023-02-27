class Tag < ApplicationRecord
  has_many :word_tags, dependent: :destroy
  has_many :words, through: :word_tags
end
