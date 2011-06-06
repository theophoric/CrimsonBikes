class User
  include Mongoid::Document

  mount_uploader :avatar, ImageUploader
  
  embeds_many :notes, :as => :notable
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
  scope :admins, where(:admin => true)
  
  default_scope desc(:name_last)
         
  field :name_first
  field :name_last
  field :phone
  
  field :admin, :default => false
  
  index :name_last
  index :email
  
  validates_presence_of :name_first, :name_last, :phone
  validates_uniqueness_of :email, :case_sensitive => false
  attr_accessible :name_first, :name_last, :phone, :email, :password, :password_confirmation, :remember_me
  
  def admin?
    admin
  end
  
  def confirmed?
    !confirmed_at.nil?
  end
  
  def confirm
    update_attribute(:confirmed_at, Time.now)
  end
  
end
