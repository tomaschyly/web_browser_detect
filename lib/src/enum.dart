enum BrowserAgent {
  unknown('Unknown browser'),
  chrome('Chrome'),
  safari('Safari'),
  firefox('Firefox'),
  explorer('Internet Explorer'),
  edge('Edge'),
  edgeChromium('Chromium Edge'),
  brave('Brave'),
  opera('Opera');

  const BrowserAgent(this.browserName);
  final String browserName;
}
