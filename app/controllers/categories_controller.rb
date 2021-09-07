class CategoriesController < ApplicationController
  load_and_authorize_resource
  before_action :load_category, except: %i(index new create)

  def index
    @search = Category.ransack(params[:q])
    @search.sorts = Category::SORTS if @search.sorts.empty?
    @categories = @search.result.page(params[:page]).per Settings.validation.num
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    respond_to do |format|
      if @category.save
        format.html do
          redirect_to @category
          flash[:success] = t(".create_success")
        end

      else
        format.html do
          redirect_to @category
          flash[:danger] = t(".create_fail")
        end
      end
    end
  end

  def show; end

  def edit; end

  def update
    respond_to do |format|
      if @category.update category_params
        format.html do
          redirect_to @category
          flash[:success] = t(".edit_success")
        end
      else
        format.html do
          redirect_to @category
          flash[:danger] = t(".edit_fail")
        end
      end
    end
  end

  def destroy
    flash[:success] = t ".category_delete" if @category&.destroy
    redirect_to @category
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def load_category
    @category = Category.find params[:id]
  end
end
