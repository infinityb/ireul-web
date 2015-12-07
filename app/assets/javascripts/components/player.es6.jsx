class Player extends React.Component {
  render () {
    let audioPlayer = React.createElement(AudioPlayer, {
      source: "http://lollipop.hiphop:8000/ireul",
      crossOrigin: "anonymous",
      nowPlaying: this.props.nowPlaying
    });

    let nowPlaying = React.DOM.div({ className: "now-playing" },
      React.DOM.div({ className: "title" }, this.props.nowPlaying.title),
      React.DOM.div({ className: "artist" }, this.props.nowPlaying.artist)
    );

    return React.DOM.div(playerStyle,
      audioPlayer,
      nowPlaying
    );
  }
}

var playerStyle = {
  className: "radio-player",
  style: {
    flex: 1,
    alignSelf: "center"
  }
};

class AudioPlayer extends React.Component {
  constructor (props) {
    super(props);
    this.state = {
      playing: false
    };
  }

  componentDidMount () {
    setInterval(this.updateProgressBar.bind(this), 1000);
  }

  updateProgressBar () {
    let duration = this.props.nowPlaying.duration;
    let position;
    if (this.props.nowPlaying && this.props.nowPlaying.start_time) {
      position = this.timeFrom(this.props.nowPlaying.start_time) / 1000;
    } else {
      position = 0;
    }

    this.setState({ position: position });
  }

  handlePlayButtonClick () {
    if (this.state.playing) {
      // Can't stop a live stream, thank HTML5 and sorry mobile users!
      this.refs.audioObject.pause();
      this.refs.audioObject.volume = 0;
      this.setState({ playing: false });
    } else {
      this.refs.audioObject.play();
      this.refs.audioObject.volume = 1;
      this.setState({ playing: true });
    }
  }

  timeFrom (time) {
    let parsed = Date.parse(time);
    return Date.now() - parsed;
  }

  setVolume (value) {
    // Perceptual volume
    let adjustedVolume = (Math.pow(10, value) - 1) / (10 - 1);
    adjustedVolume = Math.max(0, Math.min(1, adjustedVolume));
    this.refs.audioObject.volume = adjustedVolume;
  }

  render () {
    let audio = React.DOM.div({ className: "audio-player-element", preload: "none" },
      React.DOM.audio({ ref: "audioObject" },
        React.DOM.source({ src: this.props.source, type: "audio/ogg" })
      )
    );

    let playButtonLabel = this.state.playing ? "🔇" : "▶"; // mute, play
    let playButton = React.DOM.div({
      className: "play-button-" + this.state.playing,
      onClick: this.handlePlayButtonClick.bind(this),
      title: this.state.playing ? "Click to mute" : "Click to play"
    },
      React.DOM.p(null, playButtonLabel)
    );

    return (
      <div className="audio-player">
        <div className="controls">{playButton}</div>
        <StreamProgressBar value={this.state.position} max={this.props.nowPlaying.duration} />
        <div className="below-bar">
          <Slider min={0} max={100} initial={100} onChange={this.setVolume.bind(this)} />
          <TimeInfo position={this.state.position} duration={this.props.nowPlaying.duration} />
        </div>
        {audio}
      </div>
    );
  }
}

class TimeInfo extends React.Component {
  sec_to_min_sec (total_seconds) {
    let pad = function (num, size) {
      var s = num + "";
      while (s.length < size) s = "0" + s;
      return s;
    };

    let minutes = Math.floor(total_seconds / 60);
    let seconds = pad(Math.floor(total_seconds - minutes * 60), 2);

    if (isNaN(minutes)) minutes = "0";
    if (isNaN(seconds)) seconds = "00";

    return minutes + ":" + seconds;
  }

  render () {
    return (
      <div className="time-info">{this.sec_to_min_sec(this.props.position)} {this.sec_to_min_sec(this.props.duration)}</div>
    );
  }
}

class StreamProgressBar extends React.Component {
  timeFrom (time) {
    let parsed = Date.parse(time);
    return Date.now() - parsed;
  }

  render () {
    let progressValueWidth = Math.min(100, (this.props.value / this.props.max) * 100) + "%";

    return (
      <div className="progress">
        <div className="value" style={{ width: progressValueWidth }}></div>
      </div>
    )
  }
}
