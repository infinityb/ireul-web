class Player extends React.Component {
  constructor (props) {
    super(props);
    this.state = {
      nowPlaying: {
        artist: "MACINTOSH Plus",
        title: "Eccoと悪寒ダイビング龍龙"
      }
    };
  }

  render () {
    let audio = React.DOM.div({ className: "audio-player" },
      React.DOM.audio({ ref: "audioObject", controls: "yes" },
        React.DOM.source({ src: this.props.audioSrc, type: "audio/ogg" })
      )
    );

    let nowPlaying = React.DOM.div({ className: "now-playing" },
      React.DOM.div({ className: "title" }, this.state.nowPlaying.title),
      React.DOM.div({ className: "artist" }, this.state.nowPlaying.artist)
    );

    return React.DOM.div(playerStyle,
      audio,
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
