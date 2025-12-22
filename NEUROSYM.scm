;;; NEUROSYM.scm — macrauchenia-ssg Neurosymbolic Reasoning Specification
;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell

(define-module (macrauchenia-ssg neurosym)
  #:export (ontology reasoning inference patterns))

;; ==========================================================================
;; ONTOLOGY
;; ==========================================================================

(define ontology
  '((domain . "Static Site Generation Adapters")
    (version . "1.0.0")

    (concepts
     ;; Core entities
     ((adapter
       ((definition . "A module that wraps an SSG CLI tool")
        (properties
         . ((name . "Unique identifier")
            (language . "Implementation language of underlying SSG")
            (tools . "Collection of executable operations")
            (connected . "Boolean connection state")))
        (relationships
         . ((implements . ssg)
            (provides . tools)
            (validates-with . validator)))))

      (ssg
       ((definition . "Static Site Generator - the underlying build tool")
        (properties
         . ((binary . "Executable path")
            (version . "SSG version")
            (capabilities . "Build, serve, init, etc.")))
        (relationships
         . ((adapted-by . adapter)
            (executes . command)))))

      (tool
       ((definition . "A callable operation exposed by an adapter")
        (properties
         . ((name . "Tool identifier (e.g., zola_build)")
            (description . "Human-readable description")
            (inputSchema . "JSON Schema for parameters")
            (execute . "Async execution function")))
        (relationships
         . ((belongs-to . adapter)
            (validated-by . validator)
            (produces . result)))))

      (validator
       ((definition . "A function that sanitizes and validates input")
        (types
         . ((path . "File system path validation")
            (port . "Network port validation")
            (identifier . "Programming identifier validation")
            (string . "General string sanitization")))
        (relationships
         . ((protects . tool)
            (prevents . vulnerability)))))

      (result
       ((definition . "Structured output from tool execution")
        (properties
         . ((success . "Boolean execution outcome")
            (stdout . "Standard output text")
            (stderr . "Standard error text")
            (code . "Exit code number")))
        (relationships
         . ((produced-by . tool)
            (consumed-by . client)))))

      (vulnerability
       ((definition . "A security weakness that must be prevented")
        (types
         . ((command-injection . "Arbitrary command execution")
            (path-traversal . "Access outside intended directory")
            (code-injection . "Language-specific code execution")))
        (relationships
         . ((prevented-by . validator)
            (detected-by . scanner)))))))

    (hierarchies
     ((is-a
       . ((julia-adapter . adapter)
          (lisp-adapter . adapter)
          (tcl-adapter . adapter)
          (rust-adapter . adapter)))

      (part-of
       . ((tool . adapter)
          (validator . tool)
          (inputSchema . tool)))

      (prevents
       . ((path-validator . path-traversal)
          (port-validator . invalid-port)
          (string-sanitizer . command-injection)))))))

;; ==========================================================================
;; REASONING
;; ==========================================================================

(define reasoning
  '((rules
     ;; Security reasoning
     ((rule . "security/input-validation")
      (antecedent . "Input received from external source")
      (consequent . "Input must be validated before use")
      (confidence . 1.0)
      (rationale . "All external inputs are potentially malicious"))

     ((rule . "security/no-interpolation")
      (antecedent . "Building command for execution")
      (consequent . "Use array arguments, not string interpolation")
      (confidence . 1.0)
      (rationale . "String interpolation enables injection attacks"))

     ((rule . "security/path-safety")
      (antecedent . "Path parameter received")
      (consequent . "Check for '..' and shell metacharacters")
      (confidence . 1.0)
      (rationale . "Path traversal allows unauthorized file access"))

     ;; Quality reasoning
     ((rule . "quality/test-coverage")
      (antecedent . "Code added or modified")
      (consequent . "Tests must be added or updated")
      (confidence . 0.9)
      (rationale . "Untested code is unreliable code"))

     ((rule . "quality/error-handling")
      (antecedent . "Executing external command")
      (consequent . "Wrap in try/catch, return structured error")
      (confidence . 1.0)
      (rationale . "Unhandled errors crash the system"))

     ;; Architectural reasoning
     ((rule . "architecture/single-responsibility")
      (antecedent . "Creating new module")
      (consequent . "Module should have one clear purpose")
      (confidence . 0.85)
      (rationale . "SRP enables maintainability"))

     ((rule . "architecture/stateless")
      (antecedent . "Processing request")
      (consequent . "Do not maintain state between requests")
      (confidence . 0.9)
      (rationale . "Stateless design enables scalability")))

    (inference-chains
     ((chain . "vulnerability-detection")
      (steps
       . ("1. Identify external input"
          "2. Trace input to usage point"
          "3. Check for validation between"
          "4. If no validation: flag vulnerability"
          "5. Classify vulnerability type")))

     ((chain . "adapter-completeness")
      (steps
       . ("1. Load adapter exports"
          "2. Verify required exports present"
          "3. For each tool: verify inputSchema"
          "4. For each tool: verify execute function"
          "5. Rate completeness 0-100%"))))))

