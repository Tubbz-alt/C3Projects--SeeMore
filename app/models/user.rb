class User < ActiveRecord::Base
  # Associations
  has_and_belongs_to_many :subscriptions
  has_many :posts, through: :subscriptions

  # Validations
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid

  def self.find_or_create_user(auth_hash)
    uid = auth_hash["uid"]
    provider = auth_hash["provider"]

    user = User.where(uid: uid, provider: provider).first_or_initialize
    user.email = auth_hash["info"]["email"]
    user.name = auth_hash["info"]["name"]
    user.image = auth_hash["info"]["image"]

    return user.save ? user : nil
  end

  # Adds the association between a new subscription and the user.
  # def associate_subscription(subscription)
  #   if subscription.class == TwiSubscription
  #     self.twi_subscriptions << subscription
  #   else
  #     self.ig_subscriptions << subscription
  #   end
  #   self.save
  # end

end
