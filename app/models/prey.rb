class Prey < ActiveRecord::Base
  has_and_belongs_to_many :stalkers
  has_many :posts

  validates :uid, :provider, presence: true

  after_create :seed_tweets

  def update_tweets
    Post.update_tweets(uid)
  end

  private

  def seed_tweets
    Post.seed_tweets(self.uid)
  end
end
