---
title: "Getting Started with Hugo"
date: "2026-04-03"
author: "Zach Dai"
blogCategory: "Tools" # "Mathematics" → "Machine Learning" → "Reading Notes & Thoughts" → "Tools"
---

Hugo is a fast and flexible static site generator written in Go.

## Installation

```bash
brew install hugo   # macOS
hugo version
```

## Creating a New Site

```bash
hugo new site mysite
cd mysite
hugo server
```

That's it — your site is live at `http://localhost:1313`.