class RadioRequestButton extends RadioControlButton {
  constructor(props) {
    super(props);
  }

  checkIfRequestable() {
    const canRequestAt = Date.parse(this.props.canRequestAt) + this.props.timeOffset;

    if (Date.now() < canRequestAt) {
      const titleText = `Can request at ${new Date(canRequestAt).toLocaleString(undefined, { timeZoneName: 'short' })}`;
      this.setState({ disabled: true, title: titleText });
      const checkAgainIn = canRequestAt - Date.now() + 1000;
      setTimeout(this.checkIfRequestable.bind(this), checkAgainIn);
    } else {
      this.setState({ disabled: false, title: 'Requestable now!' });
    }
  }

  handleClick(event) {
    super.handleClick(event);
    this.setState({ disabled: true, title: 'Request sent, waiting for confirmation…' });
  }

  componentDidMount() {
    this.checkIfRequestable();
  }

  handleResponse(res) {
    if (res.status === 'ok') {
      this.setState({ disabled: true, title: 'Song requested.' });
      const checkAgainIn = Date.parse(res.canRequestAt) + this.props.timeOffset - Date.now() + 1000;
      setTimeout(this.checkIfRequestable.bind(this), checkAgainIn);
    }
  }
}

RadioRequestButton.defaultProps = {
  timeOffset: 0
};

RadioRequestButton.propTypes = {
  timeOffset: React.PropTypes.number
};
