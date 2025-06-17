class Purchase < ApplicationRecord
  belongs_to :product
  belongs_to :customer, class_name: 'User'
  # Puedes agregar validaciones y atributos según tu dominio
end
