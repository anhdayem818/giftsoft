class InstructionsController < Spree::BaseController
  def index
    @instructions = Instruction.all
  end
end
