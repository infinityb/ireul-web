class MetadatumController < ApplicationController
  def new
    @metadata = Metadatum.new
    @song = Song.find(params[:song_id])
  end

  def create
    @metadata = Metadatum.new
    @song = Song.find(params[:metadatum][:song_id])

    if params[:metadatum][:metadata_field_id].blank?
      @metadata.errors[:metadata_field] << "is missing"
    else
      field = MetadataField.find(params[:metadatum][:metadata_field_id])

      @metadata = Metadatum.new(
        song: @song,
        metadata_field: field,
        value: params[:metadatum][:value].force_encoding('UTF-8')
      )
      saved = @metadata.save

      # Update FKs
      if saved
        if field.name == "ARTIST" && @song.artist_metadata_id == nil
          @song.artist_metadata_id = @metadata.id
          @song.save
        end

        if field.name == "TITLE" && @song.title_metadata_id == nil
          @song.title_metadata_id = @metadata.id
          @song.save
        end
      end
    end

    respond_to do |format|
      if saved
        format.html { redirect_to @song, notice: "#{field.name} created for song ##{@song.id}" }
        format.json { head :created }
      else
        format.html { render :new }
        format.json { head :bad_request }
      end
    end
  end

  def destroy
    @metadata = Metadatum.find(params[:id])
    field = MetadataField.find(@metadata.metadata_field_id)
    @song = Song.find(@metadata.song_id)

    # Update FKs, poorly
    if field.name == "ARTIST" && @song.artist_metadata_id == @metadata.id
      @song.artist_metadata_id = nil
      @song.save
    end

    if field.name == "TITLE" && @song.title_metadata_id == @metadata.id
      @song.title_metadata_id = nil
      @song.save
    end

    begin
      @metadata.destroy
      flash[:notice] = "Metadatum #{field.name}, ##{@metadata.id} was deleted."
    rescue Exception => e
      flash[:notice] = e.message
    end

    @metadata.destroy
    respond_to do |format|
      format.html { redirect_to @song }
      format.json { head :no_content }
    end
  end

  def edit
    @metadata = Metadatum.find(params[:id])
    @song = Song.find(@metadata.song_id)
    @field = MetadataField.find(@metadata.metadata_field_id)
  end

  def update
    @metadata = Metadatum.find(params[:id])
    @song = Song.find(@metadata.song_id)
    @field = MetadataField.find(@metadata.metadata_field_id)

    respond_to do |format|
      if @metadata.update(value: metadata_params[:value])
        format.html { redirect_to @song, notice: "#{@field.name} was successfully updated." }
        format.json { render :show, status: :ok, location: @song }
      else
        format.html { render :edit }
        format.json { render json: @metadata.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def metadata_params
    params.require(:metadatum).permit(:value)
  end
end
