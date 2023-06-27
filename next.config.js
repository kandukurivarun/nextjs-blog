module.exports = (phase, { defaultConfig }) => {
  return {
    ...defaultConfig,
    reactStrictMode: false,
    swcMinify: true,
    output: "standalone",
  };
};
