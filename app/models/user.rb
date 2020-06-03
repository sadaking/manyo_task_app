class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :email, uniqueness: true
  before_validation { email.downcase! }
  has_secure_password
  validates :password, presence: true, on: :new , length: { minimum: 6 }
  has_many :tasks, dependent: :destroy

  before_update :admin_update_restriction?
  before_destroy :admin_destroy_restriction?

  private

  def admin_update_restriction?
    @admin_user = User.where(admin: true)
    if (@admin_user.count == 1 && @admin_user.first == self) && !(self.admin?)
      throw :abort
    end
  end


  def admin_destroy_restriction?
    if User.where(admin: true).count <=1 && self.admin == true
      throw :abort
    end
  end
end
