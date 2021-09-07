require "rails_helper"
include SessionsHelper

RSpec.describe UsersController, type: :controller do
  let(:user){FactoryBot.create :user}
  let(:params) {{id: user.id}}

  describe "GET /index" do
    context "when go to job index page" do
      before do
        get :index
      end

      it "should redirect to user_url" do
        expect(response.response_code).to eq 200
      end
    end
  end

  describe "GET /show" do
    context "when user do not exist" do
      before do
        get :show, params: {id: 1}
      end

      it "should redirect to root_path" do
        expect(response).to redirect_to root_url
      end
    end

    context "when user do exist" do
      before do
        get :show, params: {id: user.id}
      end

      it "should redirect to user page" do
        expect(assigns(:user)).to eq user
      end
    end
  end

  describe "GET /new" do
    before do
      get :new
    end

    it "should redirect to new_user_path" do
      expect(response.response_code).to eq 200
    end
  end

  describe "POST /create" do
    let!(:user_count){User.count}

    context "when job information is valid" do
      before do
        post :create, params: {user: { "name": "Vinh", email: "test@gmail.com", password: "123456" }}
      end

      it "increase number of user by 1" do
        expect(User.count).to eq(user_count + 1)
      end

      it "should redirect to user page" do
        new_user = assigns(:user)
        expect(response).to redirect_to new_user
      end

      it "should flash success" do
        expect(flash[:success]).to eq I18n.t("users.create.welcome_to_library!")
      end
    end

    context "when params is invalid" do
      before do
        post :create, params: {user: { "name"=>"name" }}
      end

      it "don't change number of user" do
        expect(User.count).to eq(user_count)
      end
    end
  end
end
