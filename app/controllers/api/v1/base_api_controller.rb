class Api::V1::BaseApiController < ApplicationController
  # current_user のダミーコード
  #   def current_user
  #     @current_user ||= User.first
  alias_method :current_user, :current_api_v1_user
  alias_method :authenticate_user!, :authenticate_api_v1_user!
  alias_method :user_signed_in?, :api_v1_user_signed_in?
  #   end
end
