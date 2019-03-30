class User < ApplicationRecord
    validates :name, {presence: true, length: { maximum: 20}}
    validates :email, {uniqueness: true, presence: true}
    validates :question, {presence: true, length: { maximum: 140}}
    validates :answer, {presence: true, length: { maximum: 140}}
    validates :money_limit, {presence: true}
    validates :money_limit_day, {presence: true}
    validates :income, {presence: true}
    validates :money_limit_origin, {presence: true}
    validates :money_limit_day_origin, {presence: true}
    has_secure_password
end
