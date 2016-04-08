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

    let humanTime;
    if (this.props.timestamp) {
      const serverTimestamp = new Date(this.props.timestamp).getTime();
      const clientTimestamp = new Date(serverTimestamp + this.props.timeOffset);
      humanTime = clientTimestamp.toLocaleString(undefined, { timeZoneName: 'short' });
    } else {
      humanTime = undefined;
    }

    const title = this.title(this.props.artist, this.props.title);

    return (
      <div className="song-list-item">
        <span className="song" title={`${humanTime}\n${title}`}>
          {title}
        </span>
        <span className="controls">{this.props.controls}</span>
      </div>
    );
  }

  title(title, artist) {
    if (title && artist) {
      return `${title} — ${artist}`;
    } else if (title || artist) {
      return title || artist;
    }

    return '♫♪♫';
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
  timestamp: React.PropTypes.string,
  title: React.PropTypes.string
};
