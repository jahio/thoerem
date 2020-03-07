require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  describe "authentication" do
    it "authenticates the user with the right u/p" do
      post :login, params: { username: "admin", password: "lolpassword" }
      expect(response).to redirect_to(:dashboard)
    end

    it "doesn't authenticate w/ the wrong password" do
      post :login, params: { username: "admin", password: "asdf" }
      expect(response).to redirect_to(:auth)
    end

    it "doesn't authenticate w/ the wrong username" do
      post :login, params: { username: "asdf", password: "lolpassword" }
      expect(response).to redirect_to(:auth)
    end
  end
end