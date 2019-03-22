class MoneyManagement < ApplicationRecord
    validates :income_and_spending, {presence: true}
    validates :use_for, {presence: true}
    validates :user_id, {presence: true}
    validates :income_or_supend, {presence: true}
end
