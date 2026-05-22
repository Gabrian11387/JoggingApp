class User < ApplicationRecord
    has_many :microposts, dependent: :delete_all
    has_secure_password
    validates :username, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
    validates :password, presence: true, length: { minimum: 6 }

    before_create :set_default_role

    def is_admin?
        role == 'admin'
    end

    def is_manager?
        role == 'manager'
    end

    private

    def set_default_role
        self.role ||= 'usual'
    end

end
