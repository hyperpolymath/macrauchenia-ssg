;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell
;; ECOSYSTEM.scm — macrauchenia-ssg

(ecosystem
  (version "1.0.0")
  (name "macrauchenia-ssg")
  (type "satellite")
  (purpose "Deno-based MCP adapters for 28+ static site generators")

  (position-in-ecosystem
    "Satellite SSG implementation in hyperpolymath ecosystem.
     Provides Deno adapters that wrap SSG CLIs via MCP protocol.
     Follows RSR guidelines for security and maintainability.")

  (supported-ssg-count 28)
  (adapter-languages '("rust" "haskell" "elixir" "clojure" "julia" "racket"
                       "common-lisp" "ocaml" "erlang" "nim" "d" "scala"))

  (related-projects
    (project
      (name "poly-ssg-mcp")
      (url "https://github.com/hyperpolymath/poly-ssg-mcp")
      (relationship "hub")
      (description "Unified MCP server for 28 SSGs - provides adapter interface")
      (differentiation
        "poly-ssg-mcp = Hub that orchestrates all adapters via MCP
         macrauchenia-ssg = Individual adapter implementations"))
    (project
      (name "rhodium-standard-repositories")
      (url "https://github.com/hyperpolymath/rhodium-standard-repositories")
      (relationship "standard")))

  (what-this-is "Satellite SSG adapter implementation for hyperpolymath ecosystem")
  (what-this-is-not "- NOT the hub server (that's poly-ssg-mcp)
                     - NOT exempt from RSR compliance"))
