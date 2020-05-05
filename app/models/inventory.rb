class Inventory < ActiveRecord::Base
    belongs_to :retailer
    has_many :orders, through: :apparels
    has_many :apparels

end