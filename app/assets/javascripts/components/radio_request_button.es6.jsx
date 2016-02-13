class RadioRequestButton extends RadioControlButton {
  constructor(props) {
    super(props);
  }

  checkIfRequestable() {
    const canRequestAt = Date.parse(this.props.canRequestAt) + this.props.timeOffset;

    if (Date.now() < canRequestAt) {
      this.setState({ disabled: true });
      const checkAgainIn = canRequestAt - Date.now() + 1000;
      setTimeout(this.checkIfRequestable.bind(this), checkAgainIn);
    } else {
      this.setState({ disabled: false });
    }
  }

  handleClick(event) {
    super.handleClick(event);
    this.setState({ disabled: true });
  }

  componentDidMount() {
    this.checkIfRequestable();
  }

  handleResponse(res) {
    if (res.status === 'ok') {
      const checkAgainIn = Date.parse(res.canRequestAt) + this.props.timeOffset - Date.now() + 1000;
      setTimeout(this.checkIfRequestable.bind(this), checkAgainIn);
    }
  }
}
