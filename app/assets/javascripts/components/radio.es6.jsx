class Radio extends React.Component {
  constructor (props) {
    super(props);
  }

  componentDidMount () {
    if (typeof this.props.backgroundElementSelector !== "undefined") {
      this.setupBackground();
    }
  }

  render () {
    return React.DOM.div({ className: "radio" },
      React.DOM.div({ className: "player-information-section" },
        React.createElement(Player, { audioSrc: "http://lollipop.hiphop:8000/ireul" }),
        React.DOM.div({ className: "queue-history"},
          React.createElement(Queue, { className: "history", title: "History", songs: [{ id: 1, artist: "lmao", title: "lmbo" }] }),
          React.createElement(Queue, { className: "queue", title: "Queue", songs: [{ id: 3, artist: "lmao", title: "lmbo" }] })
        )
      ),

      React.DOM.div({ className: "song-library-section" },
        React.createElement(SongLibrary)
      ),

      React.DOM.div({ className: "player-controls-section" },
        React.createElement(RadioSkipButton, { httpMethod: "post", radioMethod: "/radio/skip", label: "Skip" } )
      ),

      React.DOM.div({ className: "player-debug-section" },
        React.DOM.h2(null, "Debug"),
        React.DOM.div({ className: "player-debug-controls" },
          React.DOM.input({
            className: 'debug-input',
            placeholder: "change background with image url",
            onChange: this.debugSetBackground.bind(this)
          }, null),
          React.DOM.button({ onClick: this.getInfo.bind(this) }, "Get info for song 63")
        )
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

    document.styleSheets[0].insertRule(style, 0);
  }

  setBackground (src) {
    // This is a hack
    let url = "url('" + src + "')";
    document.styleSheets[0].cssRules[0].style.backgroundImage = url;
    // console.log(document.styleSheets[0].cssRules[0].style.backgroundImage = url);
    // Maybe in the future data-attr for url type will be supported
    // el.setAttribute('data-bgimgsrc', src);
  }

  debugSetBackground (event) {
    this.setBackground(event.target.value);
  }

  getInfo () {
    console.log('getting info');
    // remove param once it's done
    let req = new XMLHttpRequest();
    req.open('get', 'radio/info.json?song_id=64', true);
    req.setRequestHeader('X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').content);
    req.onreadystatechange = () => {
      if (req.readyState == 4) {
        console.log(req.responseText)
        this.handleInfoResponse(JSON.parse(req.responseText));
      }
    };
    req.send();
  }

  handleInfoResponse (res) {
    this.setBackground(res.image);
  }
}
