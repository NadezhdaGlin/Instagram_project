require 'rails_helper'
# require 'database_cleaner/active_record'

RSpec.describe PostsController, :type => :controller do
	
	let(:user) {User.create!(name: "June", email: "june@gmail.com", password: "123456")}
	let(:image) {fixture_file_upload('spec/fixtures/images/rails.png','image/png')}
	before {sign_in user}

	describe "#index" do
		let!(:post1) {Post.create!(description: "for test1", image: image, user: user)}
		let!(:post2) {Post.create!(description: "for test2", image: image, user: user)}
		let!(:post3) {Post.create!(description: "for test3", image: image, user: user)}
			it "returns all posts" do
			# binding.pry
			get :index
			expect(assigns(:posts)).to match_array([post1, post2, post3])
		end
	end

	describe "#show"do
	let!(:post) {Post.create!(description: "for test", image: image, user: user)}
		it "returns post" do
			get :show, params: {id: post}
		end
	end

	describe "#new" do
		it "assigns post" do
			get :new 
		end
	end

	describe "create" do
			it "create post" do
				post :create, 
			end
	end
end