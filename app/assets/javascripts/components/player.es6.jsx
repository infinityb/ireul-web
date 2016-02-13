class Player extends React.Component {
  render() {
    const playerStyle = {
      className: 'radio-player',
      style: {
        flex: 1,
        alignSelf: 'center'
      }
    };

    const audioPlayer = React.createElement(AudioPlayer, {
      source: `${this.props.audioSrc}?${Date.now()}`,
      crossOrigin: 'anonymous',
      nowPlaying: this.props.nowPlaying
    });

    const nowPlaying = React.DOM.div({ className: 'now-playing' },
      React.DOM.div({ className: 'title' }, this.props.nowPlaying.title),
      React.DOM.div({ className: 'artist' }, this.props.nowPlaying.artist)
    );

    return React.DOM.div(
      playerStyle,
      audioPlayer,
      nowPlaying
    );
  }
}

Player.propTypes = {
  audioSrc: React.PropTypes.string,
  nowPlaying: React.PropTypes.object
};
