class RadioEnqueueButton extends RadioControlButton {
  handleClick(event) {
    super.handleClick(event);
    this.setState({ disabled: true });
  }

  handleResponse(res) {
    if (res.status === 'ok') {
      // To replace with on song change, not on skip request success
      this.setState({ disabled: false });
    }
  }
}
