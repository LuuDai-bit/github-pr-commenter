class ApplicationController < ActionController::API
  include Pagy::Method

  private

  def pagy_metadata(pagy)
    {
      page: pagy.page,
      per_page: params[:per_page],
      total_pages: pagy.pages,
      total_count: pagy.count
    }
  end
end
