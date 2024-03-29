class User < ActiveRecord::Base
  has_secure_password
  has_many :orders
  has_many :order_items, through: :orders
  has_one :restaurant
  has_many :user_transactions
  has_many :user_restaurant_roles
  has_many :roles, through: :user_restaurant_roles

  validates :full_name, presence: true, length: { in: 5..100 },
  format: { with: /\A[a-z ,.'-]+\z/i,  message: "Incorrect name format" }

  validates :email, presence: true, length: { maximum: 255 },
  format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "Invalid" },
  uniqueness: { case_sensitive: false }

  validates :password, presence: true

  validates :password_confirmation, presence: true

  validates :display_name, length: { in: 2..32 }, allow_blank: true

  def admin?
    false
  end

  def owns_restaurant?
    self.restaurant
  end

  def most_recent_transaction
    user_transactions.last
  end
  
  def has_restaurant_role?(restaurant)
    user_restaurant_roles.find_by(restaurant_id: restaurant.id)
  end
  
  def is_owner?(restaurant)
    self.restaurant == restaurant
  end
  
  def is_cook?(restaurant)
    has_restaurant_role?(restaurant) && roles.find_by(name: "cook")
  end
  
  def is_delivery?(restaurant)
    has_restaurant_role?(restaurant) && roles.find_by(name: "delivery")
  end
end
