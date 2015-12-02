class RadioControlButton extends React.Component {
  constructor (props) {
    super(props);
    this.state = { disabled: false };
  }

  handleClick (event) {
    var req = new XMLHttpRequest();
    req.open(this.props.httpMethod, this.props.radioMethod, true);
    req.setRequestHeader('X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').content);
    req.onreadystatechange = () => {
      if (req.readyState == 4) {
        this.handleResponse(JSON.parse(req.responseText));
      }
    };
    req.send();
  }

  handleResponse (res) {
    // noop
  }

  render () {
    return (
      React.DOM.button({ disabled: this.state.disabled, onClick: this.handleClick.bind(this) }, this.props.label)
    );
  }
}

RadioControlButton.propTypes = {
  label: React.PropTypes.string,
  httpMethod: React.PropTypes.string,
  radioMethod: React.PropTypes.string
};



class RadioSkipButton extends RadioControlButton {
  handleClick (event) {
    super.handleClick(event);
    this.setState({ disabled: true });
  }

  handleResponse (res) {
    if (res.status === "ok") {
      // To replace with on song change, not on skip request success
      this.setState({ disabled: false });
    }
  }
}


class RadioEnqueueButton extends RadioControlButton {
  handleClick (event) {
    super.handleClick(event);
    this.setState({ disabled: true });
  }

  handleResponse (res) {
    if (res.status === "ok") {
      // To replace with on song change, not on skip request success
      this.setState({ disabled: false });
    }
  }
}
