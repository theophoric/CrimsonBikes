class User
  include Mongoid::Document
  
  embeds_many :notes, :as => :notable
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
         
  field :name_first
  field :name_last
  field :phone
  validates_presence_of :name_first, :name_last, :phone
  validates_uniqueness_of :name_first, :name_last, :phone, :email, :case_sensitive => false
  attr_accessible :name_first, :name_last, :phone, :email, :password, :password_confirmation, :remember_me
end
