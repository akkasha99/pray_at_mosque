class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  belongs_to :role
  has_many :children, :class_name => "User", :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "User"

  has_one :family_code, :dependent => :destroy
  has_one :payment_information, :dependent => :destroy
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  has_attached_file :avatar, :url => '/system/:attachment/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/system/:attachment/:id/:style/:basename.:extension',
                    :styles => {:medium => '250x250#', :thumb => '150x150#', :icon => '25x25#', :other => '640x563#'}
  validates_attachment :avatar, :content_type => {:content_type => ["image/jpg", "image/jpeg", "image/png"]}

  def admin?
    self.role.name == "super_admin"
  end

  def parent?
    self.role.name == "parent"
  end

  def child?
    self.role.name == "child"
  end

  def mosque?
    self.role.name == "mosque"
  end

  def self.find_for_facebook_oauth(auth, role, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        # email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
        email = auth.info.email # if email_is_verified
        user_role = Role.where(:name => role).first
        user = User.create(first_name: auth.extra.raw_info.name,
                           provider: auth.provider,
                           uid: auth.uid,
                           email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
                           password: Devise.friendly_token[0, 20],
                           avatar: process_uri(auth.info.image),
                           :role_id => user_role.id
        )
        FamilyCode.create(:code => SecureRandom.hex(4), :user_id => user.id) if role == "parent"
        create_customer_on_braintree(user)
        return user
      end

    end
  end

  def self.find_for_google_oauth2(access_token, role, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => access_token.info.email).first
      if registered_user
        return registered_user
      else
        photo = URI.parse(data["image"]) if data.image?
        user_role = Role.where(:name => role).first
        user = User.create(first_name: data["name"],
                           provider: access_token.provider,
                           email: data["email"],
                           uid: access_token.uid,
                           password: Devise.friendly_token[0, 20],
                           avatar: photo,
                           :role_id => user_role.id
        )
        FamilyCode.create(:code => SecureRandom.hex(4), :user_id => user.id) if role == "parent"
        create_customer_on_braintree(user)
        return user
      end
    end
  end

  def self.find_for_twitter_oauth(auth, role, signed_in_resource=nil)

    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.uid + "@twitter.com").first
      if registered_user
        return registered_user
      else
        photo = URI.parse(auth.info["image"]) if auth.info.image?
        user_role = Role.where(:name => role).first
        user = User.create(first_name: auth.info.name,
                           provider: auth.provider,
                           uid: auth.uid,
                           email: auth.uid+"@twitter.com",
                           password: Devise.friendly_token[0, 20],
                           avatar: photo,
                           :role_id => user_role.id
        )
        FamilyCode.create(:code => SecureRandom.hex(4), :user_id => user.id) if role == "parent"
        create_customer_on_braintree(user)
        return user
      end
    end
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def self.process_uri(uri)
    avatar_url = URI.parse(uri)
    avatar_url.scheme = 'https'
    avatar_url.to_s
  end

  def self.create_customer_on_braintree(user)
    result = Braintree::Customer.create(
        :first_name => user.first_name,
        :last_name => user.last_name,
        :email => user.email
    )
    # puts "----------Brain tree result----------", result.inspect
    if result.success?
      puts "44444444444444444444444444444444444", result.inspect
      user.update_attributes(:customer_id => result.customer.id)
      return true
    else
      # puts "55555555555555555555555555555555555", result.inspect
      puts "---------brain tree customer create error-----------", result.errors
      @user_errors = result.errors
      return false
    end
  end

  def active_for_authentication?
    super && self.is_active? # i.e. super && self.is_active
  end

  def inactive_message
    "Sorry, this account has been deactivated."
  end

end
