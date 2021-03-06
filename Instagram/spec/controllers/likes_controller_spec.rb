require 'rails_helper'

RSpec.describe LikesController, :type => :controller do
	let(:user) {User.create!(name: "June", email: "june@gmail.com", password: "123456")}
	let(:image) {fixture_file_upload('spec/fixtures/images/rails.png','image/png')}
	let!(:post1) {Post.create!(description: "for test1", image: image, user: user)}
	
	
	before {sign_in user}
	describe "#create" do
		subject(:create_like) {post :create, params: {format: post1.id}}

		it "create like" do
			expect{create_like}.to change(Like, :count).by(1)
		end

		it "redirect to post" do
			expect(create_like). to redirect_to(post_path(Post.last))
		end

		it "response 302" do
				expect(create_like).to have_http_status(302)
		end

		context "when user is unauthorized" do
		before { sign_out user }

			it "does not create like" do
				expect{create_like}.not_to change(Like, :count)
			end

			it "response 401" do
				expect(create_like).to have_http_status(401)
			end
		end		
	end

	describe "#destroy" do
		let!(:like) {Like.create(user: user, post: post1)}
		subject(:destroy_like) {delete :destroy, params: {id: post1.id}}

		it "destroy like" do
			expect{destroy_like}.to change(Like, :count).by(-1)
		end

		it "redirect to post" do
			expect(destroy_like). to redirect_to(post_path(Post.last))
		end

		it "response 302" do
			expect(destroy_like).to have_http_status(302)
		end

		context "when user is unauthorized" do
		before { sign_out user }

			it "does not destroy like" do
				expect{destroy_like}.not_to change(Like, :count)
			end
			
			it "response 302" do
				expect(destroy_like).to have_http_status(302)
			end
		end		
	end
end