module Admin
  class BarcodesController < Spree::BaseController
    #require 'barby/barcode/data_matrix'
    require 'barby/barcode/code_39'
    require 'barby/outputter/html_outputter'
    require 'barby/outputter/png_outputter'
    #require 'barby/outputter/cairo_outputter'
    def show
      @variant = Spree::Variant.find(params[:id])
      render layout: false
    end
  end
end

