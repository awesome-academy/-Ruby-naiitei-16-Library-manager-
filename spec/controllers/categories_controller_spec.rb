require "rails_helper"
include SessionsHelper

RSpec.describe CategoriesController, type: :controller do
  let(:admin){FactoryBot.create :user,email: "abc@gmail.com", role: "admin"}
  let(:user){FactoryBot.create :user}
  let!(:category_1){FactoryBot.create :category, name: "hi"}

  describe "GET #index" do
    context "when has category" do
      before{get :index}

      it "render template index" do
        expect(response).to render_template :index
      end
    end

    context "when don't have category" do
      before{get :index}

      it "render template index" do
        expect(response).to render_template :index
      end
    end
  end

  describe "POST #create" do
    context "When user is admin" do
      before do
        log_in admin
      end

      let!(:category_count){Category.count}

      context "when job information is valid" do
        before do
          post :create, params: {category: { "name": "hay"}}
        end

        it "When create successfully" do
          expect(Category.count).to eq(category_count + 1)
        end

        it "should redirect to category page" do
          new_category = assigns(:category)
          expect(response).to redirect_to new_category
        end

        it "should flash success" do
          expect(flash[:success]).to eq I18n.t("categories.create.create_success")
        end
      end

      context "when params is invalid" do
        before do
          post :create, params: {category: { "name"=>"" }}
        end

        it "don't change number of category" do
          expect(Category.count).to eq(category_count)
        end

        it "flash danger category invalid" do
          expect(flash[:danger]).to eq I18n.t("categories.create.create_fail")
        end

        it "render list category page" do
          list_category = assigns(:category)
          expect(response).to redirect_to list_category
        end
      end
    end
  end

  describe "PATCH #update" do
    context "When user is admin" do
      before do
        log_in admin
      end

      context "when update successfully" do
        before do
          patch :update, params: {id: category_1.id, category: {name: "wow"}}
          category_1.reload
        end

        it "flash update successfully" do
          expect(flash[:success]).to eq I18n.t("categories.update.edit_success")
        end

        it "should redirect to category page" do
          category = assigns(:category_1)
          expect(response).to redirect_to category_1
        end
      end

      context "when update failed" do
        before do
          patch :update, params: {id: category_1.id, category: { "name": ""}}
        end

        it "flash update fail" do
          expect(flash[:danger]).to eq I18n.t("categories.update.edit_fail")
        end

        it "render category page" do
          category = assigns(:category_1)
          expect(response).to redirect_to category_1
        end
      end
    end
  end

  describe "DELETE #detroy" do
    context "When user is admin" do
      let!(:category_count){Category.count}
      before do
        log_in admin
        delete :destroy, params: {id: category_1.id}
      end

      context "When destroy successfully" do
        it "destroy success" do
          expect(Category.count).to eq(category_count - 1)
        end

        it "should flash destroy success" do
          expect(flash[:success]).to eq I18n.t("categories.destroy.category_delete")
        end

        it "should redirect to category page" do
          category = assigns(:category)
          expect(response).to redirect_to category
        end
      end
    end
  end
end
