class SongSearch extends React.Component {
  constructor (props) {
    super(props);
    this.state = { query: "", results: [], searching: false };
  }

  onChange (event) {
    this.setState({ query: event.currentTarget.value });
    this.search(event.currentTarget.value);
  }

  search (query) {
    let req = new XMLHttpRequest();
    query = query.trim();

    if (query.length > 0) {
      req.onreadystatechange = function () {
        if (req.readyState == 4 && this.state.query.length > 0) {
          this.setState({ results: JSON.parse(req.responseText).results, searching: false });
        }
      }.bind(this);
      req.open('post', "songs/search/" + query + ".json", true);
      req.setRequestHeader('X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').content);
      req.send();
      this.setState({ searching: true });
    } else if (this.state.results.length > 0) {
      // Emptied query (backspace, delete)
      this.setState({ results: [], searching: false });
    }
  }

  shouldComponentUpdate (nextProps, nextState) {
    return !this.searching;
  }

  render () {
    let results;

    if (this.state.query.length === 0) {
      results = React.DOM.p(null, "Type in the search box to start searching.");
    } else if (!this.state.searching && this.state.results.length === 0) {
      results = React.DOM.p(null, "No results found for \"" + this.state.query + "\".");
    } else {
      results = React.DOM.table(null,
        React.DOM.thead(null, React.DOM.tr(null, React.DOM.td(null, "Artist"), React.DOM.td(null, "Title"))),
        React.DOM.tbody(null,
          this.state.results.map(function (result) {
            let controls = React.createElement(RadioEnqueueButton, { httpMethod: 'post', radioMethod: '/radio/enqueue/' + result.id, label: 'Enqueue' });
            let props = {
              id: result.id,
              artist: result.artist,
              title: result.title,
              tabular: true,
              controls: controls
            };

            return React.createElement(Song, props);
          }
        )
      ));
    }

    return (
      <div>
        <input type="text" placeholder="Search songs..." onChange={this.onChange.bind(this)} />
        {results}
      </div>
    );
  }
}

var style = {
  style: {
    transition: "opacity 1s"
  }
};
