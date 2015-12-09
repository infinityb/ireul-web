class Slider extends React.Component {
  constructor (props) {
    super(props);
    this.state = { value: props.initial };
  }

  componentDidMount () {
    this.setState({ value: this.positionFromValue(this.props.initial) });
  }

  handleMouseDown (e) {
    let value = this.position(e);
    this.setState({ value: value });

    if (this.props.onChange) {
      this.props.onChange(value);
    }
  }

  handleKnob () {
    this.moveListener = this.handleDrag.bind(this);
    this.upListener = this.handleDragEnd.bind(this);

    // Add click listener as mouseup might not be captured
    document.addEventListener('dragend', this.upListener);
    document.addEventListener('mousemove', this.moveListener);
    document.addEventListener('mouseup', this.upListener);
    document.addEventListener('touchmove', this.moveListener);
    document.addEventListener('touchend', this.upListener);
  }

  handleDrag (e) {
    let value = this.position(e);
    this.setState({ value: value });

    if (this.props.onChange) {
      this.props.onChange(value);
    }
  }

  handleDragEnd () {
    document.removeEventListener('dragend', this.upListener);
    document.removeEventListener('mousemove', this.moveListener);
    document.removeEventListener('mouseup', this.upListener);
    document.removeEventListener('touchmove', this.moveListener);
    document.removeEventListener('touchend', this.upListener);
  }

  handleOnClick (e) {
    e.stopPropagation();
    e.preventDefault();
  }

  positionFromValue (value) {
    let rect = React.findDOMNode(this.refs.slider).getBoundingClientRect();
    let percentage = (this.state.value - this.props.min) / (this.props.max - this.props.min);
    let offset = React.findDOMNode(this.refs.handle).getBoundingClientRect().width / 2;
    let position = (percentage * rect.width - offset) / rect.width;

    return position;
  }

  position (e) {
    let node = React.findDOMNode(this.refs.slider);
    let rect = node.getBoundingClientRect();

    let x;
    if (e.clientX) {
      x = e.clientX;
    } else if (e.nativeEvent && e.nativeEvent.clientX) {
      x = e.nativeEvent.clientX;
    } else if (e.touches && e.touches[0] && e.touches[0].clientX) {
      x = e.touches[0].clientX;
    }

    let clampedX = Math.max(rect.left, Math.min(x, rect.right));
    let offset = React.findDOMNode(this.refs.handle).getBoundingClientRect().width / 2;
    let position = ((clampedX - offset) - rect.left) / rect.width;

    return position;
  }

  render () {
    return (
      <div
        ref="slider"
        className="slider"
        onMouseDown={this.handleMouseDown.bind(this)}
        onClick={this.handleOnClick.bind(this)}>
        <div
          ref="fill"
          className="fill">
          <div
            ref="handle"
            className="handle"
            style={{ marginLeft: (this.state.value * 100) + "%" }}
            onMouseDown={this.handleKnob.bind(this)}
            onTouchStart={this.handleKnob.bind(this)}>
          </div>
        </div>
      </div>
    );
  }
}

Slider.propTypes = {
  min: React.PropTypes.number,
  max: React.PropTypes.number,
  value: React.PropTypes.number,
  onChange: React.PropTypes.func
};
