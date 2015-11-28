class Radio extends React.Component {
  render () {
    return (
      <div>
        <Queue songs={[React.createElement(Song, { artist: 'lmao', title: 'lmbo' })]} />

        <RadioSkipButton httpMethod="post" radioMethod="/radio/skip" label="Skip" />

        <SongSearch />
      </div>
    );
  }
}
