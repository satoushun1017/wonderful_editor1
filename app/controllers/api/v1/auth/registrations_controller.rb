class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  private

    def sign_up_params
      # binding.pry
      params.permit(:name, :email, :password, :password_confirmation)
      # params.permit(:name, :nickname, :email, :img, :password, :password_confirmation)
    end

    def account_update_params
      params.permit(:name, :email)
    end
end
