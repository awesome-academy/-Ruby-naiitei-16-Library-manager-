class Request < ApplicationRecord
  belongs_to :book
  belongs_to :user

  delegate :name, :email, to: :user, prefix: true
  delegate :name, to: :book, prefix: true

  validate :check_valid_date, on: :create

  scope :newest, ->{order created_at: :desc}
  scope :get_month, ->(month){where "MONTH(created_at) = ?", month}

  enum status: {borrowing: 1, returned: 2, expired: 3}

  def check_valid_date
    errors.add I18n.t("requests.create.date_end_invalid") if date_end.past?
  end
end
