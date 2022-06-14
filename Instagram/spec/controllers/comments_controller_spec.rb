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
	end

end