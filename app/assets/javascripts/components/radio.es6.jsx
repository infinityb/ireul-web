class Radio extends React.Component {
  constructor(props) {
    super(props);

    this.fallbackInfo = {
      artist: 'Something went wrong',
      title: 'Nothing is playing',
      duration: 0,
      position: 0
    };

    this.state = { radio: {
      current: this.fallbackInfo,
      upcoming: [],
      history: []
    } };
  }

  componentDidMount() {
    if (typeof this.props.backgroundElementSelector !== 'undefined') {
      this.setupBackground();
    }
    this.getInfo();
    setInterval(this.getInfo.bind(this), 10000);
  }

  setupBackground() {
    // Create a pseudo element so we can apply CSS filters (blur, etc.)
    // only on the background image.
    // Blur on a smaller preimage, then scale it up using CSS transform
    // Loses some quality but massive gains in performance.
    const style =
      `${this.props.backgroundElementSelector}:before {
        content: "";
        position: fixed;
        left: 0;
        right: 0;

        display: block;
        z-index: -1;
        width: 25%;
        height: 25%;

        background-repeat: no-repeat;
        background-position: center;
        background-origin: center;
        background-size: cover;

        filter: blur(0.625rem) saturate(60%);
        -webkit-filter: blur(0.625rem) saturate(60%);

        will-change: background-image;
        transform-origin: top left;
        transform: translateZ(0) scale(4);
        max-height: 100%;
      }
    `;

    // HACK: Doing this so the required styles are kept all packaged
    //       in this component. If it breaks and the fix is hard,
    //       just extract the style into a CSS file/<style> element.
    // HACK: 40 is an arbitrary number
    // Modify existing styles
    document.styleSheets[0].insertRule(style, 40);
    this.background = null;
  }

  setBackground(src) {
    if (typeof src !== 'undefined' && src !== null) {
      if (src !== this.background) {
        this.background = src;
        // This is a hack
        const url = `url('${src}')`;
        // Maybe in the future data-attr for url type will be supported
        // el.setAttribute('data-bgimgsrc', src);
        document.styleSheets[0].cssRules[40].style.backgroundImage = url;
      }
    } else if (this.background !== 'none') {
      this.background = 'none';
      document.styleSheets[0].cssRules[40].style.backgroundImage = 'none';
    }
  }

  getInfo() {
    const xhr = new XMLHttpRequest();
    xhr.open('get', 'radio/info', true);
    xhr.setRequestHeader('X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').content);
    xhr.onreadystatechange = () => {
      if (xhr.readyState === 4 && xhr.status === 200) {
        this.handleInfoResponse(JSON.parse(xhr.responseText));
      }
    };
    xhr.send();
  }

  setTitle(song) {
    if (song.title && song.artist) {
      document.title = `${song.title} — ${song.artist}`;
    } else if (song.title || song.artist) {
      document.title = song.title || song.artist;
    } else {
      document.title = '♫♪♫';
    }
  }

  handleInfoResponse(res) {
    this.setBackground(res.image);
    this.setTitle(res.current);

    this.setState({
      radio: {
        current: res.current,
        history: res.history,
        meta: {
          icecast: res.icecast,
          niceness: res.niceness
        },
        timeOffset: Date.now() - Date.parse(res.time),
        upcoming: res.upcoming
      }
    });
  }

  render() {
    const queue = React.createElement(Queue, {
      className: 'queue',
      songs: this.state.radio.upcoming.slice(0, 5),
      timeOffset: this.state.radio.timeOffset,
      title: 'queue'
    });

    const history = React.createElement(Queue, {
      className: 'history',
      songs: this.state.radio.history.slice(-5).reverse(),
      timeOffset: this.state.radio.timeOffset,
      title: 'history'
    });

    const player = React.createElement(Player, {
      audioSrc: this.props.audioSrc,
      nowPlaying: this.state.radio.current || this.fallbackInfo,
      streamInfo: this.state.radio.meta,
      timeOffset: this.state.radio.timeOffset
    });

    return React.DOM.div({ className: 'radio' },
      React.DOM.div({ className: 'player-information-section' },
        player,
        React.DOM.div({ className: 'queue-history'},
          history,
          queue
        )
      ),

      React.DOM.div({ className: 'song-library-section' },
        React.createElement(SongLibrary, {
          timeOffset: this.state.radio.timeOffset
        })
      )
    );
  }
}

Radio.propTypes = {
  backgroundElementSelector: React.PropTypes.string,
  audioSrc: React.PropTypes.string
};
