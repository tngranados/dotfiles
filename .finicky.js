module.exports = {
  defaultBrowser: "Safari",
  options: {
    hideIcon: true,
    checkForUpdate: false
  },
  handlers: [
    {
      match: () => {
        const startTime = 9 * 60;
        const endTime = 18 * 60;

        const date = new Date();
        const now = date.getHours() * 60 + date.getMinutes();
        const isWeekend = date.getDay() == 6 || date.getDay() == 0;

        return !isWeekend && startTime <= now && now < endTime;
      },
      browser: "Google Chrome"
    }
  ]
}
