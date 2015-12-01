class Song extends React.Component {
  render () {
    controls = this.props.controls;

    if (this.props.tabular) {
      return (
        <tr>
          <td>{this.props.artist}</td>
          <td>{this.props.title}</td>
          <td>{this.props.controls}</td>
        </tr>
      );
    } else {
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
