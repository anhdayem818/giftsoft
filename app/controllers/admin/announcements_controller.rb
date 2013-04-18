module Admin
class AnnouncementsController < Spree::BaseController
  # GET /articles
  # GET /articles.json
  def index
    @announcements = Announcement.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @announcements }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @announcement = Announcement.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @announcement }
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @announcement = Announcement.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @announcement }
    end
  end

  # GET /articles/1/edit
  def edit
    @announcement = Announcement.find(params[:id])
  end

  # POST /articles
  # POST /articles.json
  def create
    @announcement = Announcement.new(params[:announcement])

    respond_to do |format|
      if @announcement.save
        format.html { redirect_to main_app.admin_announcements_path, notice: 'Announcement was successfully created.' }
        format.json { render json: @announcement, status: :created, location: @announcement }
      else
        format.html { render action: "new" }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @announcement = Announcement.find(params[:id])

    respond_to do |format|
      if @announcement.update_attributes(params[:article])
        format.html { redirect_to main_app.admin_announcements_path, notice: 'Announcement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @announcement = Announcement.find(params[:id])
    @announcement.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end
end
end
