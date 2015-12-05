class Player extends React.Component {
  render () {
    let audioPlayer = React.createElement(AudioPlayer, { source: "http://lollipop.hiphop:8000/ireul", crossOrigin: "anonymous" });

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
      elapsedTime: 70,
      totalTime: 100,
      playing: false,
      source: props.source
    };
  }

  componentDidMount () {

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

  render () {
    let playButtonLabel = this.state.playing ? "🔇" : "▶"; // mute, play
    let audio = React.DOM.div({ className: "audio-player-element" },
      React.DOM.audio({ ref: "audioObject" },
        React.DOM.source({ src: this.props.source, type: "audio/ogg" })
      )
    );

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
        <progress value={this.state.elapsedTime} max={this.state.totalTime}></progress>
        <div className="time-info">{audio} {this.state.elapsedTime} {this.state.totalTime}</div>
      </div>
    );
  }
}
