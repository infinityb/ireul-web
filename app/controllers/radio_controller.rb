class RadioController < ApplicationController
  def index
  end

  def skip
    IreulWeb::Application.ireul_client.fast_forward(:track_boundary)
    render json: { status: :ok }
  end

  def enqueue
    song = Song.find(params[:id])
    oggfile = open(song.file.path, 'rb')
    oggbuf = oggfile.read()
    oggfile.close()
    IreulWeb::Application.ireul_client.enqueue(oggbuf)

    render json: { status: :ok }
  end

  def song_params
    params.require(:song).permit(:song_id)
  end
end
