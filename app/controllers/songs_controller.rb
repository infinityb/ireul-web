class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy, :enqueue]

  # GET /songs
  # GET /songs.json
  def index
    @songs = Song.all
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
  end

  # GET /songs/new
  def new
    @song = Song.new
  end

  # GET /songs/1/edit
  def edit
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
    @song.destroy
    respond_to do |format|
      format.html { redirect_to songs_url, notice: 'Song was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /songs/1/enqueue
  def enqueue
    @song.enqueue()
    head :ok, content_type: 'text/html'
  end

  def self.comment_flatten(comments)
    out = Hash::new()
    comments.each do |k, v|
      if not v.empty?
        out[k] = v.first
      end
    end
    out
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end

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

