class TimeInfo extends React.Component {
  secToMinSec(totalSeconds) {
    const pad = (num, size) => {
      let s = num.toString();
      while (s.length < size) {
        s = `0${s}`;
      }
      return s;
    };

    let minutes = Math.floor(totalSeconds / 60);
    let seconds = pad(Math.floor(totalSeconds - minutes * 60), 2);

    if (isNaN(minutes)) minutes = '0';
    if (isNaN(seconds)) seconds = '00';

    return `${minutes}:${seconds}`;
  }

  render() {
    return (
      <div className="time-info">
        {this.secToMinSec(this.props.position)} {this.secToMinSec(this.props.duration)}
      </div>
    );
  }
}

TimeInfo.propTypes = {
  duration: React.PropTypes.number,
  position: React.PropTypes.number
};
