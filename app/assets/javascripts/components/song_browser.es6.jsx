class SongBrowser extends React.Component {
  constructor (props) {
    super(props);
    this.state = { songs: [], page: 0, pageCount: 0 };
  }

  componentDidMount () {
    this.loadPage(1);
  }

  loadPage(page) {
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = () => {
      if (xhr.readyState === 4) {
        let res = JSON.parse(xhr.responseText);
        this.setState({
          songs: res.results,
          page: parseInt(res.page, 10),
          pageCount: res.pageCount
        });
      }
    };
    xhr.open('get', "songs.json?page=" + page, true);
    xhr.setRequestHeader('X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').content);
    xhr.send();
  }

  loadPrevPage () {
    this.loadPage(this.state.page - 1);
  }

  loadNextPage () {
    this.loadPage(this.state.page + 1);
  }

  render () {
    return (
      <div className="song-browser">
        <SongList songs={this.state.songs} controls="true" tabular={true} />
        <div className="paginator">
          <button disabled={this.state.page <= 1} onClick={this.loadPrevPage.bind(this)}>Back</button>
          <div className="page-info">Page&nbsp;{this.state.page}&nbsp;of&nbsp;{this.state.pageCount}</div>
          <button disabled={this.state.page === this.state.pageCount} onClick={this.loadNextPage.bind(this)}>Next</button>
        </div>
      </div>
    );
  }
}
