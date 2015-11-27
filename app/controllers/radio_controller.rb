class RadioController < ApplicationController
  def index
  end

  def skip
    IreulWeb::Application.ireul_client.fast_forward(:track_boundary)
    head :ok, content_type: 'text/html'
  end
end
