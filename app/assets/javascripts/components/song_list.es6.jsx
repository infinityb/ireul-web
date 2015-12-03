class SongList extends React.Component {
  constructor (props) {
    super(props);
  }

  render () {
    if (typeof this.props.songs === "undefined") {
      return;
    }

    return React.DOM.table(null,
      React.DOM.tbody(null,
        this.props.songs.map((song) => {
          let controls;

          if (this.props.controls) {
            controls = React.createElement(RadioEnqueueButton, {
              httpMethod: 'post',
              radioMethod: '/radio/enqueue/' + song.id, label: 'Enqueue'
            });
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
        }
      )
    ));
  }
}

SongList.propTypes = {
  song: React.PropTypes.arrayOf(React.PropTypes.element)
};
