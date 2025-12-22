;;; STATE.scm — macrauchenia-ssg
;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell

(define metadata
  '((version . "0.3.0")
    (updated . "2025-12-22")
    (project . "macrauchenia-ssg")
    (description . "Deno-based MCP adapters for 28+ static site generators")))

(define current-position
  '((phase . "v0.3 - Testing & Quality")
    (overall-completion . 65)
    (components
     ((rsr-compliance ((status . "complete") (completion . 100)))
      (adapters ((status . "complete") (completion . 100) (count . 28)))
      (security ((status . "complete") (completion . 100)))
      (testing ((status . "in-progress") (completion . 20)))
      (documentation ((status . "in-progress") (completion . 70)))
      (automation ((status . "complete") (completion . 100)))
      (strategic-scm ((status . "complete") (completion . 100)))))))

(define blockers-and-issues
  '((critical ())
    (high-priority
     (("Implement adapter test suite" . "testing")))
    (medium-priority
     (("Add TypeScript types" . "dx")
      ("Complete README.adoc content" . "docs")))))

(define critical-next-actions
  '((immediate
     (("Create unit test infrastructure" . high)
      ("Add tests for critical adapters" . high)))
    (this-week
     (("Achieve 70% test coverage" . high)
      ("Complete E2E tests" . medium)))
    (this-month
     (("Integration tests with poly-ssg-mcp" . medium)
      ("TypeScript declarations" . medium)))))

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
      (notes . "Fixed SCM metadata, security hardening, roadmap created"))
     ((date . "2025-12-22") (session . "infrastructure-complete")
      (notes . "Added justfile, Mustfile, cookbook.adoc, PLAYBOOK.scm, AGENTIC.scm, NEUROSYM.scm, deno.json, CI workflow")))))

(define state-summary
  '((project . "macrauchenia-ssg")
    (version . "0.3.0")
    (completion . 65)
    (blockers . 1)
    (next-milestone . "v0.3 - Testing & Quality")
    (updated . "2025-12-22")))

(define file-inventory
  '((scm-files
     . ("META.scm" "ECOSYSTEM.scm" "STATE.scm" "PLAYBOOK.scm" "AGENTIC.scm" "NEUROSYM.scm"))
    (automation
     . ("justfile" "Mustfile" "deno.json"))
    (documentation
     . ("cookbook.adoc" "README.adoc" "SECURITY.md" "CONTRIBUTING.md"))
    (adapters
     . 28)
    (workflows
     . ("ci.yml" "codeql.yml"))))
