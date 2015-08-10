require 'twitter_client'

class Post < ActiveRecord::Base
  belongs_to :prey
  has_many :media

  validates :uid, :post_time, :prey_id, :url, :provider, presence: true

  # TWEETS --------------------------------------------------------------------

  def self.seed_tweets(prey_uid, count = 5)
    tweets = TwitterClient.fetch_tweets(prey_uid, { count: count })
    create_many_from_api(tweets)
  end

  def self.update_tweets(prey_uid)
    last_tweet_uid = Prey.find_by(uid: prey_uid).posts.last.uid
    tweets = TwitterClient.fetch_tweets(prey_uid, { since_id: last_tweet_uid })
    create_many_from_api(tweets)
  end

  def self.create_many_from_api(tweets)
    tweets.each do |tweet|
      post_id = Post.create(create_params_from_api(tweet)).id
      tweet.media.each do |medium|
        Medium.create(url: medium.media_url_https.to_s, post_id: post_id)
      end
    end
  end

  # GRAMS --------------------------------------------------------------------

  def self.seed_grams(user_uid)
    grams = InstagramClient.seed_grams(user_uid)
    create_many_grams_from_api(grams)
  end

  def self.create_many_grams_from_api(grams)
    #WIP
  end

  private

  def self.create_params_from_api(tweet)
    { uid: tweet.id,
      body:  tweet.text,
      post_time: tweet.created_at,
      prey_id: Prey.find_by(uid: tweet.user.id).id,
      url: tweet.url,
      provider: "twitter"
    }
  end
end
