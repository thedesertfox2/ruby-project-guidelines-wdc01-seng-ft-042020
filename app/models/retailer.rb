class Retailer < ActiveRecord::Base
    has_many :inventory
    has_many :apparels, through: :inventory

end