class RadioControlButton extends React.Component {
  constructor(props) {
    super(props);
    this.state = { disabled: false, noCache: false, title: undefined };
  }

  handleClick() {
    const req = new XMLHttpRequest();
    req.open(this.props.httpMethod, this.props.radioMethod, true);
    req.setRequestHeader('X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').content);
    req.onreadystatechange = () => {
      if (req.readyState === 4) {
        this.handleResponse(JSON.parse(req.responseText));
      }
    };
    req.send();
  }

  handleResponse() {
    // noop
  }

  render() {
    return (
      React.DOM.button({
        disabled: this.state.disabled,
        onClick: this.handleClick.bind(this),
        title: this.state.title
      }, this.props.label)
    );
  }
}

RadioControlButton.propTypes = {
  label: React.PropTypes.string,
  httpMethod: React.PropTypes.string,
  radioMethod: React.PropTypes.string,
  timeOffset: React.PropTypes.number
};
