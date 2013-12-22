module Admin
  class BarcodesController < Spree::BaseController
    #require 'barby/barcode/data_matrix'
    require 'barby/barcode/code_39'
    require 'barby/outputter/html_outputter'
    #require 'barby/outputter/cairo_outputter'
    def show
    end
  end
end

