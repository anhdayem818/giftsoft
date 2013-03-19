module Admin
  class InstructionsController < Spree::BaseController
    def index
      @instructions = Instruction.all
    end
    def create
      @instruction = Instruction.new(params[:instruction])

      respond_to do |format|
        if @instruction.save
          format.html { redirect_to main_app.instructions_path, notice: 'Instruction was successfully created.' }
          format.json { render json: @instruction, status: :created, location: @instruction }
        else
          format.html { render action: "new" }
          format.json { render json: @instruction.errors, status: :unprocessable_entity }
        end
      end
    end
    def destroy
    end
    def edit
      @instruction = Instruction.find(params[:id])
    end
    def update
      @instruction = Instruction.find(params[:id])

      respond_to do |format|
        if @instruction.update_attributes(params[:instruction])
          format.html { redirect_to main_app.instructions_path, notice: 'Instruction was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @instruction.errors, status: :unprocessable_entity }
        end
      end
    end
    def new
      @instruction = Instruction.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @instruction }
      end
      
    end
  end
end
