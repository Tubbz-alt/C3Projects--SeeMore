class FeedsController < ApplicationController

  def index
    @user = User.find_by(id: session[:user_id])
    if @user
      @people = []
      @people << Instagram.find(@user.instagram_ids)
      @people << Tweet.find(@user.tweet_ids)
      @people.flatten!
      @people.sort_by! { |person| person.username.downcase }

      @feed = []
      @people.each do |person|
        username = person.username
        @feed << @twitter.client.user_timeline(username, count: 10)
        @feed.flatten!
        @feed.sort_by { |tweet| tweet.created_at.strftime("%m/%d/%Y") }
      end
    end
  end

  def search; end

  def people
    @user = User.find_by(id: session[:user_id])
    if @user
      @people = Instagram.find(@user.instagram_ids) +  Tweet.find(@user.tweet_ids)
    end
  end

end
