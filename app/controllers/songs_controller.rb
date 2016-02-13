class SongsController < ApplicationController
  skip_before_action :authorize, only: [:index, :search]
  # authorize2 is an alias for authorize and is used to work around a bug on
  # conditional skipping of filters
  before_action :authorize2, only: [:index, :search], unless: :json_request?

  # GET /songs
  # GET /songs.json
  def index
    @songs = Song.page(params[:page]).per(15)
    @page = params[:page]
    @page_count = @songs.total_pages

    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
    @song = Song.find(params[:id])
    @metadata = @song.metadatum
    @images = BackgroundImage.where(song_id: @song.id)
  end

  # GET /songs/new
  def new
    @song = Song.new
    @background_image = BackgroundImage.new
  end

  # GET /songs/1/edit
  def edit
    @song = Song.find(params[:id])
    @file = @song.file
    @images = BackgroundImage.where(song_id: @song.id)
  end

  # POST /songs
  # POST /songs.json
  def create
    respond_to do |format|
      if create_song
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
    @song = Song.find(params[:id])
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
      # TODO: FIX THIS, THIS IS SUPER INEFFICIENT
      song_ids = Metadatum.where('LOWER(value) LIKE LOWER(?)', "%#{@query}%").pluck(:song_id)
      matching_songs = Song.find(song_ids)
      paginated = Kaminari.paginate_array(matching_songs)
      @songs = paginated.page(params[:page]).per(15)
      @page = params[:page]
      @has_more = !@songs.last_page?
    else
      @songs = []
    end

    respond_to do |format|
      format.html
      format.json
    end
  end

  def create_song
    saved = false

    Song.transaction do
      Metadatum.transaction do
        BackgroundImage.transaction do
          @song = Song.create(song_params) # Need to assign @song an ID first
          metadatum = autofill_vorbis_comments(song_params)[:metadata]

          create_metadatum_records(metadatum)

          if params[:background_image]
            @image = BackgroundImage.create(song: @song, image: image_params[:image])
          end

          saved = @song.save
        end
      end
    end

    saved
  end

  def self.comment_flatten(comments)
    out = {}
    comments.each do |k, v|
      out[k] = v.first.force_encoding('UTF-8') unless v.empty?
    end
    out
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def song_params
    params.require(:song).permit(:file)
  end

  def image_params
    params.require(:background_image).permit(:image)
  end

  def autofill_vorbis_comments(params)
    ret = {}
    Ogg::Vorbis::Info.open(params[:file].path) do |f|
      ret[:metadata] = SongsController.comment_flatten(f.comments)
    end
    ret
  end

  def create_metadatum_records(metadatum)
    metadatum.each do |k, v|
      field = MetadataField.find_by_name(k)
      if field.blank?
        logger.info "#{params[:path]}: Skipping field #{k} as no MetadataField of #{k} was found"
        next
      end

      metadata = Metadatum.create(
        song: @song,
        metadata_field: field,
        value: v.force_encoding('UTF-8')
      )

      # Manually assign FKs for special fields
      # TODO: maybe kill these two FKs
      case field.name
      when 'ARTIST'
        @song.artist_metadata_id = metadata.id
      when 'TITLE'
        @song.title_metadata_id = metadata.id
        # TODO: Auto store image for song if it has one in the tags
        # when "METADATA_BLOCK_PICTURE"
      end
    end
  end

  def json_request?
    request.format.symbol == :json
  end
end
