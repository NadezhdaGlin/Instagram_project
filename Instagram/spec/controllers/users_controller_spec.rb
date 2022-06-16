require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

	let(:user) {User.create!(name: "June", email: "june@gmail.com", password: "123456")}
	before {sign_in user}

	describe "#index" do
	subject(:index) {get :index}
	let(:user1) {User.create!(name: "Flora", email: "september@gmail.com", password: "123456")}
	let(:user2) {User.create!(name: "Jinx", email: "riot@gmail.com", password: "123456")}

		it "show all users without current user" do
			index
			expect(assigns(:users)).to match_array([user1, user2])
		end

		it "response 200" do
			expect(index).to have_http_status(200)
		end

		context "when user is unauthorized" do
		before { sign_out user }
			it "the inability to return the users" do
				index
				expect(assigns(:users)).to eq(nil)
			end

			it "to redirects to the login page" do
				expect(index).to redirect_to(new_user_session_path)
			end

			it "response 302" do
				expect(index).to have_http_status(302)
			end
		end
	end

	describe "#show" do
		subject(:show_user) {get :show, params: {id: user.id}}
		it "show user" do
			show_user
			expect(assigns(:user)).to eq(user)
		end

		it "response 200" do
			expect(show_user).to have_http_status(200)
		end

		context "when user is unauthorized" do
		before { sign_out user }
			it "the inability to return the user" do
				show_user
				expect(assigns(:users)).to eq(nil)
			end

			it "redirects to the login page" do
				expect(show_user).to redirect_to(new_user_session_path)
			end

			it "response 302" do
				expect(show_user).to have_http_status(302)
			end
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

		it "redirect to user" do
			expect(update_user).to redirect_to(user_path(user.id))
		end

		it "response 302" do
				expect(update_user).to have_http_status(302)
			end

		context "when user is unauthorized" do
		before { sign_out user }
			it "the inability to update the user" do
				expect{update_user}.not_to change(user.reload, :name) 
			end

			it "redirects to the login page" do
				expect(update_user).to redirect_to(new_user_session_path)
			end

			it "response 302" do
				expect(update_user).to have_http_status(302)
			end
		end
	end

end