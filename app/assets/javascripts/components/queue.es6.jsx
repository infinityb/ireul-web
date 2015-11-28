class Queue extends React.Component {
  render () {
    if (typeof this.props.songs === "undefined" || this.props.songs.length === 0) {
      return React.DOM.div(null, "No songs in queue");
    } else {
      return React.DOM.ul(null, this.props.songs.map(function (song) {
        return React.DOM.li(null, song);
      }));
    }
  }
}

Queue.propTypes = {
  song: React.PropTypes.arrayOf(React.PropTypes.element)
};
