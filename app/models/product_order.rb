class ProductOrder < ActiveRecord::Base
    belongs_to :product
    belongs_to :order

    def self.get_inventory(name)
        product_order_array = self.all.map {|productorder| productorder.product_id }
        product_array = Product.all.select {|product| product.name.downcase.rstrip == name.downcase.rstrip}
        product_array = product_array.map {|product| product.id}
        product_array - product_order_array
    end
    
end