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

	context "when user is unauthorized" do
		before { sign_out user }
			it "the inability to return the posts" do
				index
				expect(assigns(:posts)).to eq(nil)
			end

			it "to redirects to the login page" do
				expect(index).to redirect_to(new_user_session_path)
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

		context "when user is unauthorized" do
		before { sign_out user }

			it "the inability to return the post" do
				show
				expect(assigns(:post)).to eq(nil)
			end

			it "to redirects to the login page" do
				expect(show).to redirect_to(new_user_session_path)
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
		subject(:create_post_without_save) {post :create, params: another_post_params}

			it "create post" do
				expect{create_post}.to change(Post, :count).by(1) 
			end

			it "redirect to post page" do
				expect(create_post).to redirect_to(post_path(Post.last))
			end

			it "when the post is not saved" do
				expect{create_post_without_save}.not_to change(Post,:count)
			end

			it "redirect to form" do
				expect(create_post_without_save).to redirect_to(new_post_path)
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
	end

	describe "#destroy" do
		let!(:post) {Post.create!(description: "for destroy", image: image, user: user)}
		subject(:destroy_post) {delete :destroy, params: {id: post}}

		 it "destroy post" do
		 	 expect{destroy_post}.to change(Post, :count).by(-1)
		 end

		 it "redirect to root path" do
		 	 expect(destroy_post).to redirect_to(root_path)
		 end
	end

end