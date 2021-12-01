module.exports = {
  // defaultBrowser: "Safari",
  defaultBrowser: "com.apple.ScriptEditor.id.open-URL-focus",
  options: {
    hideIcon: true,
    checkForUpdate: false
  },
  handlers: [
    {
      match: /zoom\.us\/join/,
      browser: 'com.apple.ScriptEditor.id.open-URL'
    },
    // {
    //   match: () => {
    //     const startTime = 9 * 60;
    //     const endTime = 18 * 60;

    //     const date = new Date();
    //     const now = date.getHours() * 60 + date.getMinutes();
    //     const isWeekend = date.getDay() == 6 || date.getDay() == 0;

    //     return !isWeekend && startTime <= now && now < endTime;
    //   },
    //   browser: "Google Chrome"
    // }
  ],
  rewrite: [
    {
      match: /zoom\.us\/j\//,
      url: ({ url }) => ({
        ...url,
        search: `confno=${url.pathname.match(/\/j\/(\d+)($|\/)/)[1]}&pwd=${url.search.match(/pwd=([^&]+)/)[1]}`,
        pathname: '/join',
        protocol: "zoommtg"
      })
    },
  ]
}
