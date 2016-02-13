class SongList extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const contents = this.props.songs.map((song) => {
      let controls;

      if (this.props.controls) {
        controls = React.DOM.div({ className: 'song-list-control' },
          React.createElement(RadioRequestButton, {
            httpMethod: 'post',
            radioMethod: `/radio/request/${song.id}`, label: 'Request',
            canRequestAt: song.canRequestAt
          })
        );
      }

      const songProps = {
        key: `song-list.${song.artist}.${song.title}`,
        id: song.id,
        artist: song.artist,
        title: song.title,
        tabular: this.props.tabular,
        controls
      };

      return React.createElement(Song, songProps);
    });

    if (this.props.tabular) {
      return React.DOM.table({ className: 'song-list' },
        React.DOM.tbody(null, contents)
      );
    }

    return React.DOM.div({ className: 'song-list' }, contents);
  }
}

SongList.defaultProps = {
  songs: []
};

SongList.propTypes = {
  songs: React.PropTypes.arrayOf(React.PropTypes.object),
  tabular: React.PropTypes.bool,
  controls: React.PropTypes.bool
};
