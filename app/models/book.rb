class Book < ApplicationRecord
  belongs_to :author
  has_many :book_categories
  has_many :book_publishers, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :categories, through: :book_categories, dependent: :destroy
  has_many :requests, foreign_key: :book_id, dependent: :destroy

  accepts_nested_attributes_for :book_categories

  delegate :name, to: :author, prefix: true

  PERMITTED_FIELDS =
    [
      :name, :detail, :number_of_page,
      category_ids: [],
      book_categories_attributes: [:id, :book_id, :category_id]
    ].freeze

  validates :name, presence: true,
            length: {
              maximum: Settings.validate.name.max_length
            }

  validates :number_of_page, presence: true,
            numericality: {
              only_integer: true,
              greater_than: Settings.zero
            }
end
