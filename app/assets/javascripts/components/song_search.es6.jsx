class SongSearch extends React.Component {
  constructor (props) {
    super(props);
    this.state = { query: "", results: [] };
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
          this.setState({ results: JSON.parse(req.responseText).results });
        }
      }.bind(this);
      req.open('post', "songs/search/" + query + ".json", true);
      req.setRequestHeader('X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').content);
      req.send();
    } else if (this.state.results.length > 0) {
      this.setState({ results: [] });
    }
  }

  render () {
    let results;
    if (this.state.results.length < 0) {
      results = React.DOM.p(null, "No results.");
    } else {
      results = React.DOM.ul(null, this.state.results.map(function (result) {
        let controls = React.createElement(RadioEnqueueButton, { httpMethod: 'post', radioMethod: '/radio/enqueue/' + result.id, label: 'Enqueue' });
        let props = {
          id: result.id,
          artist: result.artist,
          title: result.title,
          controls: controls
        };

        return React.DOM.li(null, React.createElement(Song, props));
      }));
    }

    return (
      <div>
        <input type="text" placeholder="Search songs..." onChange={this.onChange.bind(this)} />
        {results}
      </div>
    );
  }
}
