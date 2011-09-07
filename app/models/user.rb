class User
  include Mongoid::Document
  
  include Sortable

  mount_uploader :avatar, ImageUploader
  
  has_many :reservations
  has_one :profile
  
  embeds_one :membership
  embeds_many :notes, :as => :notable
  
  after_create {create_membership}
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
  scope :admins, where(:admin => true)
  
  default_scope asc(:name_last)
         
  field :name_first
  field :name_last
  field :phone
  field :residence

  field :admin, :default => false
  # field :processed, :default => false
  field :flagged, :type => Boolean, :default => false
  
  index :name_last
  index :email
  
  validates_presence_of :name_first, :name_last, :phone
  validates_uniqueness_of :email, :case_sensitive => false
  attr_accessible :name_first, :name_last, :phone, :email, :password, :password_confirmation, :remember_me, :admin, :flagged, :residence
  validates_inclusion_of :residence, :in => [ "Adams","Kirkland", "Lowell", "Leverett", "Mather", "Quincy", "Dunster", "Winthrop", "Eliot", "Pforzheimer", "Currier", "Cabot", "The Yard", "Off Campus", "Dudley (Co-Op)", nil ]
  
  # def membership_level
  #     membership.level
  #   end
  
  def active?
    membership && membership.active
  end
  
  def admin?
    admin
  end
  
  def confirmed?
    !confirmed_at.nil?
  end
  
  def confirm
    update_attribute(:confirmed_at, Time.now)
  end
  
  def fullname
    "#{name_last}, #{name_first}"
  end
  
  class << self
    
    def retrieve user = OpenStruct.new(:admin? => false)
      # user.admin? ? all : operational
      all
    end
    def search query = nil
      if query
        regex_query = Regexp.new(query, true)
        any_of({:name_first => regex_query}, {:name_last => regex_query}, {:email => regex_query})
      else
        all
      end
    end 
  end
end
# 
# class Permission
#   include Mongoid::Document
#   
#   embedded_in :user
# end