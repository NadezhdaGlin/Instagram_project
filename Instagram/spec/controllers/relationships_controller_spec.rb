require 'rails_helper'

RSpec.describe RelationshipsController, :type => :controller do
	let(:user1) {User.create!(name: "June", email: "june@gmail.com", password: "123456")}
	let(:user2) {User.create!(name: "Flora", email: "september@gmail.com", password: "123456")}
	
	before {sign_in user1}
	describe "#create" do
		subject(:create_relationship) {post :create, params: {followed_id: user2.id}}
		it "create relationship" do
			expect{create_relationship}.to change(Relationship, :count).by(1)
		end
		it "redirect to user" do
			expect(create_relationship).to redirect_to(user_path(user2))
		end
	end

	describe "#destroy" do
		let!(:relationship) {Relationship.create!(follower_id: user1.id, followed_id: user2.id)}
		subject(:destroy_relationship) {delete :destroy, params: {id: relationship.id}}
		it "destoy relationship" do
			expect{destroy_relationship}.to change(Relationship, :count).by(-1)
		end
		it "redirect to user" do
			expect(destroy_relationship).to redirect_to(user_path(user2))
		end
	end
end