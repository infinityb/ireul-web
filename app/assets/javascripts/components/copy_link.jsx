class CopyLink extends React.Component {
  constructor(props) {
    super(props);
    this.copyStreamLinkFn = this.copyStreamLink.bind(this);
  }

  copyStreamLink(event) {
    // Clipboard API is not mature yet
    // const copyEvent = new ClipboardEvent('copy', { dataType: 'text/plain', data: this.props.href });
    // document.dispatchEvent(copyEvent);
    event.preventDefault();
    const copyTextarea = document.querySelector(`#copyme-${this.props.identifier}`);
    copyTextarea.select();
    document.execCommand('copy');
  }

  render() {
    const textareaStyle = {
      background: 'transparent',
      border: 'none',
      boxShadow: 'none',
      height: '2em',
      left: 0,
      opacity: 0,
      outline: 'none',
      padding: 0,
      pointerEvents: 'none',
      position: 'fixed',
      top: 0,
      width: '2em'
    };

    return (
      <a
        className="copy-link"
        href={this.props.href}
        onClick={this.copyStreamLinkFn}
        style={{ color: 'inherit', cursor: 'pointer' }}
        title="Copy direct stream link…"
      >
        {this.props.text}
        <textarea
          id={`copyme-${this.props.identifier}`}
          style={textareaStyle}
          defaultValue={this.props.href}
        >
        </textarea>
      </a>
    );
  }
}

CopyLink.defaultProps = {
  identifier: ''
};

CopyLink.propTypes = {
  href: React.PropTypes.string,
  identifier: React.PropTypes.string,
  text: React.PropTypes.string
};
