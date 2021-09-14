require "rails_helper"
require "support/factory_bot"
require "support/devise"
include SessionsHelper
include AdminHelper

RSpec.describe BooksController, type: :controller do
  let(:author) { FactoryBot.create :author }
  let(:book) { FactoryBot.create :book, author_id: author.id }
  let(:review) { FactoryBot.create :review, user: user, reviewable_id: book.id }
  let(:admin) { FactoryBot.create :admin }
  let(:user) { FactoryBot.create :user }
  let(:review) { FactoryBot.create :review, user: user, reviewable_id: book.id }
  let(:category) { FactoryBot.create :category }

  describe "GET /index" do
    context "when go to job index page" do
      before do
        get :index
      end

      it "should redirect to book_url" do
        expect(response.response_code).to eq 200
      end
    end
  end

  describe "GET /show" do
    context "when user find book " do
      before do
        get :show, params: { id: book.id }
      end

      it "redirect to user book path" do
        expect(assigns(:book)).to eq book
      end
    end

    context "when find but book not exist " do
      before do
        get :show, params: { id: -1 }
      end

      it "flash danger not found" do
        expect(flash[:danger]).to eq I18n.t("books.not_found")
      end

      it "redirect to root path" do
        expect(response).to redirect_to root_path
      end
    end

    context "when find book which has rate" do
      before do
        book.reviews.push(review)
        get :show, params: { id: book.id }
      end

      it "redirect to user book path" do
        expect(assigns(:book)).to eq book
      end
    end
  end

  describe "GET #new" do
    context "when admin logged in" do
      login_admin
      before do
        get :new
      end

      it { expect(assigns(:book)).to be_a_new(Book) }

      it { expect(response).to render_template(:new) }
    end

    context "when user logged in" do
      login_user
      before do
        get :new
      end

      it "flash danger not found" do
        expect(flash[:danger]).to eq I18n.t("application.action_not_allowed")
      end

      it "redirect to root path" do
        expect(response).to redirect_to home_path
      end
    end
  end

  describe "POST #create" do
    login_admin
    let!(:book_count) { Book.count }

    context "with valid attributes" do
      before do
        category_id = []
        category_id.push(category.id)
        post :create, params: {
                        book: { "name": "Test", "detail": "Truyen nuoc ngoai",
                                "number_of_page": "100",
                                "author": author.name,
                                "category_ids": category_id },
                      }
      end

      it "increase number of book by 1" do
        expect(Book.count).to eq(book_count + 1)
      end

      it { expect(flash[:success]).to eq I18n.t("books.create.success") }

      it "should redirect to options_path" do
        expect(response).to redirect_to books_path
      end

      it "should save the correctly the suboption" do
        expect(Book.last.book_categories.first.category_id).to eq category.id
      end
    end

    context "with invalid book's attributes" do
      before do
        category_id = []
        category_id.push(category.id)
        post :create, params: {
                        book: { "name": "Test", "detail": "Truyen nuoc ngoai",
                                "number_of_page": "",
                                "author": "",
                                "category_ids": category_id },
                      }
      end

      it "number of book not change" do
        expect(Book.count).to eq(book_count)
      end

      it { expect(flash[:danger]).to eq I18n.t("books.create.failed") }

      it { expect(response).to render_template(:new) }
    end
  end

  describe "PATCH #update" do
    login_admin
    context "with valid attributes" do
      before do
        category_id = []
        category_id.push(category.id)
        patch :update, params: { "id": book.id, "locale": "vi",
                                book: { "name": "Test2", "detail": "Truyen nuoc ngoai",
                                        "number_of_page": "100",
                                        "author": author.name,
                                        "category_ids": category_id } }
      end

      it "book's name was change" do
        expect(Book.last.name).to eq("Test2")
      end

      it { expect(flash[:success]).to eq I18n.t("books.update.edit_success") }

      it "should redirect to options_path" do
        expect(assigns(:book)).to eq book
      end

      it "should save the correctly the suboption" do
        expect(Book.last.book_categories.first.category_id).to eq category.id
      end
    end

    context "with invalid book's attributes" do
      before do
        category_id = []
        category_id.push(category.id)
        patch :update, params: { "id": book.id, "locale": "vi",
                                book: { "name": "", "detail": "Truyen nuoc ngoai",
                                        "number_of_page": "100",
                                        "author": author.name,
                                        "category_ids": category_id } }
      end

      it { expect(flash[:danger]).to eq I18n.t("books.update.edit_failed") }

      it { expect(response).to render_template(:edit) }
    end
  end

  describe "DELETE #destroy" do
    login_admin
    context "destroy successfully" do
      it do
        book
        expect { delete :destroy, params: { id: book } }.to change { Book.count }.by(-1)
      end

      it do
        delete :destroy, params: { id: book, format: :html }
        expect(flash[:success]).to eq I18n.t("books.destroy.success_delete")
      end

      it do
        delete :destroy, params: { id: book, format: :html }
        expect(response).to redirect_to books_path
      end
    end

    context "destroy failed" do
      before do
        allow_any_instance_of(Book).to receive(:destroy).and_return(false)
        delete :destroy, params: { id: book.id, format: :html }
      end

      it do
        expect(flash[:danger]).to eq I18n.t("books.destroy.fail_delete")
      end

      it do
        expect(assigns(:book)).to eq book
      end
    end
  end
end
