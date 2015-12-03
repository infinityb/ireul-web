class Player extends React.Component {
  constructor (props) {
    super(props);
  }

  render () {
    let audio = React.DOM.div({ className: "audio-player" },
      React.DOM.audio({ ref: "audioObject", controls: "yes" },
        React.DOM.source({ src: this.props.audioSrc, type: "audio/ogg" })
      )
    );

    let nowPlaying = React.DOM.div({ className: "now-playing" },
      React.DOM.div({ className: "title" }, this.props.nowPlaying.title),
      React.DOM.div({ className: "artist" }, this.props.nowPlaying.artist)
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
