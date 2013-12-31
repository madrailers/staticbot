# Staticbot

Staticbot is a server program that:

1. Receives notification that a static site's source has been updated,
2. Compiles the new source of the static site, and
3. Pushes the compiled source to a destination

The original workflow is as follows:

1. Someone changes a preprocessable file (e.g., markdown, coffee-script, Sass, etc) on a "source" branch on GitHub,
2. Staticbot sees that change, takes the new information, and compiles it, and
3. Pushes the compiled version to a "master" or "gh-pages" branch on the same GitHub repo.

That is, if Alice maintains a site on GitHub Pages and Bob submits a simple pull request, Alice can accept it without having to compile Bob's changes locally: Staticbot does that for her.

## License

See `LICENSE`.

## Contributing

Pull requests are welcome!

1. Fork this repo. (click "Fork" button on github)
2. Pull your copy of this repo. (from terminal: git clone git@github.com:<your username>/staticbot)
3. Create a branch for your change. (from terminal: cd staticbot; git checkout -b <feature name>)
4. Make your changes.
5. Commit. (from terminal: git commit -m "<description of your changes>")
6. Push. (from terminal: git push origin)
7. Issue a pull request (in the browser on github.com/<your username>/staticbot, click the pull request button [it's looks like two arrows] and create a pull request)

## Acknowledgements

Alphabetically:

* Brad Grzesiak: [listrophy](https://github.com/listrophy)
* Zach Moneypenny: [whazzmaster](https://github.com/whazzmaster)
