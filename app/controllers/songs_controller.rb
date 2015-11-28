class SongsController < ApplicationController
  # GET /songs
  # GET /songs.json
  def index
    @songs = Song.all
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
    @song = Song.find(params[:id])
    @metadata = @song.metadatum
  end

  # GET /songs/new
  def new
    @song = Song.new
  end

  # GET /songs/1/edit
  def edit
    @song = Song.find(params[:id])
  end

  # POST /songs
  # POST /songs.json
  def create
    saved = false
    @song = Song.new(song_params)

    Song.transaction do
      Metadatum.transaction do
        metadatum = autofill_vorbis_comments(song_params)[:metadata]
        @song.save # Need to assign @song an ID first

        metadatum.each do |k, v|
          field = MetadataField.find_by_name(k)
          if field.blank?
            logger.info "#{params[:path]}: Skipping field #{k} with value #{v} as no MetadataField of #{k} was found"
            next
          end

          metadata = Metadatum.create(song: @song, metadata_field: field, value: v.force_encoding('UTF-8'))

          # Manually assign FKs for special fields
          # TODO: maybe kill these two FKs
          case field.name
          when "ARTIST"
            @song.artist_metadata_id = metadata.id
          when "TITLE"
            @song.title_metadata_id = metadata.id
          end
        end

        saved = @song.save
      end
    end

    respond_to do |format|
      if saved
        format.html { redirect_to @song, notice: 'Song was successfully created.' }
        format.json { render :show, status: :created, location: @song }
      else
        format.html { render :new }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to @song, notice: 'Song was successfully updated.' }
        format.json { render :show, status: :ok, location: @song }
      else
        format.html { render :edit }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    respond_to do |format|
      format.html { redirect_to songs_url, notice: 'Song was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    @query = params.permit(:query)[:query].strip

    if !@query.blank?
      song_ids = Metadatum.where("value LIKE ?", "%#{@query}%").pluck(:song_id)
      @songs = Song.find(song_ids)
    else
      @songs = []
    end

    respond_to do |format|
      format.html
      format.json
    end
  end

  def self.comment_flatten(comments)
    out = Hash::new()
    comments.each do |k, v|
      if not v.empty?
        out[k] = v.first.force_encoding('UTF-8')
      end
    end
    out
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def song_params
      params.require(:song).permit(:file)
    end

    def autofill_vorbis_comments(params)
      Ogg::Vorbis::Info.open(params[:file].path) do |info|
        params[:metadata] = SongsController::comment_flatten(info.comments)
      end
      params
    end
end

