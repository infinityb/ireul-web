class BackgroundImagesController < ApplicationController
  def new
    @song = Song.find(params[:song_id])
    @image = BackgroundImage.new
  end

  def create
    @song = Song.find(params[:background_image][:song_id])
    @image = BackgroundImage.create(song: @song, image: image_params[:image])

    respond_to do |format|
      if @image.save
        format.html { redirect_to @song, notice: "Image created for song ##{@song.id}" }
        format.json { head :created }
      else
        format.html { render :new }
        format.json { head :bad_request }
      end
    end
  end

  def destroy
    @image = BackgroundImage.find(params[:id])
    @song = Song.find(@image.song_id)

    begin
      @image.destroy
      flash[:notice] = "Image ##{@image.id} was deleted."
    rescue Exception => e
      flash[:notice] = e.message
    end

    redirect_to @song
  end

  private

  def image_params
    params.require(:background_image).permit(:image)
  end
end
