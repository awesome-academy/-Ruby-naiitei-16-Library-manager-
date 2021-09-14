class RequestsController < ApplicationController
  load_and_authorize_resource
  before_action :check_login, only: %i(create success)
  before_action :check_borrowed_book, only: :create
  before_action :load_book, only: %i(create new)

  def index
    @q = current_user.requests.newest.ransack(params[:q])
    @requests = @q.result.page(params[:page]).per Settings.return_book
                                                          .page_limit
  end

  def edit
    @q = Request.newest.ransack(params[:q])
    @requests = @q.result.page(params[:page]).per Settings.return_book
                                                          .page_limit
  end

  def new
    @request = Request.new
  end

  def create
    @request = Request.new request_params.merge(book: @book,
                                                 user: current_user,
                                                 date_start: Time.current)
    if @request.save
      redirect_to success_path
    else
      flash.now[:danger] = t ".save_error"
      render :new
    end
  end

  def success; end

  def update
    @request = Request.find params[:request_id]
    @request.returned!
    redirect_to return_book_list_path
  end

  def not_returned
    @q = current_user.requests.not_returned.newest.ransack(params[:q])
    @requests = @q.result.page(params[:page]).per Settings.return_book
                                                          .page_limit
  end

  private

  def request_params
    params.require(:request).permit :date_end
  end

  def check_login
    return if user_signed_in?

    redirect_to home_path, flash: {danger: t(".please_login")}
  end

  def check_borrowed_book
    check_request = Request.find_by(book_id: params[:book_id],
                               user_id: current_user.id)
    return if check_request.nil? || check_request.returned?

    redirect_to user_books_path, flash: {danger: t(".already_borrowed")}
  end

  def load_book
    @book = Book.find params[:book_id]
  end
end
