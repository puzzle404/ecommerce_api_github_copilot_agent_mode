require 'faker'

puts "Limpieza de tablas..."
Purchase.delete_all
Product.delete_all
Category.delete_all
User.delete_all
Audit.delete_all if defined?(Audit)

puts "Creando administradores..."
admin1 = User.create!(email: 'cmanuferrer@gmail.com', password: 123456, password_confirmation: 123456)
admin2 = User.create!(email: 'admin2@ecommerce.com', password: 'admin123', password_confirmation: 'admin123')

puts "Creando clientes..."
customers = 50.times.map do
  User.create!(
    email: Faker::Internet.unique.email,
    password: 'customer123',
    password_confirmation: 'customer123'
  )
end

puts "Creando categorías..."
categories = [
  { name: 'Tecnología', description: 'Celulares, notebooks y más' },
  { name: 'Hogar', description: 'Electrodomésticos y muebles' },
  { name: 'Deportes', description: 'Indumentaria y equipamiento' },
  { name: 'Libros', description: 'Educación, novelas, técnicos' },
  { name: 'Juguetes', description: 'Para todas las edades' }
].map.with_index do |attrs, i|
  Category.create!(
    name: attrs[:name],
    description: attrs[:description],
    administrator: i.even? ? admin1 : admin2
  )
end

puts "Creando productos..."
products = []
categories.each do |category|
  10.times do
    products << Product.create!(
      name: Faker::Commerce.product_name,
      price: Faker::Commerce.price(range: 10..1000),
      stock: rand(10..200),
      description: Faker::Lorem.sentence,
      administrator: [admin1, admin2].sample,
      category: category
    )
  end
end

puts "Creando compras..."
200.times do
  product = products.sample
  quantity = rand(1..5)
  Purchase.create!(
    product: product,
    customer: customers.sample,
    quantity: quantity,
    purchase_date: Faker::Date.between(from: 90.days.ago, to: Date.today),
    total_price: (product.price * quantity).round(2)
  )
end

if defined?(Audit)
  puts "Creando auditorías..."
  50.times do
    Audit.create!(
      action: %w[create_product update_product delete_product create_purchase].sample,
      auditable_type: 'Product',
      auditable_id: products.sample.id,
      user_id: [admin1.id, admin2.id].sample,
      data: { note: Faker::Lorem.sentence },
      created_at: Faker::Date.between(from: 60.days.ago, to: Date.today)
    )
  end
end

puts "✅ Seeds completados:"
puts "- Usuarios: #{User.count}"
puts "- Clientes: #{User.count - 2}"
puts "- Categorías: #{Category.count}"
puts "- Productos: #{Product.count}"
puts "- Compras: #{Purchase.count}"
puts "- Auditorías: #{Audit.count if defined?(Audit)}"
