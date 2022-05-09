class UsersController < ApplicationController

	def edit; end

	def update
		if current_user.update(user_params)
			redirect_to current_user
		else
			render :edit, status: :unprocessable_entity
		end
	end

	private
		def user_params
			params.require(:user).permit(:name, :about, :image)
		end


end