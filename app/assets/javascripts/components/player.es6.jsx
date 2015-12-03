class Player extends React.Component {
  constructor (props) {
    super(props);
    this.state = {
      nowPlaying: {
        artist: "yana",
        title: "Fall In The Dark"
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
      React.DOM.div(null, this.state.nowPlaying.artist),
      React.DOM.div(null, "—"),
      React.DOM.div(null, this.state.nowPlaying.title)
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
