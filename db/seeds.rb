Client.destroy_all
Inventory.destroy_all
Order.destroy_all
Apparel.destroy_all
Retailer.destroy_all

bob = Client.find_or_create_by(name: "Bob")
target = Retailer.find_or_create_by(name: "Target")
order = Order.find_or_create_by(status: "pending", client_id: bob.id)
binding.pry