class UsersController < ApplicationController

	def index
		@users = User.where.not(id: current_user)
	end

	def edit; end

	def show
		@user = User.find(params[:id])
	end

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