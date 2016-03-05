class Slider extends React.Component {
  constructor(props) {
    super(props);
    this.state = { value: props.initial };
  }

  componentDidMount() {
    this.setState({ value: this.positionFromValue(this.props.initial) });
  }

  handleMouseDown(e) {
    const value = this.position(e);
    this.setState({ value });

    if (this.props.onChange) {
      this.props.onChange(value);
    }
  }

  handleKnob() {
    this.moveListener = this.handleDrag.bind(this);
    this.upListener = this.handleDragEnd.bind(this);

    // Add click listener as mouseup might not be captured
    document.addEventListener('dragend', this.upListener);
    document.addEventListener('mousemove', this.moveListener);
    document.addEventListener('mouseup', this.upListener);
    document.addEventListener('touchmove', this.moveListener);
    document.addEventListener('touchend', this.upListener);
  }

  handleDrag(e) {
    const value = this.position(e);
    this.setState({ value });

    if (this.props.onChange) {
      const offset = this.props.onChange(value + (this.valueOffset || 0));
    }
  }

  handleDragEnd() {
    document.removeEventListener('dragend', this.upListener);
    document.removeEventListener('mousemove', this.moveListener);
    document.removeEventListener('mouseup', this.upListener);
    document.removeEventListener('touchmove', this.moveListener);
    document.removeEventListener('touchend', this.upListener);
  }

  handleOnClick(e) {
    e.stopPropagation();
    e.preventDefault();
  }

  positionFromValue() {
    const rect = React.findDOMNode(this.refs.slider).getBoundingClientRect();
    const percentage = (this.state.value - this.props.min) / (this.props.max - this.props.min);
    const offset = React.findDOMNode(this.refs.handle).getBoundingClientRect().width / 2;
    this.valueOffset = offset / rect.width;
    const position = (percentage * rect.width - offset) / rect.width;

    return position;
  }

  position(e) {
    const node = React.findDOMNode(this.refs.slider);
    const rect = node.getBoundingClientRect();

    let x;
    if (e.clientX) {
      x = e.clientX;
    } else if (e.nativeEvent && e.nativeEvent.clientX) {
      x = e.nativeEvent.clientX;
    } else if (e.touches && e.touches[0] && e.touches[0].clientX) {
      x = e.touches[0].clientX;
    }

    const clampedX = Math.max(rect.left, Math.min(x, rect.right));
    const offset = React.findDOMNode(this.refs.handle).getBoundingClientRect().width / 2;
    this.valueOffset = offset / rect.width;
    const position = ((clampedX - offset) - rect.left) / rect.width;

    return position;
  }

  render() {
    const handleKnob = this.handleKnob.bind(this);
    const onMouseDown = this.handleMouseDown.bind(this);
    const onClick = this.handleOnClick.bind(this);

    return (
      <div
        ref="slider"
        className="slider"
        onMouseDown={onMouseDown}
        onClick={onClick}
      >
        <div
          ref="fill"
          className="fill"
        >
          <div
            ref="handle"
            className="handle"
            style={{ marginLeft: `${this.state.value * 100}%` }}
            onMouseDown={handleKnob}
            onTouchStart={handleKnob}
          >
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
  onChange: React.PropTypes.func,
  initial: React.PropTypes.number
};
