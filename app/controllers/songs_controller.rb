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
    @song = Song.new(autofill_vorbis_comments(song_params()))
    # artist = Artist.find_by(name: params["song"]["artist"])
    # @song.artist = artist

    respond_to do |format|
      if @song.save
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
    # TODO: move out into metadata table
    # HACK: can break anytime
    @query = params.require(:query).force_encoding('UTF-8')
    head :ok if @query.nil?
    @songs = Song.where("metadata LIKE ?", "%#{@query}%")

    respond_to do |format|
      format.html { render :search }
      format.json { render json: @songs }
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

