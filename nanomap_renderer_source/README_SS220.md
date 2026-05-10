# SS220 nanomap renderer source

This directory is a local, repo-owned renderer source tree based on
`ss220club/BandaStationSDMM`.

The committed workflow builds `dmm-tools` from this directory instead of cloning
an external renderer repository. That lets SS220-specific rendering fixes live
next to the game code that needs them, especially fixes for current icon paths,
`icon_state` handling, modular content, and nanomap-only render passes.

Build the renderer binary with:

```sh
cargo build --release --locked --manifest-path nanomap_renderer_source/Cargo.toml -p dmm-tools-cli --bin dmm-tools
```

The GitHub workflow copies the resulting `dmm-tools` binary to:

```text
tools/github-actions/dmm-tools-para
```
