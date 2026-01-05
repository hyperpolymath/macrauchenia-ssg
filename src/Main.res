// SPDX-License-Identifier: AGPL-3.0-or-later
// SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell
// macrauchenia-ssg - Static site generator (ReScript)

module Config = {
  type t = {
    inputDir: string,
    outputDir: string,
    watch: bool,
    serve: bool,
    port: int,
  }

  let default: t = {
    inputDir: "content",
    outputDir: "dist",
    watch: false,
    serve: false,
    port: 3000,
  }
}

module Builder = {
  type stats = {
    pages: int,
    assets: int,
    duration: float,
  }

  let build = async (config: Config.t): stats => {
    let start = Js.Date.now()
    Js.Console.log(`Building ${config.inputDir} -> ${config.outputDir}`)

    {
      pages: 0,
      assets: 0,
      duration: Js.Date.now() -. start,
    }
  }
}

module Server = {
  let serve = async (~port: int, ~dir: string): unit => {
    Js.Console.log(`Serving ${dir} at http://localhost:${port->Belt.Int.toString}`)
  }
}

let name = "macrauchenia-ssg"
let version = "0.2.0"

let main = async () => {
  Js.Console.log(`${name} v${version}`)

  let config = Config.default
  let stats = await Builder.build(config)

  Js.Console.log(`Built ${stats.pages->Belt.Int.toString} pages, ${stats.assets->Belt.Int.toString} assets`)

  if config.serve {
    await Server.serve(~port=config.port, ~dir=config.outputDir)
  }
}

let _ = main()
