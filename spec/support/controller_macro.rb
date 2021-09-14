module ControllerMacro
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      admin = FactoryBot.create :admin
      sign_in admin
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryBot.create :user
      sign_in user
    end
  end
end
