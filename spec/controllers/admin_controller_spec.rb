require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  describe "authentication" do
    it "authenticates the user with the right u/p" do
      post :login, params: { username: "admin", password: "lolpassword" }
      expect(response).to be_redirect
    end

    it "doesn't authenticate w/ the wrong password" do
    end

    it "doesn't authenticate w/ the wrong username" do
    end
  end
end