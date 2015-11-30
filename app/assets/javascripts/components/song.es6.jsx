class Song extends React.Component {
  render () {
    controls = this.props.controls;


    return (
      <div>
        <span>{this.props.artist}</span>
        &nbsp;&mdash;&nbsp;
        <span>{this.props.title}</span>
        <span>{this.props.controls}</span>
      </div>
    );
  }
}

Song.propTypes = {
  id: React.PropTypes.number,
  artist: React.PropTypes.string,
  title: React.PropTypes.string,
  controls: React.PropTypes.element
};
