class Tabs extends React.Component {
  render () {
    let tab = function (id) {
      return React.DOM.li({
        key: "t." + id,
        href: "#" + id,
        className: this.props.selectedItem === id ? "selected" : "",
        onClick: this.props.onChange.bind(null, id)
      }, id);
    }.bind(this);

    let tabs = this.props.tabs.map(function (el) {
      return tab(el);
    });

    return React.DOM.div(
      { className: "tabs" },
      React.DOM.ul(null,
        tabs
      )
    );
  }
}
