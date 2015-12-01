class RadioController < ApplicationController
  def index
  end

  def skip
    IreulWeb::Application.ireul_client.fast_forward(:track_boundary)
    render json: { status: :ok, action: :skip, time: Time.now.utc }
  rescue IreulService::IreulConnError
    render json: { status: :failure, action: :skip, time: Time.now.utc }
  end

  def enqueue
    song = Song.find(params[:id])
    oggfile = open(song.file.path, 'rb')
    oggbuf = oggfile.read()
    oggfile.close()
    IreulWeb::Application.ireul_client.enqueue(oggbuf)

    render json: { status: :ok, action: :enqueue, time: Time.now.utc }
  rescue IreulService::IreulConnError
    render json: { status: :failure, action: :enqueue, time: Time.now.utc }
  end

  def song_params
    params.require(:song).permit(:song_id)
  end
end
