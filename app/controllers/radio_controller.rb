class RadioController < ApplicationController
  def index
  end

  def skip
    IreulWeb::Application.ireul_client.fast_forward(:track_boundary)
    head :ok, content_type: 'text/html'
  end

  def enqueue
    song = Song.find(params[:id])
    oggfile = open(song.file.path, 'rb')
    oggbuf = oggfile.read()
    oggfile.close()
    IreulWeb::Application.ireul_client.enqueue(oggbuf)
    head :ok, content_type: 'text/html'
  end

  def song_params
    params.require(:song).permit(:song_id)
  end
end
