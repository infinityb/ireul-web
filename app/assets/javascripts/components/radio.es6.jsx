class Radio extends React.Component {
  constructor (props) {
    super(props);
  }

  render () {
    return React.DOM.div(style,
      React.DOM.div(null,
        React.createElement(Queue, { songs: [React.createElement(Song, { artist: "lmao", title: "lmbo" })] }),
        React.createElement(RadioSkipButton, { httpMethod: "post", radioMethod: "/radio/skip", label: "Skip" } )
      ),
      React.DOM.div(null,
        React.createElement(SongLibrary)
      )
    );
  }
}

var style = {
  display: "flex",
  flexDirection: "column"
};
