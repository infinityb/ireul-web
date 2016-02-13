class SongLibrary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { selectedPage: 'Search' };
  }

  changePage(id) {
    this.setState({ selectedPage: id });
  }

  render() {
    let content;

    switch (this.state.selectedPage) {
      case 'Search':
        content = React.createElement(SongSearcher);
        break;
      case 'Browse':
        content = React.createElement(SongBrowser);
        break;
      default:
        break;
    }

    return React.DOM.div({ className: 'song-library', id: 'song-library' },
      React.createElement(Tabs, {
        tabs: ['Search', 'Browse'],
        selectedPage: this.state.selectedPage,
        onChange: this.changePage.bind(this),
        className: 'tabs'
      }),
      content
    );
  }
}
