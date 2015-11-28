class Song extends React.Component {
  render () {
    return (
      <div>
        <div>Artist: {this.props.artist}</div>
        <div>Title: {this.props.title}</div>
      </div>
    );
  }
}

Song.propTypes = {
  artist: React.PropTypes.string,
  title: React.PropTypes.string
};
