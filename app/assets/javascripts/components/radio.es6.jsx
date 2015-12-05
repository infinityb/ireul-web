class Radio extends React.Component {
  constructor (props) {
    super(props);

    this.fallbackInfo = {
      artist: "Something went wrong",
      title: "Nothing is playing",
      duration: 0,
      position: 0
    };

    this.state = { radio: {
      current: this.fallbackInfo,
      upcoming: []
    }};
  }

  componentDidMount () {
    if (typeof this.props.backgroundElementSelector !== "undefined") {
      this.setupBackground();
    }
    this.getInfo();
    setInterval(this.getInfo.bind(this), 10000);
  }

  render () {
    let queue = React.createElement(Queue, {
      className: "queue",
      title: "queue",
      songs: this.state.radio.upcoming.slice(0, 5)
    });

    let player = React.createElement(Player, {
      nowPlaying: this.state.radio.current || this.fallbackInfo,
      audioSrc: this.props.audioSrc,
    });

    return React.DOM.div({ className: "radio" },
      React.DOM.div({ className: "player-information-section" },
        player,
        React.DOM.div({ className: "queue-history"},
          React.createElement(Queue, { className: "history", title: "history", songs: [{ id: 1, artist: "lmao", title: "lmbo" }] }),
          queue
        )
      ),

      React.DOM.div({ className: "song-library-section" },
        React.createElement(SongLibrary)
      ),

      React.DOM.div({ className: "player-admin-section" },
        React.DOM.h3(null, "Admin"),
        React.createElement(RadioSkipButton, { httpMethod: "post", radioMethod: "/radio/skip", label: "Skip" } )
      )
    );
  }

  setupBackground () {
    // Create a pseudo element so we can apply CSS filters (blur, etc.) only on the background image
    let style =
      this.props.backgroundElementSelector + `:before {
        content: "";
        position: fixed;
        left: 0;
        right: 0;

        display: block;
        z-index: -1;
        width: 100%;
        height: 100%;

        background-repeat: no-repeat;
        background-position: center;
        background-origin: center;
        background-attachment: fixed;
        background-size: cover;

        filter: blur(25px) saturate(60%);
        -webkit-filter: blur(25px) saturate(60%);
      }
    `

    // HACK: Doing this so the required styles are kept all packaged
    //       in this component. If it breaks and the fix is hard,
    //       just extract the style into a CSS file/<style> element.
    // HACK: 40 is an arbitrary number
    // Modify existing styles
    document.styleSheets[0].insertRule(style, 40);
  }

  setBackground (src) {
    let url;
    if (typeof src !== 'undefined' && src !== null) {
      // This is a hack
      url = "url('" + src + "')";
      document.styleSheets[0].cssRules[40].style.backgroundImage = url;
      // Maybe in the future data-attr for url type will be supported
      // el.setAttribute('data-bgimgsrc', src);
    } else {
      url = "none";
    }
    document.styleSheets[0].cssRules[40].style.backgroundImage = url;
  }

  debugSetBackground (event) {
    this.setBackground(event.target.value);
  }

  getInfo () {
    let xhr = new XMLHttpRequest();
    xhr.open('get', 'radio/info', true);
    xhr.setRequestHeader('X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').content);
    xhr.onreadystatechange = () => {
      if (xhr.readyState === 4 && xhr.status === 200) {
        this.handleInfoResponse(JSON.parse(xhr.responseText));
      }
    };
    xhr.send();
  }

  handleInfoResponse (res) {
    this.setBackground(res.image);

    this.setState({
      radio: {
        current: res.current,
        upcoming: res.upcoming
      }
    });
  }
}
