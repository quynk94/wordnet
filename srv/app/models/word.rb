class Word < ApplicationRecord
  has_many :word_tags, dependent: :destroy
  has_many :tags, through: :word_tags
end
