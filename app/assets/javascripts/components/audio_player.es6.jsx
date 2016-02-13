class AudioPlayer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      playing: false
    };

    this.setVolumeFn = this.setVolume.bind(this);
  }

  componentDidMount() {
    setInterval(this.updateProgressBar.bind(this), 1000);
    this.setVolume(1);
  }

  setVolume(value) {
    // Perceptual volume
    let adjustedVolume = (Math.pow(10, value) - 1) / (10 - 1);
    adjustedVolume = Math.max(0, Math.min(1, adjustedVolume));
    this.volume = adjustedVolume;
    this.refs.audioObject.volume = adjustedVolume;
  }

  timeFrom(time, offset) {
    const parsed = Date.parse(time) + offset;
    return Date.now() - parsed;
  }

  handlePlayButtonClick() {
    if (this.state.playing) {
      // Can't stop a live stream, thank HTML5 and sorry mobile users!
      this.refs.audioObject.pause();
      const premuteVolume = this.refs.audioObject.volume;
      this.setVolume(0);
      this.volume = premuteVolume;
      this.setState({ playing: false });
    } else {
      this.refs.audioObject.play();
      this.setVolume(this.volume);
      this.setState({ playing: true });
    }
  }

  updateProgressBar() {
    let position;
    if (this.props.nowPlaying && this.props.nowPlaying.start_time) {
      position = this.timeFrom(this.props.nowPlaying.start_time, this.props.timeOffset) / 1000;
    } else {
      position = 0;
    }

    this.setState({ position });
  }

  render() {
    const audio = React.DOM.div({ className: 'audio-player-element' },
      React.DOM.audio({ ref: 'audioObject', preload: 'none' },
        React.DOM.source({ src: this.props.source, type: 'audio/ogg' })
      )
    );

    const playButtonLabel = this.state.playing ? '🔇' : '▶'; // mute, play
    const playButton = React.DOM.div({
      className: `play-button-${this.state.playing}`,
      onClick: this.handlePlayButtonClick.bind(this),
      title: this.state.playing ? 'Click to mute' : 'Click to play'
    },
      React.DOM.p(null, playButtonLabel)
    );

    return (
      <div className="audio-player">
        <div className="controls">{playButton}</div>
        <StreamProgressBar value={this.state.position} max={this.props.nowPlaying.duration} />
        <div className="below-bar">
          <Slider min={0} max={100} initial={100} onChange={this.setVolumeFn} />
          <TimeInfo position={this.state.position} duration={this.props.nowPlaying.duration} />
        </div>
        {audio}
      </div>
    );
  }
}

AudioPlayer.propTypes = {
  source: React.PropTypes.string,
  nowPlaying: React.PropTypes.object,
  timeOffset: React.PropTypes.number
};
