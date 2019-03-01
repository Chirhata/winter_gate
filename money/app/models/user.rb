class User < ApplicationRecord
    validates :name, {presence: true}
    validates :email, {uniqueness: true,presence: true}
    validates :o_password, {presence: true}
    validates :re_password, {presence: true}
    validates :question, {presence: true}
    validates :answer, {presence: true}
end
