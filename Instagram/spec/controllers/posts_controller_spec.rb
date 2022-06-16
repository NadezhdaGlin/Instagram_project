require 'rails_helper'
# require 'database_cleaner/active_record'

RSpec.describe PostsController, :type => :controller do
	
	let(:user) {User.create!(name: "June", email: "june@gmail.com", password: "123456")}
	let(:image) {fixture_file_upload('spec/fixtures/images/rails.png','image/png')}

	before {sign_in user}

	describe "#index" do
		subject(:index) {get :index}
		let!(:post1) {Post.create!(description: "for test1", image: image, user: user)}
		let!(:post2) {Post.create!(description: "for test2", image: image, user: user)}
		let!(:post3) {Post.create!(description: "for test3", image: image, user: user)}

			it "returns all posts" do
				index
				expect(assigns(:posts)).to match_array([post1, post2, post3])
			end

			it "response 200" do
				expect(index).to have_http_status(200)
			end

	context "when user is unauthorized" do
		before { sign_out user }
			it "the inability to return the posts" do
				index
				expect(assigns(:posts)).to eq(nil)
			end

			it "to redirects to the login page" do
				expect(index).to redirect_to(new_user_session_path)
			end

			it "response 302" do
				expect(index).to have_http_status(302)
			end
		end
	end

	describe "#show"do
	let!(:post) {Post.create!(description: "for test", image: image, user: user)}
	subject(:show) {get :show, params: {id: post}}

		it "returns post" do
			show
			expect(assigns(:post)).to eq(post)
		end

		it "response 200" do
				expect(show).to have_http_status(200)
		end

		context "when user is unauthorized" do
		before { sign_out user }

			it "the inability to return the post" do
				show
				expect(assigns(:post)).to eq(nil)
			end

			it "redirects to the login page" do
				expect(show).to redirect_to(new_user_session_path)
			end

			it "response 302" do
				expect(show).to have_http_status(302)
			end
		end
	end

	describe "#create" do
		let!(:post_params) { 
			{ post: { description: "something for create", image: image, user: user } } 
		}

		let!(:another_post_params) { 
			{ post: { description: "", image: image, user: user } } 
		}

		subject(:create_post) {post :create, params: post_params}
		subject(:create_post_with_incorrect_params) {post :create, params: another_post_params}

			it "create post" do
				expect{create_post}.to change(Post, :count).by(1) 
			end

			it "redirect to post page" do
				expect(create_post).to redirect_to(post_path(Post.last))
			end

			it "response 302" do
				expect(create_post).to have_http_status(302)
			end

			it "when the post is not saved" do
				expect{create_post_with_incorrect_params}.not_to change(Post,:count)
			end

			it "response 422" do
				create_post_with_incorrect_params
				expect(response).to have_http_status(422)
			end

		context "when user is unauthorized" do
		before { sign_out user }
			it "does not create post" do
				expect{create_post}.not_to change(Post, :count)
			end

			it "redirects to the login page" do
				expect(create_post).to redirect_to(new_user_session_path)
			end

			it "response 302" do
				create_post
				expect(response).to have_http_status(302)
			end
		end
	end

	describe "#update" do
		let!(:post1) {Post.create!(description: "old post", image: image, user: user)}

		let!(:post_params){
			{ post: {description: "updated post", image: image, user: user}, id: post1}
		}

		subject(:update_post) {patch :update, params: post_params}

		it "update post" do
			expect{update_post}.to(change{post1.reload.description}.to("updated post"))
		end

		it "response 302" do
			expect(update_post).to have_http_status(302)
		end

		context "when user is unauthorized" do
		before { sign_out user }
			it "does not update post" do
				expect{update_post}.not_to change(post1.reload, :description)
			end

			it "redirects to the login page" do
				expect(update_post).to redirect_to(new_user_session_path)
			end

			it "response 302" do
				update_post
				expect(response).to have_http_status(302)
			end
		end
	end

	describe "#destroy" do
		let!(:post) {Post.create!(description: "for destroy", image: image, user: user)}
		subject(:destroy_post) {delete :destroy, params: {id: post}}

		 it "destroy post" do
		 	 expect{destroy_post}.to change(Post, :count).by(-1)
		 end

		 it "response 302" do
				expect(destroy_post).to have_http_status(302)
			end

		 it "redirect to root path" do
		 	 expect(destroy_post).to redirect_to(root_path)
		 end

		 context "when user is unauthorized" do
		before { sign_out user }
			it "does not destroy post" do
				expect{destroy_post}.not_to change(Post, :count)
			end

			it "redirects to the login page" do
				expect(destroy_post).to redirect_to(new_user_session_path)
			end

			it "response 302" do
				destroy_post
				expect(destroy_post).to have_http_status(302)
			end
		end
	end
end