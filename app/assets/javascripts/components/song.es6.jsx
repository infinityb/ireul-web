class Song extends React.Component {
  render () {
    controls = this.props.controls;

    if (this.props.tabular) {
      return (
        <tr className="song-list-row">
          <td className="artist">{this.props.artist}</td>
          <td className="title">{this.props.title}</td>
          <td className="controls">{this.props.controls}</td>
        </tr>
      );
    } else {
      return (
        <div className="song-list-item">
          <span className="song">{this.props.artist + " — " + this.props.title}</span>
          <span className="controls">{this.props.controls}</span>
        </div>
      );
    }
  }
}

Song.defaultProps = {
  tabular: false
};

Song.propTypes = {
  id: React.PropTypes.number,
  artist: React.PropTypes.string,
  title: React.PropTypes.string,
  controls: React.PropTypes.element,
  tabular: React.PropTypes.bool
};
