require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
	let(:user) {User.create!(name: "June", email: "june@gmail.com", password: "123456")}
	before {sign_in user}

	describe "#index" do

	let(:user1) {User.create!(name: "Flora", email: "september@gmail.com", password: "123456")}
	let(:user2) {User.create!(name: "Jinx", email: "riot@gmail.com", password: "123456")}

		it "show all users without current user" do
			get :index
			expect(assigns(:users)).to match_array([user1, user2])
		end
	end

	describe "#show" do
		subject(:show_user) {get :show, params: {id: user.id}}
		it "show user" do
			show_user
			expect(assigns(:user)).to eq(user)
		end
	end

	describe "#update" do
		let!(:user_params) { 
			{ user: { name: "Pink"},id: user.id } 
		}
		subject(:update_user) { patch :update, params: user_params}
		it "update user" do
			expect{update_user}.to(change{user.reload.name}.to("Pink"))
		end
	end

end