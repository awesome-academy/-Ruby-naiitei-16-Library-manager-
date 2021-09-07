class Category < ApplicationRecord
  has_many :book_categories
  validates :name, presence: true,
            length: {minimum: Settings.validation.min_length,
                     maximum: Settings.validation.max_length}
  SORTS = ["name asc"].freeze

  has_many :books, through: :book_categories, dependent: :destroy
end
