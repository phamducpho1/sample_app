class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost  = current_user.microposts.build
    @feed_items = Micropost.feed_user_id(current_user.id).paginate(page: params[:page])
  end

  def help; end

  def about; end

  def contact; end
end
