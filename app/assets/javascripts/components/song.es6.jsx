class Song extends React.Component {
  render() {
    if (this.props.tabular) {
      return (
        <tr className="song-list-row">
          <td className="artist">{this.props.artist}</td>
          <td className="title">{this.props.title}</td>
          <td className="controls">{this.props.controls}</td>
        </tr>
      );
    }

    return (
      <div className="song-list-item">
        <span className="song">{`${this.props.artist} — ${this.props.title}`}</span>
        <span className="controls">{this.props.controls}</span>
      </div>
    );
  }
}

Song.defaultProps = {
  tabular: false
};

Song.propTypes = {
  artist: React.PropTypes.string,
  controls: React.PropTypes.element,
  id: React.PropTypes.number,
  tabular: React.PropTypes.bool,
  timeOffset: React.PropTypes.number,
  title: React.PropTypes.string
};
