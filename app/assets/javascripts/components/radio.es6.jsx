class Radio extends React.Component {
  constructor (props) {
    super(props);
  }

  render () {
    return React.DOM.div({ className: "radio" },
      React.DOM.div({ className: "player-information-section" },
        React.createElement(Player, { audioSrc: "http://lollipop.hiphop:8000/ireul" }),
        React.DOM.div({ className: "queue-history"},
          React.createElement(Queue, { className: "history", title: "History", songs: [{ id: 1, artist: "lmao", title: "lmbo" }] }),
          React.createElement(Queue, { className: "queue", title: "Queue", songs: [{ id: 3, artist: "lmao", title: "lmbo" }] })
        )
      ),

      React.DOM.div({ className: "song-library-section" },
        React.createElement(SongLibrary)
      ),

      React.DOM.div({ className: "player-controls-section" },
        React.createElement(RadioSkipButton, { httpMethod: "post", radioMethod: "/radio/skip", label: "Skip" } )
      )
    );
  }
}
