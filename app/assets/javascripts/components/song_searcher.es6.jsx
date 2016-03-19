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

  isJsonString(str) {
    try {
      JSON.parse(str);
    } catch (e) {
      return false;
    }
    return true;
  }

  search(queryArg, pageArg) {
    if (typeof this.xhr !== 'undefined') {
      this.xhr.abort();
    }

    this.xhr = new XMLHttpRequest();
    const page = pageArg || 1;
    const query = queryArg.trim();

    if (query.length > 0) {
      this.xhr.onreadystatechange = () => {
        if (this.xhr.readyState === 4 && this.state.query.length > 0) {
          try {
            const res = JSON.parse(this.xhr.responseText);

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
          } catch (e) {
            // console.error(e);
          }
        }
      };

      this.xhr.open('post', `songs/search.json?query=${encodeURI(query)}&page=${page}`, true);
      this.xhr.setRequestHeader('X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').content);
      this.xhr.send();
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
      resultsEl = React.DOM.p(null, `No results found for “${this.state.query}”.`);
    } else {
      resultsEl = React.createElement(SongList, {
        controls: true,
        key: 'search-results',
        songs: this.state.results,
        tabular: true,
        timeOffset: this.props.timeOffset
      });
    }

    if (this.state.hasMore) {
      hasMoreButton = React.DOM.button({
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

SongSearcher.defaultProps = {
  timeOffset: 0
};

SongSearcher.propTypes = {
  timeOffset: React.PropTypes.number
};
