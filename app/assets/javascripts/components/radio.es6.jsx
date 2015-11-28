class Radio extends React.Component {
  render () {
    return (
      <div>
        <Queue songs={[React.createElement(Song, { artist: 'lmao', title: 'lmbo' })]} />

        <RadioSkipButton httpMethod="get" radioMethod="skip" label="Skip" />
      </div>
    );
  }
}
