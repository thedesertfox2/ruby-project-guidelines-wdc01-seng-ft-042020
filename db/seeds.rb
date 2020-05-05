Client.destroy_all
Inventory.destroy_all
Order.destroy_all
Apparel.destroy_all
Retailer.destroy_all

# bob = Client.find_or_create_by(name: "Bob")
# alex = Client.find_or_create_by(name: "Alex")

# target = Retailer.find_or_create_by(name: "Target")
# walmart = Retailer.find_or_create_by(name: "Walmart")

# order = Order.find_or_create_by(status: "pending", client_id: bob.id)
# order2 = Order.find_or_create_by(status: "pending", client_id: alex.id)

# inventory = Inventory.find_or_create_by(name: "Air Jordan", cost: 109.99, retailer_id: target.id)
# inventory2 = Inventory.find_or_create_by(name: "Adidas Stripes", cost: 42.89, retailer_id: walmart.id)

# apparel = Apparel.find_or_create_by(order_id: order.id, inventory_id: inventory.id)
# apparel2 = Apparel.find_or_create_by(order_id: order2.id, inventory_id: inventory2.id)

# binding.pry