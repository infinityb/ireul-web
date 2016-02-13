class SongBrowser extends React.Component {
  constructor(props) {
    super(props);
    this.state = { songs: [], page: 0, pageCount: 0 };

    this.loadPrevPageFn = this.loadPrevPage.bind(this);
    this.loadNextPageFn = this.loadNextPage.bind(this);
  }

  componentDidMount() {
    this.loadPage(1);
  }

  loadPage(page) {
    const xhr = new XMLHttpRequest();
    xhr.onreadystatechange = () => {
      if (xhr.readyState === 4) {
        const res = JSON.parse(xhr.responseText);
        this.setState({
          songs: res.results,
          page: parseInt(res.page, 10),
          pageCount: res.pageCount
        });
      }
    };
    xhr.open('get', `songs.json?page=${page}`, true);
    xhr.setRequestHeader('X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').content);
    xhr.send();
  }

  loadPrevPage() {
    this.loadPage(this.state.page - 1);
    this.gotoTop();
  }

  loadNextPage() {
    this.loadPage(this.state.page + 1);
    this.gotoTop();
  }

  gotoTop() {
    const url = location.href;
    location.href = '#song-library';
    history.replaceState(null, null, url);
  }

  render() {
    return (
      <div className="song-browser">
        <SongList songs={this.state.songs} controls tabular />
        <div className="paginator">
          <button disabled={this.state.page <= 1} onClick={this.loadPrevPageFn}>
            Back
          </button>

          <div className="page-info">
            Page&nbsp;{this.state.page}&nbsp;of&nbsp;{this.state.pageCount}
          </div>

          <button disabled={this.state.page === this.state.pageCount} onClick={this.loadNextPageFn}>
            Next
          </button>
        </div>
      </div>
    );
  }
}
