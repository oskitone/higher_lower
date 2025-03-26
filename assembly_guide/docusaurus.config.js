// @ts-check
// `@type` JSDoc annotations allow editor autocompletion and type checking
// (when paired with `@ts-check`).
// There are various equivalent ways to declare your Docusaurus config.
// See: https://docusaurus.io/docs/api/docusaurus-config

import { themes as prismThemes } from "prism-react-renderer";

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: "Oskitone Higher Lower Assembly Guide",
  favicon: "img/favicon.ico",

  url: "https://oskitone.github.io",
  baseUrl: "/higher_lower/",

  organizationName: "oskitone",
  projectName: "higher_lower",

  onBrokenLinks: "throw",
  onBrokenMarkdownLinks: "warn",

  i18n: {
    defaultLocale: "en",
    locales: ["en"],
  },

  presets: [
    [
      "classic",
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          routeBasePath: "/",
          sidebarPath: "./sidebars.js",
        },
        blog: false,
        theme: {
          customCss: "./src/css/custom.css",
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      image: "img/assembly-4-40-500.gif",
      navbar: {
        title: "Oskitone Higher Lower Assembly Guide",
      },
      announcementBar: {
        content: `These docs are brand new! Please <a href="https://www.oskitone.com/contact">contact me</a> if it any of it seems wrong or needs more clarification. Thanks!`,
        isCloseable: false,
      },
      footer: {
        style: "dark",
        copyright: `Copyright © ${new Date().getFullYear()} Oskitone. Built with Docusaurus.`,
      },
    }),
};

export default config;