;; ==========================================================================
;; INFERENCE
;; ==========================================================================

(define inference
  '((patterns
     ;; Deductive patterns
     ((pattern . "modus-ponens")
      (template . "If P then Q; P; therefore Q")
      (application . "If input-is-external then must-validate; input-is-external; therefore must-validate"))

     ((pattern . "modus-tollens")
      (template . "If P then Q; not Q; therefore not P")
      (application . "If validated then safe; not safe; therefore not validated"))

     ;; Inductive patterns
     ((pattern . "generalization")
      (template . "Observed in N cases; likely in case N+1")
      (application . "6 adapters had injection vulns; check other adapters too"))

     ;; Abductive patterns
     ((pattern . "best-explanation")
      (template . "Observed effect E; hypothesis H explains E best")
      (application . "Observed: injection possible; Best explanation: missing validation")))

    (heuristics
     ;; Security heuristics
     ((heuristic . "assume-hostile")
      (description . "Treat all external input as potentially malicious")
      (application . "User inputs, environment variables, file contents"))

     ((heuristic . "defense-in-depth")
      (description . "Multiple validation layers are better than one")
      (application . "Validate at API boundary AND before execution"))

     ;; Quality heuristics
     ((heuristic . "fail-fast")
      (description . "Detect and report errors as early as possible")
      (application . "Validate immediately upon receiving input"))

     ((heuristic . "explicit-over-implicit")
      (description . "Prefer explicit configuration over magic behavior")
      (application . "Require explicit permissions, paths, ports")))))

;; ==========================================================================
;; PATTERNS
;; ==========================================================================

(define patterns
  '((architectural
     ((pattern . "adapter-template")
      (intent . "Standardized adapter structure")
      (structure
       . ((exports . (name language description tools connect disconnect isConnected))
          (validators . (validatePath validatePort sanitizeString))
          (command . "runCommand(args, cwd) using Deno.Command")
          (tools . "Array of {name, description, inputSchema, execute}")))
      (forces
       . ("Consistency across adapters"
          "Security by default"
          "Easy auditing")))

     ((pattern . "validated-execution")
      (intent . "Secure command execution with validation")
      (structure
       . ((input . "Raw parameters from caller")
          (validation . "Apply type-specific validators")
          (execution . "Deno.Command with array args")
          (result . "Structured {success, stdout, stderr, code}")))
      (consequences
       . ("Prevents injection"
          "Graceful error handling"
          "Auditable execution path"))))

    (security
     ((pattern . "input-sanitization")
      (intent . "Remove or reject dangerous input characters")
      (variants
       . ((whitelist . "Only allow known-safe characters")
          (blacklist . "Reject known-dangerous characters")
          (escape . "Escape special characters")))
      (recommendation . "Prefer whitelist validation"))

     ((pattern . "fail-secure")
      (intent . "On error, fail to safe state")
      (implementation
       . ((validation-error . "Return error, don't execute")
          (execution-error . "Return error result, don't crash")
          (system-error . "Log, return error, maintain state")))
      (anti-pattern . "Catching errors and continuing with partial data")))

    (operational
     ((pattern . "circuit-breaker")
      (intent . "Prevent cascade failures")
      (states . (closed half-open open))
      (application . "SSG binary availability"))

     ((pattern . "retry-with-backoff")
      (intent . "Handle transient failures")
      (parameters
       . ((max-retries . 3)
          (initial-delay . 100)
          (backoff-factor . 2)
          (max-delay . 10000)))
      (application . "Network operations in serve")))))
