class SongList extends React.Component {
  constructor (props) {
    super(props);
  }

  render () {
    if (typeof this.props.songs === "undefined") {
      return;
    }

    let contents = this.props.songs.map((song) => {
      let controls;

      if (this.props.controls) {
        controls = React.DOM.div({ className: 'song-list-control' },
          React.createElement(RadioRequestButton, {
            httpMethod: 'post',
            radioMethod: '/radio/request/' + song.id, label: 'Request',
            canRequestAt: song.canRequestAt
          })
        );
      }

      let props = {
        key: "song-list" + song.id,
        id: song.id,
        artist: song.artist,
        title: song.title,
        tabular: this.props.tabular,
        controls: controls
      };

      return React.createElement(Song, props);
    });

    if (this.props.tabular) {
      return React.DOM.table({ className: "song-list" },
        React.DOM.tbody(null, contents)
      );
    } else {
      return React.DOM.div({ className: "song-list" },
        contents
      );
    }

  }
}

SongList.propTypes = {
  song: React.PropTypes.arrayOf(React.PropTypes.element)
};
