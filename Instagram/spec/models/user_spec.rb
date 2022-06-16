require 'rails_helper'

RSpec.describe User, :type => :model do
	let!(:user1){User.create!(name: "Sera", email: "seraphine@gmail.com", password: "123456")}
	let!(:user2){User.create!(name: "June", email: "june@gmail.com", password: "123456")}

	describe "#follow" do
		it "create relationship" do
			user1.follow(user2)
			expect(user1.active_relationships.first.followed_id).to eq(user2.id)
		end
	end

	describe "#unfollow" do
		it "destroy relationship" do
			user1.follow(user2)
			expect{user1.unfollow(user2)}.to change(Relationship, :count).by(-1)
		end
	end

	describe "#following?" do
		it "check relationship" do
			expect(user1.active_relationships).to be_empty
		end
	end
end