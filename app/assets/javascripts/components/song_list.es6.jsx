class SongList extends React.Component {
  constructor (props) {
    super(props);
  }

  render () {
    return React.DOM.table(null,
      React.DOM.thead(null,
        React.DOM.tr(null,
          React.DOM.td(null, "Artist"),
          React.DOM.td(null, "Title")
        )
      ),
      React.DOM.tbody(null,
        this.props.songs.map(function (song) {
          let controls = React.createElement(RadioEnqueueButton, {
            httpMethod: 'post',
            radioMethod: '/radio/enqueue/' + song.id, label: 'Enqueue'
          });

          let props = {
            key: "song-list" + song.id,
            id: song.id,
            artist: song.artist,
            title: song.title,
            tabular: true,
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
