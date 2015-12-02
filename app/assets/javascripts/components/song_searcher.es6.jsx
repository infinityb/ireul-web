class SongSearcher extends React.Component {
  constructor (props) {
    super(props);
    this.state = { query: "", results: [], searching: false, page: 1 };
  }

  onChange (event) {
    this.setState({ query: event.currentTarget.value, page: 1, hasMore: false });
    this.search(event.currentTarget.value);
  }

  searchMore () {
    this.search(this.state.query, this.state.page + 1);
  }

  search (query, page) {
    let xhr = new XMLHttpRequest();
    page = page || 1;
    query = query.trim();

    if (query.length > 0) {
      xhr.onreadystatechange = () => {
        if (xhr.readyState == 4 && this.state.query.length > 0) {
          let res = JSON.parse(xhr.responseText);
          let results;

          if (this.state.hasMore) {
            // 1. Some (not first) page, has extra pages (hasMore = true)
            // 2. Last page -- this.state.hasMore has not been set to false yet
            //    render() will not render a more button, but we still add to existing results
            results = this.state.results.concat(res.results);
          } else {
            // 3. First page, no extra pages
            results = res.results;
          }

          this.setState({
            hasMore: res.has_more,
            page: parseInt(res.page, 10),
            results: results,
            searching: false
          });
        }
      };

      xhr.open('post', "songs/search.json?query=" + encodeURI(query) + "&page=" + page, true);
      xhr.setRequestHeader('X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').content);
      xhr.send();
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
    let resultsEl;
    let hasMoreButton;

    if (this.state.query.length === 0) {
      resultsEl = React.DOM.p(null, "Type in the search box to start searching.");
    } else if (!this.state.searching && this.state.results.length === 0) {
      resultsEl = React.DOM.p(null, "No results found for \"" + this.state.query + "\".");
    } else {
      resultsEl = React.createElement(SongList, { songs: this.state.results });
    }

    if (this.state.hasMore) {
      hasMoreButton = React.DOM.a({ href: "#", onClick: this.searchMore.bind(this) }, "More...");
    }

    return (
      <div>
        <input type="text" placeholder="Search songs..." onChange={this.onChange.bind(this)} />
        {resultsEl}
        {hasMoreButton}
      </div>
    );
  }
}

var style = {
  style: {
    transition: "opacity 1s"
  }
};
