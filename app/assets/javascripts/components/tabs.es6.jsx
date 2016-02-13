class Tabs extends React.Component {
  render() {
    const tab = (id) =>
      React.DOM.li({
        key: `t.${id}`,
        href: `#${id}`,
        className: this.props.selectedItem === id ? 'selected' : '',
        onClick: this.props.onChange.bind(null, id)
      }, id);

    const tabs = this.props.tabs.map((el) => tab(el));

    return React.DOM.div(
      { className: 'tabs' },
      React.DOM.ul(null,
        tabs
      )
    );
  }
}

Tabs.propTypes = {
  onChange: React.PropTypes.func,
  selectedItem: React.PropTypes.number,
  tabs: React.PropTypes.arrayOf(React.PropTypes.string)
};
