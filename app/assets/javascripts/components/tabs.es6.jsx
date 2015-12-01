class Tabs extends React.Component {
  render () {
    let tab = function (id) {
      return React.DOM.a({
        href: "#" + id,
        className: this.props.selectedItem === id ? "selected" : "",
        onClick: this.props.onChange.bind(null, id)
      }, id);
    }.bind(this);

    let tabs = this.props.tabs.map(function (el) {
      return React.DOM.li({ key: "t." + el }, tab(el));
    });

    return React.DOM.div(
      { className: "tabs" },
      React.DOM.ul(null,
        tabs
      )
    );
  }
}
