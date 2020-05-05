class Inventory < ActiveRecord::Base
    has_many :orders, through: :apparels
    has_many :apparels

end