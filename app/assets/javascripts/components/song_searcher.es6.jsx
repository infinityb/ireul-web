class SongSearcher extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      page: 1,
      query: '',
      results: [],
      searching: false
    };

    this.onChangeFn = this.onChange.bind(this);
  }

  shouldComponentUpdate() {
    return !this.searching;
  }

  onChange(event) {
    this.setState({
      hasMore: false,
      page: 1,
      query: event.currentTarget.value
    });
    this.search(event.currentTarget.value);
  }

  searchMore() {
    this.search(this.state.query, this.state.page + 1);
  }

  search(queryArg, pageArg) {
    const xhr = new XMLHttpRequest();
    const page = pageArg || 1;
    const query = queryArg.trim();

    if (query.length > 0) {
      xhr.onreadystatechange = () => {
        if (xhr.readyState === 4 && this.state.query.length > 0) {
          const res = JSON.parse(xhr.responseText);
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
            results,
            searching: false
          });
        }
      };

      xhr.open('post', `songs/search.json?query=${encodeURI(query)}&page=${page}`, true);
      xhr.setRequestHeader('X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').content);
      xhr.send();
      this.setState({ searching: true });
    } else if (this.state.results.length > 0) {
      // Emptied query (backspace, delete)
      this.setState({ results: [], searching: false });
    }
  }

  render() {
    let resultsEl;
    let hasMoreButton;

    if (this.state.query.length === 0) {
      // noop
    } else if (!this.state.searching && this.state.results.length === 0) {
      resultsEl = React.DOM.p(null, `No results found for "${this.state.query}".`);
    } else {
      resultsEl = React.createElement(SongList, {
        controls: true,
        songs: this.state.results,
        tabular: true
      });
    }

    if (this.state.hasMore) {
      hasMoreButton = React.DOM.a({
        href: '#',
        onClick: this.searchMore.bind(this)
      }, 'More…');
    }

    return (
      <div className="song-searcher">
        <input
          type="text"
          placeholder="Type here to start searching…"
          onChange={this.onChangeFn}
        />
        {resultsEl}
        {hasMoreButton}
      </div>
    );
  }
}
