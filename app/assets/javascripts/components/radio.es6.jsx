class Tabs extends React.Component {
  render () {
    let tab = function (id) {
      return React.DOM.a({
        href: "#" + id,
        className: this.props.selectedItem === id ? "selected" : "",
        onClick: this.props.onChange.bind(null, id)
      }, id);
    }.bind(this);

    return React.DOM.div(
      { className: "tabs" },
      React.DOM.ul(null,
        React.DOM.li(null, tab("Radio")),
        React.DOM.li(null, tab("Songs")),
      )
    );
  }
}

class Radio extends React.Component {
  constructor (props) {
    super(props);
    this.state = { selectedPage: "Radio" }
  }

  changePage (id) {
    this.setState({ selectedPage: id });
  }

  componentWillMount () {
    this.changePage(window.location.hash.slice(1));
  }

  render () {
    let contents;

    switch (this.state.selectedPage) {
    case "Radio":
      contents = React.DOM.div(null,
        React.createElement(Queue, { songs: [React.createElement(Song, { artist: "lmao", title: "lmbo" })] }),
        React.createElement(RadioSkipButton, { httpMethod: "post", radioMethod: "/radio/skip", label: "Skip" } )
      );
      break;
    case "Songs":
      contents = React.DOM.span(null,
        React.createElement(SongSearch)
      );
      break;
    }

    return React.DOM.div(style,
      React.createElement(Tabs, { selectedPage: this.state.selectedPage, onChange: this.changePage.bind(this) }),
      contents
    );
  }
}

var style = {
  display: "flex",
  flexDirection: "column"
};
