class Apparel < ActiveRecord::Base
    belongs_to :inventory
    belongs_to :order
end