class Queue extends React.Component {
  render () {
    let songQueue;

    if (typeof this.props.songs === "undefined" || this.props.songs.length === 0) {
      songQueue = React.DOM.div(null, "No songs in queue");
    } else {
      songQueue = React.createElement(SongList, { songs: this.props.songs, tabular: false });
    }

    return (
      <div className={this.props.className}>
        <div className="queue-title">{this.props.title}</div>
        {songQueue}
      </div>
    )
  }
}

Queue.propTypes = {
  // songs: React.PropTypes.arrayOf(React.PropTypes.element),
  // title: React.PropTypes.arrayOf(React.PropTypes.string)
};
