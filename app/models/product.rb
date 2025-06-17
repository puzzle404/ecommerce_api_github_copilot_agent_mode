class Product < ApplicationRecord
  has_many :purchases
  belongs_to :administrator, class_name: 'User'
  belongs_to :category
  # Puedes agregar validaciones y atributos según tu dominio
end
