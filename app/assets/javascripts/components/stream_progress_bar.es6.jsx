class StreamProgressBar extends React.Component {
  timeFrom(time) {
    const parsed = Date.parse(time);
    return Date.now() - parsed;
  }

  render() {
    const progressValueWidth = `${Math.min(100, (this.props.value / this.props.max) * 100)}%`;

    return (
      <div className="progress">
        <div className="value" style={{ width: progressValueWidth }}></div>
      </div>
    );
  }
}

StreamProgressBar.propTypes = {
  max: React.PropTypes.number,
  value: React.PropTypes.number
};
