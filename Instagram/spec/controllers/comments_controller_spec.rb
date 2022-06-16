require 'rails_helper'

RSpec.describe CommentsController, :type => :controller do
	let(:user) {User.create!(name: "June", email: "june@gmail.com", password: "123456")}
	let(:image) {fixture_file_upload('spec/fixtures/images/rails.png','image/png')}
	let!(:post1) {Post.create!(description: "for test1", image: image, user: user)}

	before {sign_in user}

	describe "#create" do
		let!(:comment_params){
			{comment: {body:"comment for test", user: user}, post_id: post1.id}
		}

		let!(:another_comment_params){
			{comment: {body:"", user: user}, post_id: post1.id}
		}

		subject(:create_comment) {post :create, params: comment_params}

		it "create comment" do
			expect{create_comment}.to change(Comment, :count).by(1) 
		end

		it "redirect to post" do
			expect(create_comment).to redirect_to(post_path(Post.last))
		end

		it "when the comment is not created" do
			expect{create_comment}.to change(Comment, :count)
		end

		it "response 302" do
			expect(create_comment).to have_http_status(302)
		end

		context "when user is unauthorized" do
		before { sign_out user }
			it "does not create comment" do
				expect{create_comment}.not_to change(Comment, :count)
			end

			it "redirects to the login page" do
				expect(create_comment).to redirect_to(new_user_session_path)
			end

			it "response 302" do
				expect(create_comment).to have_http_status(302)
			end
		end
	end

	describe "#destroy" do
		let!(:comment) {Comment.create!(body:"comment", user: user, post_id: post1.id)}
		subject(:destroy_comment) {delete :destroy, params: {post_id: post1.id, id: comment.id}}

		it "destroy comment" do
			expect{destroy_comment}.to change(Comment, :count).by(-1)
		end

		it "redirect to post" do
			expect(destroy_comment).to redirect_to(post_path(Post.last))
		end

		it "response 302" do
			expect(destroy_comment).to have_http_status(302)
		end

		context "when user is unauthorized" do
		before { sign_out user }
			it "does not destroy comment" do
				expect{destroy_comment}.not_to change(Comment, :count)
			end

			it "redirects to the login page" do
				expect(destroy_comment).to redirect_to(new_user_session_path)
			end

			it "response 302" do
				expect(destroy_comment).to have_http_status(302)
			end
		end
	end

end