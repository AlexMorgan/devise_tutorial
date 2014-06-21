class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>",small: "50x50>", :tiny => "25x25>" }, :default_url => "/assets/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  ## If we wanted to validate that all users had an avatar
  # validates :avatar, :attachment_presence => true

  validates :username, presence: true, uniqueness: true
  validates_formatting_of :firstname, :using => :alpha
  validates_formatting_of :lastname, :using => :alpha
  validates_formatting_of :phone, :using => :us_phone, allow_nil: true

  has_many :books

  def self.years
    %w(Freshman Sophomore Junior Senior)
  end

  def fullname
    "#{firstname.capitalize} #{lastname.capitalize}"
  end

end
