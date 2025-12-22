;;; AGENTIC.scm — macrauchenia-ssg Agentic Behavior Specification
;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell

(define-module (macrauchenia-ssg agentic)
  #:export (agents capabilities protocols interactions))

;; ==========================================================================
;; AGENT DEFINITIONS
;; ==========================================================================

(define agents
  '((adapter-agent
     ((id . "AA-001")
      (type . "executor")
      (description . "Executes SSG CLI commands via MCP tools")
      (responsibilities
       . ("Execute SSG build commands"
          "Validate input parameters"
          "Report execution results"
          "Handle errors gracefully"))
      (constraints
       . ("No direct shell access"
          "Must use Deno.Command API"
          "Input validation required"
          "Timeout limits enforced"))))

    (orchestrator-agent
     ((id . "OA-001")
      (type . "coordinator")
      (description . "Coordinates multi-SSG workflows via poly-ssg-mcp")
      (responsibilities
       . ("Route requests to appropriate adapters"
          "Manage adapter lifecycle (connect/disconnect)"
          "Aggregate results from multiple SSGs"
          "Handle failover and retries"))
      (interfaces
       . ("MCP protocol"
          "Adapter tools API"
          "Health endpoints"))))

    (security-agent
     ((id . "SA-001")
      (type . "guardian")
      (description . "Validates and sanitizes all inputs")
      (responsibilities
       . ("Validate path parameters"
          "Sanitize string inputs"
          "Check port ranges"
          "Verify identifier formats"
          "Block injection attempts"))
      (patterns
       . ("Path validation"
          "String sanitization"
          "Numeric range checks"
          "Regex validation"))))))

;; ==========================================================================
;; CAPABILITIES
;; ==========================================================================

(define capabilities
  '((tool-execution
     ((id . "CAP-001")
      (name . "Tool Execution")
      (description . "Execute SSG CLI tools")
      (permissions
       . ("Deno.run"
          "Deno.Command"
          "File system read"
          "Network (for serve)"))
      (limitations
       . ("No write outside project"
          "No arbitrary shell commands"
          "Sandboxed execution"))))

    (input-validation
     ((id . "CAP-002")
      (name . "Input Validation")
      (description . "Validate and sanitize inputs")
      (validators
       . ((path . "Prevent traversal, block metacharacters")
          (port . "1-65535 range validation")
          (identifier . "Alphanumeric + underscore pattern")
          (url . "Safe URL character set")
          (string . "Language-specific escaping")))
      (response . "Throw Error or return sanitized value")))

    (error-handling
     ((id . "CAP-003")
      (name . "Error Handling")
      (description . "Graceful error handling and reporting")
      (patterns
       . ("Try/catch around all execute()")
          "Return structured error objects"
          "No internal state leakage"
          "User-friendly error messages"))
      (structure
       . ((success . #f)
          (stdout . "")
          (stderr . "Error message")
          (code . 1)))))

    (lifecycle-management
     ((id . "CAP-004")
      (name . "Lifecycle Management")
      (description . "Manage adapter connection state")
      (operations
       . ((connect . "Verify binary availability, set connected=true")
          (disconnect . "Reset state, set connected=false")
          (isConnected . "Return current connection status")))))))

;; ==========================================================================
;; PROTOCOLS
;; ==========================================================================

(define protocols
  '((mcp-tool-protocol
     ((id . "PROTO-001")
      (name . "MCP Tool Protocol")
      (version . "1.0")
      (description . "Tool definition and execution protocol")
      (tool-schema
       . ((name . "String: tool identifier")
          (description . "String: tool description")
          (inputSchema . "JSON Schema for parameters")
          (execute . "Async function (params) => Result")))
      (result-schema
       . ((success . "Boolean: execution success")
          (stdout . "String: standard output")
          (stderr . "String: standard error")
          (code . "Number: exit code")))))

    (validation-protocol
     ((id . "PROTO-002")
      (name . "Input Validation Protocol")
      (version . "1.0")
      (flow
       . ("1. Receive raw input"
          "2. Check type"
          "3. Apply format validation"
          "4. Check for dangerous patterns"
          "5. Return sanitized value or throw Error"))
      (error-format
       . ((type . "Error")
          (message . "User-friendly description")
          (details . "Optional: validation details")))))

    (adapter-protocol
     ((id . "PROTO-003")
      (name . "Adapter Export Protocol")
      (version . "1.0")
      (required-exports
       . ((name . "String: adapter name")
          (language . "String: SSG implementation language")
          (description . "String: SSG description")
          (tools . "Array: tool definitions")
          (connect . "Async function: initialize")
          (disconnect . "Async function: cleanup")
          (isConnected . "Function: check state")))))))

;; ==========================================================================
;; INTERACTIONS
;; ==========================================================================

(define interactions
  '((request-response
     ((pattern . "Synchronous request-response")
      (flow
       . ("1. Client sends tool execution request"
          "2. Adapter validates inputs"
          "3. Adapter executes command"
          "4. Adapter returns structured result"
          "5. Client processes result"))
      (timeout . 120000)
      (retry . "On transient errors, max 3 attempts")))

    (lifecycle
     ((pattern . "Connection lifecycle")
      (states
       . ((disconnected . "Initial state")
          (connecting . "Verifying binary")
          (connected . "Ready for requests")
          (error . "Connection failed")))
      (transitions
       . ((disconnected -> connecting . "connect() called")
          (connecting -> connected . "Binary verified")
          (connecting -> error . "Binary not found")
          (connected -> disconnected . "disconnect() called")
          (error -> connecting . "Retry connect()")))))

    (error-escalation
     ((pattern . "Error handling escalation")
      (levels
       . ((validation-error . "Return error result immediately")
          (execution-error . "Return with exit code")
          (system-error . "Log and return system error")
          (fatal-error . "Disconnect and require reconnect")))))))

;; ==========================================================================
;; BEHAVIOR RULES
;; ==========================================================================

(define behavior-rules
  '((rule-001
     ((name . "Always Validate")
      (description . "All inputs must be validated before use")
      (enforcement . "Required in every execute()")))

    (rule-002
     ((name . "No Eval")
      (description . "Never use eval() or Function()")
      (enforcement . "Lint rule + code review")))

    (rule-003
     ((name . "Array Arguments")
      (description . "Always use array args with Deno.Command")
      (enforcement . "Code review")))

    (rule-004
     ((name . "Graceful Degradation")
      (description . "Always return structured result, never throw unhandled")
      (enforcement . "Try/catch wrapper in all execute()")))

    (rule-005
     ((name . "State Isolation")
      (description . "Adapters must be stateless between requests")
      (enforcement . "Code review")))))
