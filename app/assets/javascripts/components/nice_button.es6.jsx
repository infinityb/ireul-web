class NiceButton extends React.Component {
  constructor(props) {
    super(props);
    this.niceFn = this.nice.bind(this);
    this.state = { niceness: this.props.niceness };
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.niceness !== this.props.niceness) {
      this.setState({ niceness: nextProps.niceness });
    }
  }

  nice() {
    const xhr = new XMLHttpRequest();
    xhr.open('post', 'radio/nice', true);
    xhr.setRequestHeader('X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').content);
    xhr.onreadystatechange = () => {
      if (xhr.readyState === 4 && xhr.status === 200) {
        const res = JSON.parse(xhr.responseText);

        if (res.status === 'ok') {
          console.log('🎉 Niceness verified! 🎉');
          this.setState({ niceness: this.props.niceness + 1 });
        } else {
          console.log(res.status_message);
        }
      }
    };

    xhr.send();
  }

  niceness() {
    return this.state.niceness > 0 ? ` ${this.state.niceness}` : '';
  }

  render() {
    return (
      <div className="nice-button" onMouseDown={this.niceFn} title="Nice!">
        <span className="nice-symbol">❤</span>{this.niceness()}
      </div>
    );
  }
}

NiceButton.defaultProps = {
  niceness: 0
};

NiceButton.propTypes = {
  niceness: React.PropTypes.number
};
