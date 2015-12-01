class SongLibrary extends React.Component {
  constructor (props) {
    super(props);
    this.state = { selectedPage: "Search" };
  }

  changePage (id) {
    this.setState({ selectedPage: id });
  }

	render () {
    let content;

    switch (this.state.selectedPage) {
    case "Search":
      content = React.createElement(SongSearcher);
      break;
    case "All":
      content = React.createElement(SongBrowser);
      break;
    }

    return React.DOM.div(null,
      React.createElement(Tabs, {
        tabs: ["Search", "All"],
        selectedPage: this.state.selectedPage,
        onChange: this.changePage.bind(this)
      }),
      content
    );
  }
}
