;;; STATE.scm — macrauchenia-ssg
;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell

(define metadata
  '((version . "0.2.0")
    (updated . "2025-12-17")
    (project . "macrauchenia-ssg")
    (description . "Deno-based MCP adapters for 28+ static site generators")))

(define current-position
  '((phase . "v0.2 - Core Development")
    (overall-completion . 35)
    (components
     ((rsr-compliance ((status . "complete") (completion . 100)))
      (adapters ((status . "in-progress") (completion . 60) (count . 28)))
      (security ((status . "in-progress") (completion . 80)))
      (testing ((status . "not-started") (completion . 0)))
      (documentation ((status . "in-progress") (completion . 30)))))))

(define blockers-and-issues
  '((critical ())
    (high-priority
     (("Add input validation to adapters" . "security")
      ("Implement adapter test suite" . "testing")))
    (medium-priority
     (("Add TypeScript types" . "dx")
      ("Complete README.adoc" . "docs")))))

(define critical-next-actions
  '((immediate
     (("Input validation for command args" . critical)
      ("Complete SECURITY.md" . high)))
    (this-week
     (("Add adapter unit tests" . high)
      ("Deno permission audit" . medium)))
    (this-month
     (("Integration tests with poly-ssg-mcp" . medium)
      ("Documentation completion" . medium)))))

(define roadmap
  '((v0.1 ((name . "Initial Setup")
           (status . "complete")
           (date . "2025-12-15")
           (items . ("RSR compliance" "SCM files" "Initial adapters"))))
    (v0.2 ((name . "Core Development")
           (status . "in-progress")
           (target . "2025-12-30")
           (items . ("All 28 adapters implemented"
                     "Input validation hardening"
                     "Security audit complete"
                     "Basic test coverage"))))
    (v0.3 ((name . "Testing & Quality")
           (status . "planned")
           (target . "2026-01-15")
           (items . ("70% test coverage"
                     "TypeScript declarations"
                     "CI/CD integration tests"
                     "Documentation complete"))))
    (v0.4 ((name . "Integration")
           (status . "planned")
           (target . "2026-01-31")
           (items . ("poly-ssg-mcp integration verified"
                     "Performance benchmarks"
                     "Cross-platform testing"))))
    (v1.0 ((name . "Stable Release")
           (status . "planned")
           (target . "2026-02-28")
           (items . ("Production ready"
                     "Full documentation"
                     "Security certification"
                     "Community feedback addressed"))))))

(define session-history
  '((snapshots
     ((date . "2025-12-15") (session . "initial") (notes . "SCM files added"))
     ((date . "2025-12-17") (session . "security-review")
      (notes . "Fixed SCM metadata, security hardening, roadmap created")))))

(define state-summary
  '((project . "macrauchenia-ssg")
    (version . "0.2.0")
    (completion . 35)
    (blockers . 2)
    (next-milestone . "v0.2 - Core Development")
    (updated . "2025-12-17")))
