class Player extends React.Component {
  constructor (props) {
    super(props);
  }

  render () {
    return React.DOM.div(null,
      React.DOM.audio({ ref: "audioObject", controls: "yes" },
        React.DOM.source({ src: this.props.audioSrc, type: "audio/ogg" })
      )
    );
  }
}
